DROP TABLE [MBS].[dbo].[politicacredito001]
DROP TABLE [MBS].[dbo].[politicacredito002]


--001. CRIA A TABELA QUE VAI RECEBER OS DADOS REFERENTES AS OPERACOES DE FATURAMENTO (NOTAS FISCAIS DE SAIDA);
create table mbs..politicacredito001(
	[EMPRESA] [nvarchar](5) NULL, --001-01. LISTA AS EMPRESAS QUE COMERCIALIZAM RENNOVA (EQUILIBRIUM E VDM) E QUE POSSUEM ESTRUTURA COMERCIAL BEM DEFINIDA (PONTO DE MELHORIA: INCLUIR INNOVALAB E MW, SE AINDA EXISTIREM OPERACOES DE VENDA DIRETA QUE JUSTIFIQUEM ESTA ANALISE DE CREDITO);
	[CPF_CNPJ] [nvarchar](50) NULL, --001-02. EXIGIDO PARA ENCONTRAR OCORRENCIAS DE MOVIMENTACOES EM BASES DISTINTAS, JA QUE POSSUIMOS DUPLICIDADES DE CLIENTES E OS CALCULOS DE LIMITES CONSIDERAM OS HISTORICOS DE COMPRAS.
	[CODCLI] [nvarchar](15) NULL,
	[CLIENTE] [nvarchar](100) NULL,
	[VENDEDOR] [nvarchar](101)  NULL, --001-03. DEFINE OS VENDEDORES E SEUS RESPECTIVOS GERENTES CONFORME HIERAQUIAS (DISTRITAL, REGIONAL, NACIONAL);
	[GD] [nvarchar](101)  NULL,
	[GR] [nvarchar](101)  NULL,
	[GN] [nvarchar](101)  NULL,
	[ESPECIALIDADE] [nvarchar](100) NULL, --001-04. CLASSIFICA AS ESPECIALIDADES EXISTENTES NA RENNOVA;
	[SUPERVISOR] [nvarchar](100) NULL, --001-05. DESCREVE OS SUPERVISORES LIGADOS AOS DOCUMENTOS DE SAIDA PARA UMA CATEGORIZACAO POR UNIDADES DE NEGOCIO;
	[NFNUM] [int]  NULL,
	[NUMPARC] [int]  NULL, --001-06. DEFINE O NUMERO DA PARCELA UTILIZADA NO CALCULO DO VALOR MEDIO DE COMPRA PONDERADO;
	[TOTPARC] [int] NULL, --001-07. CORRESPONDE AO NUMERO TOTAL DE PARCELAS VINCULADO A DETERMINADA NOTA FISCAL;
	[VLRPARC] [float] NULL, --001-08. VALOR DA PARCELA, A QUAL UTILIZAREMOS PARA SE CALCULAR O VALOR EM ABERTO POR CLIENTE;
	[VLRNF] [float] NULL, --001-09. COMPORA O TOTAL ADQUIRIDO PELO CLIENTE JUNTO A NOSSA EMPRESA, POR PERIODO, PARA DETERMINAR O VALOR MEDIO PONDERADO AO PARCELAMENTO DA COMPRA;
	[DTFAT] [date] NULL, --001-10. DEFINE A DATA DO FATURAMENTO, PARA SE DETERMINAR O PRAZO M�DIO DE PARCELAMENTO DAS COMPRAS, USADO PARA SE CALCULAR O FATOR DE CREDITO EM ETAPAS POSTERIORES;
	[DTVENC] [date] NULL, --001-11. VERIFICAR OS ATRASOS MEDIOS PONDERADOS, A SEREM USADOS NA CONSTRUCAO DA TABELA PUNITIVA INTERCALADA POR PERIODOS (DESCONTO PROPORCIONAL SOBRE O FATOR DE AJUSTE DE CREDITO INICIAL (1.5x);
	[PRAZOPARC] [int] NULL, --001-12. PRAZO DE VENCIMENTO MEDIO DAS PARCELAS (APENAS UM CAMPO ADICIONAL PARA FACILITAR OS CALCULOS ADIANTE);
	[SAPSALDO] [float] NULL, --001-13. TRAZ O SALDO DO CLIENTE ATUALIZADO APOS A UTILIZACAO DE SEU LIMITE DE CREDITO;
	[STDLIMIT] [float] NULL, --001-14. DEFINE O LIMITE PADRAO DE CREDITO ($20K) POR CLIENTE EM VIGOR DESDE NOV/2020;
	[SAPLIMIT] [float] NULL --001-15. LIMITE PREVIO ESTABELECIDO PELO DEPARTAMENTO DE CREDITO E COBRANCA QUE SERA COMPARADO E REFERENCIADO PARA AJUSTES.
) ON [PRIMARY]

--002. TABELA COMPLEMENTAR A ANTERIOR PARA APOIAR A CRIACAO DE 2 CAMPOS: VALOR PONDERADO DE COMPRA E PRAZO MEDIO DE PAGAMENTO;
CREATE TABLE [MBS].[dbo].[politicacredito002](
	[EMPRESA] [nvarchar](5) NULL,
	[CPF_CNPJ] [nvarchar](50) NULL,
	[CODCLI] [nvarchar](15) NULL,
	[CLIENTE] [nvarchar](100) NULL,
	[VENDEDOR] [nvarchar](101) NULL,
	[GD] [nvarchar](101) NULL,
	[GR] [nvarchar](101) NULL,
	[GN] [nvarchar](101) NULL,
	[ESPECIALIDADE] [nvarchar](100) NULL,
	[SUPERVISOR] [nvarchar](100) NULL,
	[NFNUM] [int] NULL,
	[NUMPARC] [int] NULL,
	[TOTPARC] [int] NULL,
	[VLRPARC] [float] NULL,
	[VLRNF] [float] NULL,
	[DTFAT] [date] NULL,
	[DTVENC] [date] NULL,
	[PRAZOPARC] [int] NULL,
	[PRAZOMEDIO] [int] NULL,
	[VLRPONDERADO] [float] NULL,
	[SAPSALDO] [float] NULL,
	[STDLIMIT] [float] NULL,
	[SAPLIMIT] [float] NULL
) ON [PRIMARY]

use SBOEquilibrium
insert into mbs..politicacredito001
	select distinct
		'EQL' EMPRESA,
		isnull((select top 1 r.lictradnum from ocrd r where r.cardcode = o.cardcode),(select max(case when not (d.taxid0 = '' or d.taxid0 is null) then d.taxid0 else case when not (d.taxid4 = '' or d.taxid4 is null) then d.taxid4 else '' end end) from crd7 d where d.cardcode = o.cardcode)) CPF_CNPJ, 
		o.cardcode CODCLI, 
		o.cardname CLIENTE, 
		isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM ohem WHERE salesprson = 
																											(isnull(o.slpcode,isnull((select r.slpcode from ocrd r where r.cardcode = o.cardcode),null))
																											)),isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM ohem WHERE salesprson = (select r.slpcode from ocrd r where r.cardcode = o.cardcode)),'### SEM_VENDEDOR ###')) VENDEDOR,	
	
		isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM ohem WHERE empId = (SELECT TOP 1 ISNULL (Manager,0) FROM ohem WHERE Salesprson = 
																															(isnull(o.slpcode,isnull((select r.slpcode from ocrd r where r.cardcode = o.cardcode),null))
																															))),'### SEM_GER_DISTRITAL ###') GD,

		isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM ohem WHERE empId = (SELECT ISNULL (Manager,0) FROM ohem WHERE empId = (SELECT TOP 1 ISNULL (Manager,0) FROM ohem WHERE Salesprson = 
																															(isnull(o.slpcode,isnull((select r.slpcode from ocrd r where r.cardcode = o.cardcode),null))
																															)))),'### SEM_GER_REGIONAL ###') GR,

		isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM ohem WHERE empId = (SELECT ISNULL (Manager,0) FROM ohem WHERE empId = (SELECT ISNULL (Manager,0) FROM ohem WHERE empId = (SELECT TOP 1 ISNULL (Manager,0) FROM ohem WHERE Salesprson = 
																															(isnull(o.slpcode,isnull((select r.slpcode from ocrd r where r.cardcode = o.cardcode),null))
																															))))),'### SEM_GER_NACIONAL ###') GN,
		upper(COALESCE((SELECT s.NAME FROM [@ft_oass] s WHERE s.CODE = (select coalesce(case when r.U_ASSOCIACAO in (-1,0,1) then 1 else r.U_ASSOCIACAO end,1) from ocrd r where r.cardcode = o.cardcode)),'### SEM_ESPECIALIDADE ###')) ESPECIALIDADE,
		COALESCE((SELECT h1.name FROM [@ft_ohrq] h1 WHERE h1.code = (SELECT c1.[U_Hierarquia] FROM [@ft_orca] c1 WHERE C1.CODE = 
																															(isnull(o.slpcode,isnull((select r.slpcode from ocrd r where r.cardcode = o.cardcode),null))
																															))),'### SEM_SUPERVISOR ###') SUPERVISOR,
		isnull(o.serial,0) NFNUM,
		i.InstlmntID NUMPARC, 
		O.Installmnt TOTPARC,
		CAST(i.instotal AS FLOAT) VLRPARC, 
		--cast(i.PaidToDate as float) VLRPAGO,
		cast(case when o.DocTotal = 0 then o.Max1099 else o.doctotal end as float) VLRNF,
		CAST(o.DocDate AS DATE) DTFAT,
		CAST(i.DueDate AS DATE) DTVENC,
		DATEDIFF(day,o.DocDate,i.DueDate) PRAZOPARC,
		CAST(isnull((select r.BALANCE from ocrd r where r.cardcode = o.cardcode),0) AS FLOAT) [SAPSALDO],
		CAST('20000' AS FLOAT) STDLIMIT,
		CAST(isnull((select r.CreditLine from ocrd r where r.cardcode = o.cardcode),0) AS FLOAT) SAPLIMIT
	from 
		oinv o inner join 
		inv6 i on i.docentry = o.docentry
