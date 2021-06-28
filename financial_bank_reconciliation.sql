DECLARE @loop int = (SELECT COUNT(baseid) FROM MBS..BASES);
DECLARE @i int = 0; 
DECLARE @empresa nvarchar(MAX);
DECLARE @pathoinv nvarchar(MAX);
DECLARE @pathorin nvarchar(MAX);
DECLARE @pathinv6 nvarchar(MAX);
DECLARE @pathjdt1 nvarchar(MAX);
DECLARE @pathocrd nvarchar(MAX);
DECLARE @pathcrd7 nvarchar(MAX);
DECLARE @pathocrg nvarchar(MAX);
DECLARE @pathohem nvarchar(MAX);
DECLARE @pathORCA nvarchar(MAX);
DECLARE @pathOHRQ nvarchar(MAX);
DECLARE @pathOASS nvarchar(MAX);
declare @body varchar(max);
declare @subj nvarchar(max) = '';
declare @mes int = 10;
declare @pivot as TABLE ([ID] nchar(3),[TIPO] [nvarchar](100),[CLIENTE] [nvarchar](max),[CNPJ] [nvarchar](30),[UPDATED] [nvarchar](max),[FAT NF SAIDA] DECIMAL(18,2),[LANC CONTABIL MANUAL] DECIMAL(18,2),[CONTAS A RECEBER] DECIMAL(18,2),[DEV NF SAIDA] DECIMAL(18,2),[CONTAS A PAGAR] DECIMAL(18,2),[TOTAL] DECIMAL(18,2));

declare @mesextenso nvarchar(max) = 
									CASE
										WHEN @mes = 1 THEN 'Jan'
										WHEN @mes = 2 THEN 'Fev'
										WHEN @mes = 3 THEN 'Mar'
										WHEN @mes = 4 THEN 'Abr'
										WHEN @mes = 5 THEN 'Maio'
										WHEN @mes = 6 THEN 'Jun'
										WHEN @mes = 7 THEN 'Jul'
										WHEN @mes = 8 THEN 'Ago'
										WHEN @mes = 9 THEN 'Set'
										WHEN @mes = 10 THEN 'Out'
										WHEN @mes = 11 THEN 'Nov'
										WHEN @mes = 12 THEN 'Dez'
									END;


DROP TABLE mbs.[dbo].[rpa014]