--001-16. CRITERIOS USADOS NA CARGA INICIAL DA TABELA politicacredito001:
	where 
		format(o.docdate,'yyyyMM')>=202005 and	--001-16a. Registros validos a partir de maio/2020;
		o.canceled = 'n' and					--001-16b. Entram apenas documentos fiscais NAO cancelados;
		i.instotal > 0 and						--001-16c. Consideramos somente notas fiscais que geraram tItulos no modulo financeiro;
		(select G.GROUPNAME from ocrg g where g.groupcode = (select groupcode from ocrd r where cardcode = o.cardcode)) NOT LIKE '%ligada%' and	--001-16d. NAO participam empresas coligadas;
		COALESCE((SELECT h1.name FROM [@ft_ohrq] h1 WHERE h1.code = (SELECT c1.[U_Hierarquia] FROM [@ft_orca] c1 WHERE C1.CODE = (isnull(o.slpcode,isnull((select r.slpcode from ocrd r where r.cardcode = o.cardcode),null))))),'### SEM_SUPERVISOR ###') like 'renno%' and --001-16e. Permitidos somente supervisores da Rennova;
		(select top 1 r.state1 from ocrd r where r.cardcode = o.cardcode) not like 'EX' --001-16f. NAO se consideram os clientes do Exterior.
			