CREATE TABLE mbs.[dbo].[rpa014](
	[BASE] [nvarchar](25) NULL,
	[FILIAL] [nvarchar](100) NULL,
	[MODELO] [nvarchar](23) NULL,
	[SAPTRANS] [int] NULL,
	[SAPREF] [int] NULL,
	[NF] [int] NULL,
	[PERIODO] [int] NULL,
	[TIPO_VENC] [nvarchar](20) NULL,
	[DTEMIS] [date] NULL,
	[DTVENC] [date] NULL,
	[DTPGTO] [date] NULL,
	[CODCLI] [nvarchar](15) NULL,
	[CLIENTE] [nvarchar](100) NULL,
	[CNPJ] [nvarchar](30) NULL,
	[VENDEDOR] [nvarchar](100) NULL,
	[GD] [nvarchar](100) NULL,
	[GR] [nvarchar](100) NULL,
	[GN] [nvarchar](100) NULL,
	[ESPECIALIDADE] [nvarchar](100) NULL,
	[SUPERVISOR] [nvarchar](100) NULL,
	[CATEGORIA] [varchar](15) NULL,
	[PARC#] [nvarchar](6) NULL,
	[VLRPARC] [float] NULL,
	[SALDOPARC] [float] NULL,
	[SALDOATUAL] [float] NULL,
	[DEB_CRED] [nvarchar](1) NULL,
	[TIPO] [varchar](10) NULL,
	[OBS] [nvarchar](80) NULL,
	[UPDATED] [datetime] NULL
) ON [PRIMARY]

while @i < @loop
	begin
		set @i = @i + 1;
		set @empresa = (select empresa from MBS..BASES where baseid = @i);
		set @pathoinv = CONCAT(N'CREATE SYNONYM tpathoinv FOR ',@empresa,N'.DBO.oinv');
		set @pathorin = CONCAT(N'CREATE SYNONYM tpathorin FOR ',@empresa,N'.DBO.orin');
		set @pathinv6 = CONCAT(N'CREATE SYNONYM tpathinv6 FOR ',@empresa,N'.DBO.inv6');
		set @pathjdt1 = CONCAT(N'CREATE SYNONYM tpathjdt1 FOR ',@empresa,N'.DBO.jdt1');
		set @pathocrd = CONCAT(N'CREATE SYNONYM tpathocrd FOR ',@empresa,N'.DBO.ocrd');
		set @pathcrd7 = CONCAT(N'CREATE SYNONYM tpathcrd7 FOR ',@empresa,N'.DBO.crd7');
		set @pathocrg = CONCAT(N'CREATE SYNONYM tpathocrg FOR ',@empresa,N'.DBO.ocrg');
		set @pathohem = CONCAT(N'CREATE SYNONYM tpathohem FOR ',@empresa,N'.DBO.ohem');
		set @pathORCA = CONCAT(N'CREATE SYNONYM tpathORCA FOR ',@empresa,N'.DBO.[@FT_ORCA]');
		set @pathOHRQ = CONCAT(N'CREATE SYNONYM tpathOHRQ FOR ',@empresa,N'.DBO.[@FT_OHRQ]');
		set @pathOASS = CONCAT(N'CREATE SYNONYM tpathOASS FOR ',@empresa,N'.DBO.[@FT_OASS]');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathoinv') > 0 BEGIN DROP SYNONYM tpathoinv; EXEC(@pathoinv); END ELSE BEGIN exec(@pathoinv); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathorin') > 0 BEGIN DROP SYNONYM tpathorin; EXEC(@pathorin); END ELSE BEGIN exec(@pathorin); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathinv6') > 0 BEGIN DROP SYNONYM tpathinv6; EXEC(@pathinv6); END ELSE BEGIN exec(@pathinv6); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathjdt1') > 0 BEGIN DROP SYNONYM tpathjdt1; EXEC(@pathjdt1); END ELSE BEGIN exec(@pathjdt1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathocrd') > 0 BEGIN DROP SYNONYM tpathocrd; EXEC(@pathocrd); END ELSE BEGIN exec(@pathocrd); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathcrd7') > 0 BEGIN DROP SYNONYM tpathcrd7; EXEC(@pathcrd7); END ELSE BEGIN exec(@pathcrd7); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathocrg') > 0 BEGIN DROP SYNONYM tpathocrg; EXEC(@pathocrg); END ELSE BEGIN exec(@pathocrg); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathohem') > 0 BEGIN DROP SYNONYM tpathohem; EXEC(@pathohem); END ELSE BEGIN exec(@pathohem); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathORCA') > 0 BEGIN DROP SYNONYM tpathORCA; EXEC(@pathORCA); END ELSE BEGIN exec(@pathORCA); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOHRQ') > 0 BEGIN DROP SYNONYM tpathOHRQ; EXEC(@pathOHRQ); END ELSE BEGIN exec(@pathOHRQ); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOASS') > 0 BEGIN DROP SYNONYM tpathOASS; EXEC(@pathOASS); END ELSE BEGIN exec(@pathOASS); END