use SBOVIDAFARMA
insert into mbs..politicacredito001
	select distinct
		'VDM' EMPRESA,
		isnull((select top 1 r.lictradnum from ocrd r where r.cardcode = o.cardcode),(select max(case when not (d.taxid0 = '' or d.taxid0 is null) then d.taxid0 else case when not (d.taxid4 = '' or d.taxid4 is null) then d.taxid4 else '' end end) from crd7 d where d.cardcode = o.cardcode)) CPF_CNPJ, 
		o.cardcode CODCLI, 
		o.cardname CLIENTE, 
		isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM ohem WHERE salesprson = 
																											(isnull(o.slpcode,isnull((select r.slpcode from ocrd r where r.cardcode = o.cardcode),null))
																											)),isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM ohem WHERE salesprson = (select r.slpcode from ocrd r where r.cardcode = o.cardcode)),'### SEM_VENDEDOR ###')) VENDEDOR,	
	
		isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM ohem WHERE empId = (SELECT TOP 1 ISNULL (Manager,0) FROM ohem WHERE Salesprson = 
																															(isnull(o.slpcode,isnull((select r.slpcode from ocrd r where r.cardcode = o.cardcode),null))
																															))),'### SEM_GER_DISTRITAL ###') GD,

		isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM ohem WHERE empId = (SELECT ISNULL (Manager,0) FROM ohem WHERE empId = (SELECT TOP 1 ISNULL (Manager,0) FROM ohem WHERE Salesprson = 
																															(isnull(o.slpcode,isnull((select r.slpcode from ocrd r where r.cardcode = o.cardcode),null))
																															)))),'### SEM_GER_REGIONAL ###') GR,

		isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM ohem WHERE empId = (SELECT ISNULL (Manager,0) FROM ohem WHERE empId = (SELECT ISNULL (Manager,0) FROM ohem WHERE empId = (SELECT TOP 1 ISNULL (Manager,0) FROM ohem WHERE Salesprson = 
																															(isnull(o.slpcode,isnull((select r.slpcode from ocrd r where r.cardcode = o.cardcode),null))
																															))))),'### SEM_GER_NACIONAL ###') GN,
		upper(COALESCE((SELECT s.NAME FROM [@ft_oass] s WHERE s.CODE = (select coalesce(case when r.U_ASSOCIACAO in (-1,0,1) then 1 else r.U_ASSOCIACAO end,1) from ocrd r where r.cardcode = o.cardcode)),'### SEM_ESPECIALIDADE ###')) ESPECIALIDADE,
		COALESCE((SELECT h1.name FROM [@ft_ohrq] h1 WHERE h1.code = (SELECT c1.[U_Hierarquia] FROM [@ft_orca] c1 WHERE C1.CODE = 
																															(isnull(o.slpcode,isnull((select r.slpcode from ocrd r where r.cardcode = o.cardcode),null))
																															))),'### SEM_SUPERVISOR ###') SUPERVISOR,
		isnull(o.serial,0) NFNUM,
		i.InstlmntID NUMPARC, 
		O.Installmnt TOTPARC,
		CAST(i.instotal AS FLOAT) VLRPARC, 
		--cast(i.PaidToDate as float) VLRPAGO,
		cast(case when o.DocTotal = 0 then o.Max1099 else o.doctotal end as float) VLRNF,
		CAST(o.DocDate AS DATE) DTFAT,
		CAST(i.DueDate AS DATE) DTVENC,
		DATEDIFF(day,o.DocDate,i.DueDate) PRAZOPARC,
		CAST(isnull((select r.BALANCE from ocrd r where r.cardcode = o.cardcode),0) AS FLOAT) [SAPSALDO],
		CAST('20000' AS FLOAT) STDLIMIT,
		CAST(isnull((select r.CreditLine from ocrd r where r.cardcode = o.cardcode),0) AS FLOAT) SAPLIMIT
	from 
		oinv o inner join 
		inv6 i on i.docentry = o.docentry
	where 
		format(o.docdate,'yyyyMM')>=202005 and	
		o.canceled = 'n' and					
		i.instotal > 0 and						
		(select G.GROUPNAME from ocrg g where g.groupcode = (select groupcode from ocrd r where cardcode = o.cardcode)) NOT LIKE '%ligada%' and	
		(select top 1 r.state1 from ocrd r where r.cardcode = o.cardcode) not like 'EX' 
			

INSERT INTO [Mbs].[dbo].[politicacredito002] 
	SELECT 
		   [EMPRESA]
		  ,[CPF_CNPJ]
		  ,[CODCLI]
		  ,[CLIENTE]
		  ,[VENDEDOR]
		  ,[GD]
		  ,[GR]
		  ,[GN]
		  ,[ESPECIALIDADE]
		  ,[SUPERVISOR]
		  ,[NFNUM]
		  ,[NUMPARC]
		  ,[TOTPARC]
		  ,case when [VLRPARC] = 0 then 1 else [VLRPARC] end [VLRPARC]
		  ,[VLRNF]
		  ,[DTFAT]
		  ,[DTVENC]
		  ,case when [PRAZOPARC] = 0 then 1 else [PRAZOPARC] end [PRAZOPARC]
		  ,(SELECT AVG(case when [PRAZOPARC] = 0 then 1 else [PRAZOPARC] end) FROM [Mbs].[dbo].[politicacredito001] WHERE CODCLI = P.CODCLI and NFNUM = P.NFNUM) PRAZOMEDIO --002-01. CALCULO DO PRAZO MEDIO DE PAGAMENTO: 
		  ,case when [VLRPARC] = 0 then 1 else [VLRPARC] end*(SELECT AVG(case when [PRAZOPARC] = 0 then 1 else [PRAZOPARC] end) FROM [Mbs].[dbo].[politicacredito001] WHERE CODCLI = P.CODCLI and NFNUM = P.NFNUM) VLRPONDERADO --002-02. CALCULO DO VALOR DE COMPRA PONDERADO MEDIO: 
		  ,[SAPSALDO]
		  ,[STDLIMIT]
		  ,[SAPLIMIT]
	  FROM [Mbs].[dbo].[politicacredito001] P
	  GROUP BY 
		   [EMPRESA]
  		  ,[CPF_CNPJ]
		  ,[CODCLI]
		  ,[CLIENTE]
		  ,[VENDEDOR]
		  ,[GD]
		  ,[GR]
		  ,[GN]
		  ,[ESPECIALIDADE]
		  ,[SUPERVISOR]
		  ,[NFNUM]
		  ,[NUMPARC]
		  ,[TOTPARC]
		  ,[VLRPARC]
		  ,[VLRNF]
		  ,[DTFAT]
		  ,[DTVENC]
		  ,[PRAZOPARC]
		  ,[SAPSALDO]
		  ,[STDLIMIT]
		  ,[SAPLIMIT]