INSERT INTO mbs.[dbo].[rpa014]
		select
			UPPER(@empresa) BASE, 
			coalesce(UPPER(j.bplname),replace(upper(@empresa),'sbo','')) FILIAL,
			CASE 
				WHEN J.TRANSTYPE = '13' THEN 'FAT NF SAIDA'
				WHEN J.TRANSTYPE = '14' THEN 'DEV NF SAIDA'
				WHEN J.TRANSTYPE = '15' THEN 'FAT NF ENTREGA'
				WHEN J.TRANSTYPE = '16' THEN 'DEV NF ENTREGA'
				WHEN J.TRANSTYPE = '18' THEN 'FAT NF ENTRADA'
				WHEN J.TRANSTYPE = '19' THEN 'DEV NF ENTRADA'
				WHEN J.TRANSTYPE = '20' THEN 'REC MERC COMPRAS'
				WHEN J.TRANSTYPE = '24' THEN 'CONTAS A RECEBER'
				WHEN J.TRANSTYPE = '25' THEN 'DEPOSITOS'
				WHEN J.TRANSTYPE = '30' THEN 'LANC CONTABIL MANUAL'
				WHEN J.TRANSTYPE = '46' THEN 'CONTAS A PAGAR'
				WHEN J.TRANSTYPE = '59' THEN 'ENTRADA INSUMOS'
				WHEN J.TRANSTYPE = '60' THEN 'SAIDA INSUMOS'
				WHEN J.TRANSTYPE = '67' THEN 'TRANSF ESTOQUE'
				WHEN J.TRANSTYPE = '69' THEN 'NF TRANSPORTE'
				WHEN J.TRANSTYPE = '162' THEN 'REAVALIACAO ESTOQUE'
				WHEN J.TRANSTYPE = '202' THEN 'ORDEM PRODUCAO'
				WHEN J.TRANSTYPE = '203' THEN 'ADIANTAMENTO CONTAS REC'
				WHEN J.TRANSTYPE = '204' THEN 'ADIANTAMENTO FORNECEDOR'
				WHEN J.TRANSTYPE = '321' THEN 'RECONCILIACAO INTERNA'
				WHEN J.TRANSTYPE = '10000071' THEN 'AJUSTE INVENTARIO'
				ELSE J.TRANSTYPE 
			END MODELO,
			j.TRANSID SAPTRANS, 
			j.baseref SAPREF, 
			j.ref1 NF, 
			YEAR(j.refDATE) PERIODO,
			CASE WHEN j.refDATE = j.DUEDATE THEN 'A VISTA' ELSE 'PARCELADO' END TIPO_VENC,
			CAST(j.refDATE AS DATE) DTNF, 
			CAST(j.DUEDATE AS DATE) DTVENC, 		
			coalesce(CAST(j.MthDate AS DATE),'') DTPGTO, 
			j.shortname CODCLI, 
			(select r.CARDNAME from tpathocrd r where r.cardcode = j.shortname) CLIENTE, 
			isnull((select top 1 r.lictradnum from tpathocrd r where r.cardcode = j.shortname),(select max(case when not (d.taxid0 = '' or d.taxid0 is null) then d.taxid0 else case when not (d.taxid4 = '' or d.taxid4 is null) then d.taxid4 else '' end end) from tpathcrd7 d where d.cardcode = j.shortname)) CPF_CNPJ, 
			isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM tpathohem WHERE salesprson = 
																												(isnull((case 
																																when j.transtype = 13 then isnull((select top 1 slpcode from tpathoinv where cardcode = j.shortname and transid = j.transid),null)
																																when j.transtype = 14 then isnull((select top 1 slpcode from tpathorin where cardcode = j.shortname and transid = j.transid),null)
																																else null end),isnull((select r.slpcode from tpathocrd r where r.cardcode = j.shortname),null))
																												)),isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM tpathohem WHERE salesprson = (select r.slpcode from tpathocrd r where r.cardcode = j.shortname)),'### SEM_VENDEDOR ###')) VENDEDOR,	
	
			isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM tpathohem WHERE empId = (SELECT TOP 1 ISNULL (Manager,0) FROM tpathohem WHERE Salesprson = 
																																(isnull((case 
																																				when j.transtype = 13 then isnull((select top 1 slpcode from tpathoinv where cardcode = j.shortname and transid = j.transid),null)
																																				when j.transtype = 14 then isnull((select top 1 slpcode from tpathorin where cardcode = j.shortname and transid = j.transid),null)
																																				else null end),isnull((select r.slpcode from tpathocrd r where r.cardcode = j.shortname),null))
																																))),'### SEM_GER_DISTRITAL ###') GD,

			isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM tpathohem WHERE empId = (SELECT ISNULL (Manager,0) FROM tpathohem WHERE empId = (SELECT TOP 1 ISNULL (Manager,0) FROM tpathohem WHERE Salesprson = 
																																(isnull((case 
																																				when j.transtype = 13 then isnull((select top 1 slpcode from tpathoinv where cardcode = j.shortname and transid = j.transid),null)
																																				when j.transtype = 14 then isnull((select top 1 slpcode from tpathorin where cardcode = j.shortname and transid = j.transid),null)
																																				else null end),isnull((select r.slpcode from tpathocrd r where r.cardcode = j.shortname),null))
																																)))),'### SEM_GER_REGIONAL ###') GR,

			isnull((SELECT TOP 1 ISNULL(FirstName,'') +' ' + ISNULL(LastName,'') FROM tpathohem WHERE empId = (SELECT ISNULL (Manager,0) FROM tpathohem WHERE empId = (SELECT ISNULL (Manager,0) FROM tpathohem WHERE empId = (SELECT TOP 1 ISNULL (Manager,0) FROM tpathohem WHERE Salesprson = 
																																(isnull((case 
																																				when j.transtype = 13 then isnull((select top 1 slpcode from tpathoinv where cardcode = j.shortname and transid = j.transid),null)
																																				when j.transtype = 14 then isnull((select top 1 slpcode from tpathorin where cardcode = j.shortname and transid = j.transid),null)
																																				else null end),isnull((select r.slpcode from tpathocrd r where r.cardcode = j.shortname),null))
																																))))),'### SEM_GER_NACIONAL ###') GN,
			upper(COALESCE((SELECT s.NAME FROM tpathoass s WHERE s.CODE = (select coalesce(case when r.U_ASSOCIACAO in (-1,0,1) then 1 else r.U_ASSOCIACAO end,1) from tpathocrd r where r.cardcode = j.shortname)),'### SEM_ESPECIALIDADE ###')) ESPECIALIDADE,
			COALESCE((SELECT h1.name FROM tpathohrq h1 WHERE h1.code = (SELECT c1.[U_Hierarquia] FROM tpathorca c1 WHERE C1.CODE = 
																																(isnull((case 
																																				when j.transtype = 13 then isnull((select top 1 slpcode from tpathoinv where cardcode = j.shortname and transid = j.transid),null)
																																				when j.transtype = 14 then isnull((select top 1 slpcode from tpathorin where cardcode = j.shortname and transid = j.transid),null)
																																				else null end),isnull((select r.slpcode from tpathocrd r where r.cardcode = j.shortname),null))
																																))),'### SEM_SUPERVISOR ###') SUPERVISOR,
			case
				when left(j.contraact,3) = '3.1' then 'VENDA'
				when left(j.contraact,1) = '1' then 'DESDOBRAMENTO'
				when left(j.contraact,1) = '7' then 'IMPOSTO'
				else 'OUTROS'
			end CATEGORIA,
			FORMAT(COALESCE(abs(j.sourceline),1),'00') [PARC#],
			(CASE WHEN J.DEBCRED = 'D' THEN 1 ELSE -1 END) * round(CAST(J.DEBIT+J.CREDIT AS FLOAT),2) VLRPARC,
			(CASE WHEN J.DEBCRED = 'D' THEN 1 ELSE -1 END) * CAST(((J.balduedeb + J.balduecred)) AS FLOAT) SALDOPARC,
			CAST((select r.balance from tpathocrd r where r.cardcode = j.shortname) as float) SALDOATUAL,
			J.DEBCRED DEB_CRED,
			case
				when (select G.GROUPNAME from tpathocrg g where g.groupcode = (select r.groupcode from tpathocrd r where r.cardcode = j.shortname)) LIKE '%ENTE%BLICO%' then 'PUBLICO'
				else 'PRIVADO'
			end TIPO,
			left(REPLACE(REPLACE(REPLACE(COALESCE(j.linememo, ''),CHAR(13),' | '),CHAR(10),' | '),CHAR(9),' | '),80) OBS,
			getdate() UPDATED
		from 
			tpathjdt1 j 
		where 
			(j.balduedeb + j.balduecred) > 0 
			AND (select G.GROUPNAME from tpathocrg g where g.groupcode = (select groupcode from tpathocrd r where cardcode = j.shortname)) NOT LIKE '%ligada%' 
			AND	left(j.shortname,1) = 'C' 
			AND (CASE WHEN J.DEBCRED = 'D' THEN CAST(j.DUEDATE AS DATE) ELSE CAST(j.REFDATE AS DATE) END) < (getdate() - 5)
			AND (select top 1 r.state1 from tpathocrd r where r.cardcode = j.shortname) not like 'EX'
	end;




	SELECT [BASE]
      ,[FILIAL]
      ,[MODELO]
      ,[SAPTRANS]
      ,[SAPREF]
      ,[NF]
      ,[PERIODO]
      ,[TIPO_VENC]
      ,[DTEMIS]
      ,[DTVENC]
      ,[DTPGTO]
      ,[CLIENTE] + ' (' + [CODCLI] + ')' CLIENTE
	  ,[CNPJ]
      ,[VENDEDOR]
      ,[GD]
      ,[GR]
      ,[GN]
      ,[ESPECIALIDADE]
      ,[SUPERVISOR]
      ,[CATEGORIA]
      ,[PARC#]
      ,round([VLRPARC],0) [VLRPARC]
      ,round([SALDOPARC],0) [SALDOPARC]
      ,round([SALDOATUAL],0) [SALDOATUAL]
      ,[DEB_CRED]
      ,[TIPO]
      ,[OBS]
      ,[UPDATED]
FROM [Mbs].[dbo].[rpa014]


if OBJECT_ID('tempdb..##RPA014') is not null
	BEGIN
		DROP TABLE ##rpa014
	END

CREATE TABLE ##rpa014(
	[TIPO] [nvarchar](100) NULL,
	[CLIENTE] [nvarchar](max) NULL,
	[CNPJ] [nvarchar](30) NULL,
	[MODELO] [nvarchar](30) NULL,
	[SALDOPARC] [float] NULL,
	[UPDATED] [datetime] NULL
) ON [PRIMARY]

INSERT INTO ##rpa014
	SELECT
		   [TIPO]
		  ,UPPER(RTRIM(LEFT(replace([BASE],'sbo',''),3))) + '_' + REPLACE(left([CLIENTE],20),' ','_') + ' (' + [CODCLI] + ')' CLIENTE
		  ,[CNPJ]
		  ,[MODELO]
		  ,round(sum([SALDOPARC]),0) [SALDOPARC]
		  ,[UPDATED]
	FROM [Mbs].[dbo].[rpa014]
	where cnpj not like ''
	group by
		   [TIPO]
		  ,[CNPJ]
		  ,UPPER(RTRIM(LEFT(replace([BASE],'sbo',''),3))) + '_' + REPLACE(left([CLIENTE],20),' ','_') + ' (' + [CODCLI] + ')'
		  ,[MODELO]
		  ,[UPDATED]
	ORDER BY CNPJ


INSERT INTO @pivot
	SELECT concat('id',ROW_NUMBER() OVER (ORDER BY [CLIENTE]) % 2) ID,
		[TIPO], 
		REPLACE([CLIENTE],' ','_') [CLIENTE], 
		[CNPJ], 
		FORMAT([UPDATED],'dd/MM/yyyy HH:mm') UPDATED,
		ISNULL([FAT NF SAIDA],0) FAT,
		ISNULL([LANC CONTABIL MANUAL],0) LC,
		ISNULL([CONTAS A RECEBER],0) CR,
		ISNULL([DEV NF SAIDA],0) DEV,
		ISNULL([CONTAS A PAGAR],0) CP, 
		(ISNULL([FAT NF SAIDA],0)+ISNULL([LANC CONTABIL MANUAL],0)+ISNULL([CONTAS A RECEBER],0)+ISNULL([DEV NF SAIDA],0)+ISNULL([CONTAS A PAGAR],0)) TOTAL 
	FROM
		(SELECT * FROM ##rpa014) AS TORIGEM
			PIVOT
			(
				SUM(SALDOPARC) FOR MODELO in ([FAT NF SAIDA],[LANC CONTABIL MANUAL],[CONTAS A RECEBER],[DEV NF SAIDA],[CONTAS A PAGAR])
			) pvt
	WHERE
		(ISNULL([FAT NF SAIDA],0)+ISNULL([LANC CONTABIL MANUAL],0)+ISNULL([CONTAS A RECEBER],0)+ISNULL([DEV NF SAIDA],0)+ISNULL([CONTAS A PAGAR],0)) IN (-5,-4,-3,-2,-1,0,1,2,3,4,5)

-----------------------------------------------------------------------------select * from @pivot
----========= FORMATACAO HTML PARA ENVIO POR E-MAIL =========

--SET @body = N'<!DOCTYPE html><html><head>

--<style>

--	#id0 { background-color: rgb(255, 255, 255); }
--	#id1 { background-color: rgb(255, 222, 255); }
--table {
--  border-collapse: separate;
--  border-spacing: 0;
--  color: #4a4a4d;
--  font: 14px/1.4 "Helvetica Neue", Helvetica, Arial, sans-serif;
--}
--th,
--td {
--  padding: 10px 15px;
--  vertical-align: middle;
--}
--caption {
--  background: #395870;
--  background: linear-gradient(#49708f, #293f50);
--  color: #fff;
--  font-size: 20px;
--  font-weight: bold;
--  text-transform: uppercase;
--}

--thead {
--  background: #395870;
--  background: linear-gradient(#49708f, #293f50);
--  color: #fff;
--  font-size: 11px;
--  text-transform: uppercase;
--}
--th:first-child {
--  border-top-left-radius: 5px;
--  text-align: left;
--}
--th:last-child {
--  border-top-right-radius: 5px;
--}
--tbody tr:nth-child(even) {
--  background: #f0f0f2;
--}
--td {
--  border-bottom: 1px solid #cecfd5;
--  border-right: 1px solid #cecfd5;
--}
--td:first-child {
--  border-left: 111px solid #cecfd5;
--}

--tfoot {
--  text-align: right;
--}
--tfoot tr:last-child {
--  background: #f0f0f2;
--  color: #395870;
--  font-weight: bold;
--}
--tfoot tr:last-child td:first-child {
--  border-bottom-left-radius: 5px;
--}
--tfoot tr:last-child td:last-child {
--  border-bottom-right-radius: 5px;
--}
  
--</style>

--<title>Conciliacao de Clientes</title>
--</head><body>

--<table align="center" cellpadding="5" cols="8" frame="vsides" rules="rows" width="90%" style="font-family:Arial, Helvetica, sans-serif;font-size:60%">
--		<caption>CONCILIACAO DE CLIENTES ' + CONCAT('- ',UPPER(@mesextenso),'/',YEAR(GETDATE())) + '</caption>
--		<thead>
--			<tr> 
--			<th>TIPO</th>
--			<th>CLIENTE</th>
--			<th>CNPJ</th>
--			<th>FAT</th>
--			<th>LC</th>
--			<th>CR</th>
--			<th>DEV</th>
--			<th>CP</th>
--			<th>TOTAL</th>
--			</tr>
--		</thead>
--		<tbody>' + (
    
--			SELECT	
--				[@id] = [ID],[td/@align]='center',
--				td = [TIPO], '',[td/@align]='left',
--				td = [CLIENTE], '',[td/@align]='center',
--				td = [CNPJ], '',[td/@align]='right',
--				td = FORMAT([FAT NF SAIDA],'N','pt-br'), '',[td/@align]='right',
--				td = FORMAT([LANC CONTABIL MANUAL],'N','pt-br'), '',[td/@align]='right',
--				td = FORMAT([CONTAS A RECEBER],'N','pt-br'), '',[td/@align]='right',
--				td = FORMAT([DEV NF SAIDA],'N','pt-br'), '',[td/@align]='right',
--				td = FORMAT([CONTAS A PAGAR],'N','pt-br'), '',[td/@align]='right',
--				td = FORMAT([TOTAL],'N','pt-br')
--            FROM @pivot
--			ORDER BY [CLIENTE]
--			FOR XML PATH('tr') )
--			+ '</tbody>'


--SET @body = @body + '</table><p align="center" style="font-family:Arial, Helvetica, sans-serif;font-size:60%;font-weight:bold">@copyright 2020    |    EQUIPE TECNOLOGIA    |    GERADO EM ' + FORMAT(SYSDATETIME(),'dd.MM.yyyy hh:mm') + '</p></body></html>';
--SET @subj = N'CONCILIACAO DE CLIENTES ' + CONCAT('EM ',UPPER(@mesextenso),'/',YEAR(GETDATE()));

--EXEC msdb.dbo.sp_send_dbmail
--    	@recipients=N'rodrigo.matos@nutriex.com.br',
--	@copy_recipients=N'selma@equilibrium.far.br;pio.sousa@equilibrium.far.br;brandao.alves@nutriex.com.br',
--	@blind_copy_recipients=N'junior.nunes@eficienciacont.com.br',
--	@body = @body,
--	@body_format = 'HTML',
--	@subject = @subj,
--	@profile_name = 'NutriexReports';