DROP TABLE MBS..[politicacredito004]

--003. TABELA COMPLEMENTAR PARA TRANSFORMAR E OBTER OS DADOS REFERENTES AO VALOR PONDERADO MEDIO, PRAZO MEDIO EM ABERTO, FATOR MENSAL EM ABERTO, SALDO MEDIO DO CLIENTE EM ABERTO
CREATE TABLE MBS..[politicacredito004](
	[EMPRESA] [nvarchar](5) NULL,
	[CPF_CNPJ] [nvarchar](50) NULL,
	[CODCLI] [nvarchar](15) NULL,
	[CLIENTE] [nvarchar](100) NULL,
	[VENDEDOR] [nvarchar](101) NULL,
	[GD] [nvarchar](101) NULL,
	[GR] [nvarchar](101) NULL,
	[GN] [nvarchar](101) NULL,
	[ESPECIALIDADE] [nvarchar](100) NULL,
	[SUPERVISOR] [nvarchar](100) NULL,
	[NFNUM] [int] NULL,
	[NUMPARC] [int] NULL,
	[TOTPARC] [int] NULL,
	[VLRPARC] [float] NULL,
	[VLRNF] [float] NULL,
	[DTFAT] [date] NULL,
	[DTVENC] [date] NULL,
	[PRAZOPARC] [int] NULL,
	[PRAZOMEDIO] [int] NULL,
	[VLRPONDERADOMEDIO] [float] NULL,
	[PRAZOMEDIOABERTO] [float] NULL,
	[FATORMESABERTO] [float] NULL,
	[SALDOMEDIOABERTO] [float] NULL,
	[SAPSALDO] [float] NULL,
	[STDLIMIT] [float] NULL,
	[SAPLIMIT] [float] NULL,
	[CALLIMIT] [float] NULL,
	[SUGLIMIT] [float] NULL
) ON [PRIMARY]

INSERT INTO MBS..[politicacredito004]
	SELECT 
		   [EMPRESA]
		  ,[CPF_CNPJ]
		  ,[CODCLI]
		  ,[CLIENTE]
		  ,[VENDEDOR]
		  ,[GD]
		  ,[GR]
		  ,[GN]
		  ,[ESPECIALIDADE]
		  ,[SUPERVISOR]
		  ,[NFNUM]
		  ,[NUMPARC]
		  ,[TOTPARC]
		  ,[VLRPARC]
		  ,[VLRNF]
		  ,[DTFAT]
		  ,[DTVENC]
		  ,[PRAZOPARC]
		  ,[PRAZOMEDIO]
		  ,ROUND((SELECT SUM([VLRPONDERADO])/((SUM([PRAZOMEDIO])/AVG(CONVERT(FLOAT,[TOTPARC])))) FROM [Mbs].[dbo].[politicacredito002] WHERE CODCLI = P2.CODCLI),-1) VLRPONDERADOMEDIO --003-01. FORMULA DO VALOR PONDERADO MEDIO:
		  ,ROUND((SELECT SUM([VLRPONDERADO])/SUM([VLRPARC]) FROM [Mbs].[dbo].[politicacredito002] WHERE CODCLI = P2.CODCLI),-1) PRAZOMEDIOABERTO --003-02. FORMULA DO PRAZO MEDIO EM ABERTO:
		  ,ROUND((SELECT SUM([VLRPONDERADO])/SUM([VLRPARC]) FROM [Mbs].[dbo].[politicacredito002] WHERE CODCLI = P2.CODCLI)/30,2) FATORMESABERTO --003-03. FORMULA DO FATOR MENSAL ABERTO:
		  ,ROUND((SELECT SUM([VLRPONDERADO])/((SUM([PRAZOMEDIO])/AVG(CONVERT(FLOAT,[TOTPARC])))) FROM [Mbs].[dbo].[politicacredito002] WHERE CODCLI = P2.CODCLI)*(SELECT SUM([VLRPONDERADO])/SUM([VLRPARC]) FROM [Mbs].[dbo].[politicacredito002] WHERE CODCLI = P2.CODCLI)/30,-1) SALDOMEDIOABERTO --003-04. FORMULA DO SALDO MEDIO DO CLIENTE EM ABERTO:
		  ,ROUND([SAPSALDO],-1) [SAPSALDO]
		  ,[STDLIMIT]
		  ,[SAPLIMIT], 0 CALLIMIT, 0 SUGLIMIT
	  FROM [Mbs].[dbo].[politicacredito002] P2
	  GROUP BY
		   [EMPRESA]
  		  ,[CPF_CNPJ]
		  ,[CODCLI]
		  ,[CLIENTE]
		  ,[VENDEDOR]
		  ,[GD]
		  ,[GR]
		  ,[GN]
		  ,[ESPECIALIDADE]
		  ,[SUPERVISOR]
		  ,[NFNUM]
		  ,[NUMPARC]
		  ,[TOTPARC]
		  ,[VLRPARC]
		  ,[VLRNF]
		  ,[DTFAT]
		  ,[DTVENC]
		  ,[PRAZOPARC]
		  ,[PRAZOMEDIO]
		  ,[SAPSALDO]
		  ,[STDLIMIT]
		  ,[SAPLIMIT]

DROP TABLE MBS..politicacredito005

--004. TABELA COMPLEMENTAR AGRUPADORA DE CAMPOS EM UM UNICO TEXTO PARA ELIMINAR LINHAS DUPLICADAS, CUJOS CAMPOS CONSIDERADOS EXCLUSIVOS POSSUEM INFORMACOES DISTINTAS PARA UM MESMO CNPJ;
CREATE TABLE MBS..[politicacredito005](
	[CPF_CNPJ] [nvarchar](50) NULL,
	[CODCLI] [nvarchar](4000) NULL,
	[CLIENTE] [nvarchar](4000) NULL,
	[VENDEDOR] [nvarchar](4000) NULL,
	[GD] [nvarchar](4000) NULL,
	[GR] [nvarchar](4000) NULL,
	[GN] [nvarchar](4000) NULL,
	[ESPECIALIDADE] [nvarchar](4000) NULL,
	[SUPERVISOR] [nvarchar](4000) NULL,
	[VLRPONDERADOMEDIO] [float] NULL,
	[PRAZOMEDIOABERTO] [float] NULL,
	[FATORMESABERTO] [float] NULL,
	[SALDOMEDIOABERTO] [float] NULL,
	[SAPSALDO] [float] NULL,
	[STDLIMIT] [float] NULL,
	[SAPLIMIT] [float] NULL,
	[CALLIMIT] [float] NULL,
	[SUGLIMIT] [float] NULL
) ON [PRIMARY]

INSERT INTO MBS..politicacredito005
	SELECT
		[CPF_CNPJ]
		,STRING_AGG(EMPRESA + ' - ' + [CODCLI],' | ') [CODCLI] --004-01. AGRUPA EMPRESAS E CODIGOS DE CLIENTES DISTINTOS QUE APONTAM PARA UM MESMO CNPJ;
		,STRING_AGG([CLIENTE],' | ') [CLIENTE] --004-02. AGRUPA NOMES DE CLIENTES DISTINTOS QUE APONTAM PARA UM MESMO CNPJ;
		,STRING_AGG([VENDEDOR],' | ') VENDEDOR --004-03. AGRUPA VENDEDORES DISTINTOS QUE APONTAM PARA UM MESMO CNPJ;
		,STRING_AGG([GD],' | ') [GD] --004-04. AGRUPA GERENTES DISTRITAIS DISTINTOS QUE APONTAM PARA UM MESMO CNPJ;
		,STRING_AGG([GR],' | ') [GR] --004-05. AGRUPA GERENTES REGIONAIS DISTINTOS QUE APONTAM PARA UM MESMO CNPJ;
		,STRING_AGG([GN],' | ') [GN] --004-06. AGRUPA GERENTES NACIONAIS DISTINTOS QUE APONTAM PARA UM MESMO CNPJ;
		,STRING_AGG([ESPECIALIDADE],' | ') [ESPECIALIDADE] --004-07. AGRUPA ESPECIALIDADES DISTINTAS QUE APONTAM PARA UM MESMO CNPJ;
		,STRING_AGG([SUPERVISOR],' | ') [SUPERVISOR] --004-08. AGRUPA SUPERVISORES DISTINTOS QUE APONTAM PARA UM MESMO CNPJ;
		,MAX([VLRPONDERADOMEDIO]) [VLRPONDERADOMEDIO]
		,MAX([PRAZOMEDIOABERTO]) [PRAZOMEDIOABERTO]
		,MAX([FATORMESABERTO]) [FATORMESABERTO]
		,MAX([SALDOMEDIOABERTO]) [SALDOMEDIOABERTO]
		,MAX([SAPSALDO]) [SAPSALDO]
		,MAX([STDLIMIT]) [STDLIMIT]
		,MAX([SAPLIMIT]) [SAPLIMIT]
		,MAX([CALLIMIT]) [CALLIMIT]
		,MAX([SUGLIMIT]) [SUGLIMIT]
	FROM (
		SELECT DISTINCT       
					EMPRESA,
					[CPF_CNPJ]
					,[CODCLI]
					,[CLIENTE]
					,[VENDEDOR]
					,[GD]
					,[GR]
					,[GN]
					,[ESPECIALIDADE]
					,[SUPERVISOR]
					,[VLRPONDERADOMEDIO]
					,[PRAZOMEDIOABERTO]
					,[FATORMESABERTO]
					,[SALDOMEDIOABERTO]
					,[SAPSALDO]
					,[STDLIMIT]
					,[SAPLIMIT]
					,[CALLIMIT]
					,[SUGLIMIT] 
	FROM [Mbs].[dbo].[politicacredito004]) X
	GROUP BY [CPF_CNPJ]

--007. TABELA FINAL CONTENDO A JUNCAO DE 2 POLITICAS DISTINTAS: RELACAO DE CLIENTES A PARTIR DO FATURAMENTO X RELACAO DE CLIENTES A PARTIR DO RECEBIMENTO;   
SELECT 
	 PC5.[CPF_CNPJ]
	,PC5.[CODCLI]
	,PC5.[CLIENTE]
	,PC5.[VENDEDOR]
	,PC5.[GD]
	,PC5.[GR]
	,PC5.[GN]
	,PC5.[ESPECIALIDADE]
	,PC5.[SUPERVISOR]
	,PC5.[VLRPONDERADOMEDIO]
	,PC5.[PRAZOMEDIOABERTO]
	,PC5.[FATORMESABERTO]
	,PC5.[SALDOMEDIOABERTO]
	,PC5.[SAPSALDO]
	,PC5.[STDLIMIT]
	,PC5.[SAPLIMIT]
	,ROUND(((PC5.[VLRPONDERADOMEDIO] * PC5.[FATORMESABERTO]) * 1.5),-1) [CALLIMIT] --007-01. FORMULA DO LIMITE CALCULADO MAXIMO ESTABELECIDO PELO SISTEMA COM BASE NO FATURAMENTO MEDIO PONDERADO (SEM PUNICAO);
	,ISNULL(PC6.ATRASOMEDIO,0) ATRASOMEDIO --007-02. FORMULA DO ATRASO MEDIO PONDERADO A PARTIR DOS DADOS DE RECEBIMENTO DO CLIENTE;
	,ISNULL(PC6.FCMEDIO,0) FCMEDIO --007-03. FATOR DE CORRECAO MEDIO OBTIDO A PARTIR DE UMA TABELA REGRESSIVA E PUNITIVA POR ATRASO MEDIO DO CLIENTE;
	,ROUND(CASE	
			WHEN ((PC5.[VLRPONDERADOMEDIO] * PC5.[FATORMESABERTO]) * 1.5) < [STDLIMIT] THEN [STDLIMIT]/1.5 * ISNULL(PC6.FCMEDIO,0)
			WHEN ((PC5.[VLRPONDERADOMEDIO] * PC5.[FATORMESABERTO]) * 1.5) > SAPLIMIT THEN ((PC5.[VLRPONDERADOMEDIO] * PC5.[FATORMESABERTO])) * ISNULL(PC6.FCMEDIO,0)
			ELSE [SAPLIMIT] * ISNULL(PC6.FCMEDIO,0)
		  END,-1) SUGLIMIT --007-04. FORMULA DO LIMITE SUGERIDO PELO SISTEMA PARA AJUSTE DO LIMITE DE CREDITO VIGENTE NO CLIENTE (JA APLICADO O FATOR DE CORRECAO PUNITIVO POR ATRASO).
FROM 
	[Mbs].[dbo].[politicacredito005] PC5 LEFT JOIN
	[Mbs].[dbo].[politicacredito006] PC6 ON PC5.CPF_CNPJ = PC6.[CPF_CNPJ]
