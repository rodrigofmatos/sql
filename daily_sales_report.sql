DROP TABLE IF EXISTS #fat
DROP TABLE IF EXISTS #dev
DROP TABLE IF EXISTS #base
DROP TABLE IF EXISTS mbs.dbo.rpa013

--SET DATEFIRST  7, -- 1 = Monday, 7 = Sunday
--    DATEFORMAT dmy, 
--    LANGUAGE   PORTUGUESE;
--    --LANGUAGE   US_ENGLISH;

CREATE TABLE #fat( 
	[ORIGEM] [nvarchar](3) NULL,
	[EMPRESA] [nvarchar](50) NULL,
	[USO] [nvarchar](50) NULL,
	[ITEMCODE] [nvarchar](50) NULL,
	[ITEMNAME] [nvarchar](100) NULL,
	[QTDE] [numeric](18,2) NULL,
	[FTCONVCAIXA] [numeric](18,2) NULL,
	[PESOCAIXA] [numeric](18,2) NULL,
	[UNIDADE] [nvarchar](3) NULL,
	[SUPERVISOR] [nvarchar](50) NULL,
	[NFNUM] [int] NULL,
	[DTNF] [date] NULL,
	--[ANO_MES] [nvarchar](8) NULL,
	--[MES] [nvarchar](2) NULL,
	--[DIA] [nvarchar](20) NULL,
	[VERSION] [nvarchar](max) NULL,
	--[FATBRUTO] [numeric](18,2) NULL,
	--[PERCDESC] [numeric](18,2) NULL,
	--[VLRDESC] [numeric](18,2) NULL,
	--[VLRDESP] [numeric](18,2) NULL,
	[FATLIQ] [numeric](18,2) NULL
) ON [PRIMARY]

CREATE TABLE #dev(
	[ORIGEM] [nvarchar](3) NULL,
	[EMPRESA] [nvarchar](50) NULL,
	[USO] [nvarchar](50) NULL,
	[ITEMCODE] [nvarchar](50) NULL,
	[ITEMNAME] [nvarchar](100) NULL,
	[QTDE] [numeric](18,2) NULL,
	[FTCONVCAIXA] [numeric](18,2) NULL,
	[PESOCAIXA] [numeric](18,2) NULL,
	[UNIDADE] [nvarchar](3) NULL,
	[SUPERVISOR] [nvarchar](50) NULL,
	[NFNUM] [int] NULL,
	[DTNF] [date] NULL,
	--[ANO_MES] [nvarchar](8) NULL,
	--[MES] [nvarchar](2) NULL,
	--[DIA] [nvarchar](20) NULL,
	[VERSION] [nvarchar](max) NULL,
	--[FATBRUTO] [numeric](18,2) NULL,
	--[PERCDESC] [numeric](18,2) NULL,
	--[VLRDESC] [numeric](18,2) NULL,
	--[VLRDESP] [numeric](18,2) NULL,
	[FATLIQ] [numeric](18,2) NULL
) ON [PRIMARY]


CREATE TABLE mbs.dbo.rpa013(
	[ORIGEM] [nvarchar](3) NULL,
	[EMPRESA] [nvarchar](50) NULL,
	[USO] [nvarchar](50) NULL,
	[ITEMCODE] [nvarchar](50) NULL,
	[ITEMNAME] [nvarchar](100) NULL,
	[QTDE] [numeric](18,2) NULL,
	[CAIXA] [numeric](18,2) NULL,
	[PESO] [numeric](18,2) NULL,
	[UNIDADE] [nvarchar](3) NULL,
	[SUPERVISOR] [nvarchar](50) NULL,
	[DTNF] [date] NULL,
	--[ANO_MES] [nvarchar](8) NULL,
	--[MES] [nvarchar](2) NULL,
	--[DIA] [nvarchar](20) NULL,
	[VERSION] [nvarchar](max) NULL,
	--[FATBRUTO] [numeric](18,2) NULL,
	--[PERCDESC] [numeric](18,2) NULL,
	--[VLRDESC] [numeric](18,2) NULL,
	--[VLRDESP] [numeric](18,2) NULL,
	[FATLIQ] [numeric](18,2) NULL
) ON [PRIMARY]

CREATE TABLE #base([BASEID] int NOT NULL,[EMPRESA] nvarchar(max) NULL)
	INSERT INTO #base VALUES (1,'SBOA7');
	INSERT INTO #base VALUES (2,'SBODL');
	INSERT INTO #base VALUES (3,'SBOEquilibrium');
	INSERT INTO #base VALUES (4,'SBOGDSMARCAS');
	INSERT INTO #base VALUES (5,'SBOMW');

--DECLARA AS VARIAVEIS PARA FILTROS E APELIDOS DE TABELAS
DECLARE @loop int = (SELECT COUNT(baseid) FROM #base);
DECLARE @i int = 0; 
DECLARE @reportdate nvarchar(max) = format(getdate(),'dd.MMM.yyyy HH:mm')
DECLARE @empresa nvarchar(MAX);
DECLARE @pathOWGT nvarchar(MAX);
DECLARE @pathOINV nvarchar(MAX);
DECLARE @pathOITM nvarchar(MAX);
DECLARE @pathINV1 nvarchar(MAX);
DECLARE @pathINV3 nvarchar(MAX);
DECLARE @pathOCRD nvarchar(MAX);
DECLARE @pathOCRG nvarchar(MAX);
DECLARE @pathORCA nvarchar(MAX);
DECLARE @pathOHRQ nvarchar(MAX);
DECLARE @pathOUSG nvarchar(MAX);
DECLARE @pathORIN nvarchar(MAX);
DECLARE @pathRIN1 nvarchar(MAX);
DECLARE @pathRIN3 nvarchar(MAX);

--EXECUTA A CONSULTA EM LOOP VARRENDO TODAS AS EMPRESAS LISTADAS NO INICIO DO SCRIPT
while @i < @loop
	begin
		set @i = @i + 1; --inicio do laco
		set @empresa = (select empresa from #base where baseid = @i)
		set @pathOINV = CONCAT(N'CREATE SYNONYM tpathOINV FOR ',@empresa,N'.DBO.OINV');
		set @pathOWGT = CONCAT(N'CREATE SYNONYM tpathOWGT FOR ',@empresa,N'.DBO.OWGT');
		set @pathOITM = CONCAT(N'CREATE SYNONYM tpathOITM FOR ',@empresa,N'.DBO.OITM');
		set @pathINV1 = CONCAT(N'CREATE SYNONYM tpathINV1 FOR ',@empresa,N'.DBO.INV1');
		set @pathINV3 = CONCAT(N'CREATE SYNONYM tpathINV3 FOR ',@empresa,N'.DBO.INV3');
		set @pathORIN = CONCAT(N'CREATE SYNONYM tpathORIN FOR ',@empresa,N'.DBO.ORIN');
		set @pathRIN1 = CONCAT(N'CREATE SYNONYM tpathRIN1 FOR ',@empresa,N'.DBO.RIN1');
		set @pathRIN3 = CONCAT(N'CREATE SYNONYM tpathRIN3 FOR ',@empresa,N'.DBO.RIN3');
		set @pathOCRD = CONCAT(N'CREATE SYNONYM tpathOCRD FOR ',@empresa,N'.DBO.OCRD');
		set @pathOCRG = CONCAT(N'CREATE SYNONYM tpathOCRG FOR ',@empresa,N'.DBO.OCRG');
		set @pathOUSG = CONCAT(N'CREATE SYNONYM tpathOUSG FOR ',@empresa,N'.DBO.OUSG');
		set @pathORCA = CONCAT(N'CREATE SYNONYM tpathORCA FOR ',@empresa,N'.DBO.[@FT_ORCA]');
		set @pathOHRQ = CONCAT(N'CREATE SYNONYM tpathOHRQ FOR ',@empresa,N'.DBO.[@FT_OHRQ]');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOWGT') > 0 BEGIN DROP SYNONYM tpathOWGT; EXEC(@pathOWGT); END ELSE BEGIN exec(@pathOWGT); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOINV') > 0 BEGIN DROP SYNONYM tpathOINV; EXEC(@pathOINV); END ELSE BEGIN exec(@pathOINV); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOITM') > 0 BEGIN DROP SYNONYM tpathOITM; EXEC(@pathOITM); END ELSE BEGIN exec(@pathOITM); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathINV1') > 0 BEGIN DROP SYNONYM tpathINV1; EXEC(@pathINV1); END ELSE BEGIN exec(@pathINV1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathINV3') > 0 BEGIN DROP SYNONYM tpathINV3; EXEC(@pathINV3); END ELSE BEGIN exec(@pathINV3); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathORIN') > 0 BEGIN DROP SYNONYM tpathORIN; EXEC(@pathORIN); END ELSE BEGIN exec(@pathORIN); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathRIN1') > 0 BEGIN DROP SYNONYM tpathRIN1; EXEC(@pathRIN1); END ELSE BEGIN exec(@pathRIN1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathRIN3') > 0 BEGIN DROP SYNONYM tpathRIN3; EXEC(@pathRIN3); END ELSE BEGIN exec(@pathRIN3); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOCRD') > 0 BEGIN DROP SYNONYM tpathOCRD; EXEC(@pathOCRD); END ELSE BEGIN exec(@pathOCRD); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOCRG') > 0 BEGIN DROP SYNONYM tpathOCRG; EXEC(@pathOCRG); END ELSE BEGIN exec(@pathOCRG); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathORCA') > 0 BEGIN DROP SYNONYM tpathORCA; EXEC(@pathORCA); END ELSE BEGIN exec(@pathORCA); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOHRQ') > 0 BEGIN DROP SYNONYM tpathOHRQ; EXEC(@pathOHRQ); END ELSE BEGIN exec(@pathOHRQ); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOUSG') > 0 BEGIN DROP SYNONYM tpathOUSG; EXEC(@pathOUSG); END ELSE BEGIN exec(@pathOUSG); END

--FATURAMENTO TOTAL DIARIO DO ANO 2020 POR EMPRESA DO NEGOCIO NUTRIEX NÃO COLIGADAS VALOR TOTAL COM IMPOSTOS EXCLUINDO-SE AS NOTAS CANCELADAS E OS ITENS DA RENNOVA
	insert into #fat
		SELECT DISTINCT
			'SAI' ORIGEM,
			@empresa EMPRESA, 
			ISNULL(U.USAGE,'INDEFINIDO') USO, 
			I.ITEMCODE,
			I.DSCRIPTION,
			sum(I.QUANTITY),
			ISNULL(t.salpackun,0),
			isnull(t.sWeight1,0),
			UPPER(isnull((select UNITDISPLY from tpathowgt where unitcode = t.SWght1Unit),'KG')),
			COALESCE((SELECT h1.name FROM tpathOHRQ h1 WHERE h1.code = (SELECT c1.[U_Hierarquia] FROM tpathORCA c1 WHERE C1.CODE = (isnull(o.slpcode,isnull((select r.slpcode from tpathocrd r where r.cardcode = o.cardcode),null))))),'### SEM_SUPERVISOR ###') SUPERVISOR,
			o.serial NFNUM,
			cast(o.docdate as date) DTNF, 
			'Fonte: SAP | Depto. de Tecnologia | ' + @reportdate + ' @rpa013' VERSION, 
			--SUM(i.linetotal) + ISNULL((SELECT SUM((LINETOTAL)) FROM TPATHINV3 WHERE DOCENTRY = O.DOCENTRY),0) FATBRUTO, 
			--ISNULL(AVG(O.DiscPrcnt),0) PERCDESC, 
			--ISNULL(AVG(O.DiscSum),0) VLRDESC, 
			--ISNULL((SELECT LINETOTAL FROM TPATHINV3 WHERE DOCENTRY = O.DOCENTRY),0) DESPACESSORIAS,
			SUM(I.LINETOTAL) + ISNULL((SELECT SUM((LINETOTAL)) FROM TPATHINV3 WHERE DOCENTRY = O.DOCENTRY),0) - AVG(O.DiscSum) FATLIQ
		FROM 
			tpathOINV O inner join 
			tpathINV1 i on i.docentry = o.docentry INNER join 
			tpathoITM T on i.itemcode = t.itemcode INNER JOIN
			tpathocrd c on o.cardcode = c.cardcode INNER JOIN
			tpathOCRG G ON c.groupcode = G.GROUPCODE LEFT JOIN
			tpathORCA c1 ON C1.CODE = o.SLPCODE LEFT JOIN
			tpathOHRQ h1 ON c1.[U_Hierarquia] = h1.code LEFT JOIN
			tpathOUSG u ON u.id = i.usage
		WHERE 
			YEAR(O.DOCDATE) = 2020 AND o.canceled = 'N' and
			COALESCE((SELECT h1.name FROM tpathOHRQ h1 WHERE h1.code = (SELECT c1.[U_Hierarquia] FROM tpathORCA c1 WHERE C1.CODE = (isnull(o.slpcode,isnull((select r.slpcode from tpathocrd r where r.cardcode = o.cardcode),null))))),'### SEM_SUPERVISOR ###') NOT LIKE '%REN%' AND
			u.U_Margem = 'Y' and u.usage not like '%entrega%' and
			(u.usage like '%venda%' OR u.usage like '%DOA%' OR u.usage like '%BON%') AND
			G.GROUPNAME NOT LIKE '%ligada%' AND 
			isnull(o.[U_OpRennova],0) <> 1	
		GROUP BY 
			I.ITEMCODE,
			I.DSCRIPTION,
			t.salpackun,
			isnull(sWeight1,0),
			T.SWght1Unit,
			O.DOCENTRY,
			cast(o.docdate as date), 
			o.serial,
			ISNULL(U.USAGE,'INDEFINIDO'),
			h1.name,
			h1.code,
			c1.[U_Hierarquia],
			o.slpcode, 
			o.cardcode

	insert into #dev
		SELECT DISTINCT
			'ENT' ORIGEM,
			@empresa EMPRESA, 
			ISNULL(U.USAGE,'INDEFINIDO') USO, 
			I.ITEMCODE,
			I.DSCRIPTION,
			sum(I.QUANTITY),
			ISNULL(t.salpackun,0),
			isnull(t.sWeight1,0),
			UPPER(isnull((select UNITDISPLY from tpathowgt where unitcode = t.SWght1Unit),'KG')),
			COALESCE((SELECT h1.name FROM tpathOHRQ h1 WHERE h1.code = (SELECT c1.[U_Hierarquia] FROM tpathORCA c1 WHERE C1.CODE = (isnull(o.slpcode,isnull((select r.slpcode from tpathocrd r where r.cardcode = o.cardcode),null))))),'### SEM_SUPERVISOR ###') SUPERVISOR,
			o.serial NFNUM,
			cast(o.docdate as date) DTNF, 
			'Fonte: SAP | Depto. de Tecnologia | ' + @reportdate + ' @rpa013' VERSION, 
			--SUM(i.linetotal) + ISNULL((SELECT SUM((LINETOTAL)) FROM TPATHINV3 WHERE DOCENTRY = O.DOCENTRY),0) FATBRUTO, 
			--ISNULL(AVG(O.DiscPrcnt),0) PERCDESC, 
			--ISNULL(AVG(O.DiscSum),0) VLRDESC, 
			--ISNULL((SELECT LINETOTAL FROM TPATHINV3 WHERE DOCENTRY = O.DOCENTRY),0) DESPACESSORIAS,
			SUM(I.LINETOTAL) + ISNULL((SELECT SUM((LINETOTAL)) FROM TPATHINV3 WHERE DOCENTRY = O.DOCENTRY),0) - AVG(O.DiscSum) FATLIQ
		FROM 
			tpathORIN O inner join 
			tpathRIN1 i on i.docentry = o.docentry INNER join 
			tpathoITM T on i.itemcode = t.itemcode INNER JOIN
			tpathocrd c on o.cardcode = c.cardcode INNER JOIN
			tpathOCRG G ON c.groupcode = G.GROUPCODE LEFT JOIN
			tpathORCA c1 ON C1.CODE = o.SLPCODE LEFT JOIN
			tpathOHRQ h1 ON c1.[U_Hierarquia] = h1.code LEFT JOIN
			tpathOUSG u ON u.id = i.usage
		WHERE 
			YEAR(O.DOCDATE) = 2020 AND o.canceled = 'N' and
			COALESCE((SELECT h1.name FROM tpathOHRQ h1 WHERE h1.code = (SELECT c1.[U_Hierarquia] FROM tpathORCA c1 WHERE C1.CODE = (isnull(o.slpcode,isnull((select r.slpcode from tpathocrd r where r.cardcode = o.cardcode),null))))),'### SEM_SUPERVISOR ###') NOT LIKE '%REN%' AND
			u.U_Margem = 'Y' and u.usage not like '%entrega%' and
			(u.usage like '%venda%' OR u.usage like '%DOA%' OR u.usage like '%BON%') AND
			G.GROUPNAME NOT LIKE '%ligada%' AND 
			isnull(o.[U_OpRennova],0) <> 1	
		GROUP BY 
			I.ITEMCODE,
			I.DSCRIPTION,
			t.salpackun,
			isnull(sWeight1,0),
			T.SWght1Unit,
			O.DOCENTRY,
			cast(o.docdate as date), 
			o.serial,
			ISNULL(U.USAGE,'INDEFINIDO'),
			h1.name,
			h1.code,
			c1.[U_Hierarquia],
			o.slpcode, 
			o.cardcode

	END

--ATUALIZA OS NOMES DAS BASES DO SAP
	update #fat 
		set EMPRESA = 
						case
							when EMPRESA = 'sboa7' THEN 'A7'
							when EMPRESA = 'SBOGDSMARCAS' THEN 'BL'
							when EMPRESA = 'sboDL' THEN 'DL'
							when EMPRESA = 'SBOEquilibrium' THEN 'EQ'
							when EMPRESA = 'sboMW' THEN 'MW'
							ELSE EMPRESA
						END,
			USO = 
						case
							when USO LIKE '%DOA%' THEN 'DOAÇÃO'
							when USO LIKE '%BON%' THEN 'BONIFICAÇÃO'
							when USO LIKE '%VENDA%' THEN 'VENDA'
							ELSE USO
						END

	update #dev
		set EMPRESA = 
						case
							when EMPRESA = 'sboa7' THEN 'A7'
							when EMPRESA = 'SBOGDSMARCAS' THEN 'BL'
							when EMPRESA = 'sboDL' THEN 'DL'
							when EMPRESA = 'SBOEquilibrium' THEN 'EQ'
							when EMPRESA = 'sboMW' THEN 'MW'
							ELSE EMPRESA
						END,
			USO = 
						case
							when USO LIKE '%DOA%' THEN 'DOAÇÃO'
							when USO LIKE '%BON%' THEN 'BONIFICAÇÃO'
							when USO LIKE '%VENDA%' THEN 'VENDA'
							ELSE USO
						END

insert into mbs.dbo.rpa013
	select 
		 ORIGEM
		,[EMPRESA]
		,[USO]
		,ITEMCODE
		,ITEMNAME
		,QTDE 
		,CONVERT(NUMERIC(18,2),IIF((QTDE % IIF(FTCONVCAIXA = 0, 1,FTCONVCAIXA))<>0,1,0)+ ROUND((QTDE / IIF(FTCONVCAIXA = 0, 1,FTCONVCAIXA)),0)) [CAIXA]
		,AVG([PESOCAIXA])*CONVERT(NUMERIC(18,2),IIF((QTDE % IIF(FTCONVCAIXA = 0, 1,FTCONVCAIXA))<>0,1,0)+ ROUND((QTDE / IIF(FTCONVCAIXA = 0, 1,FTCONVCAIXA)),0)) [PESO]
		,[UNIDADE]
		,[SUPERVISOR]
		,[DTNF]
		,[VERSION]  
		,SUM([FATLIQ]) [FATLIQ]
	from #fat
	GROUP BY ITEMCODE, ITEMNAME,ORIGEM,QTDE, FTCONVCAIXA,
		 [EMPRESA]
		,[USO]
		,[UNIDADE]
		,[SUPERVISOR]
		,[DTNF]
		,[VERSION] 


insert into mbs.dbo.rpa013
	select 
		 ORIGEM
		,[EMPRESA]
		,[USO]
		,ITEMCODE
		,ITEMNAME
		,QTDE 
		,CONVERT(NUMERIC(18,2),IIF((QTDE % IIF(FTCONVCAIXA = 0, 1,FTCONVCAIXA))<>0,1,0)+ ROUND((QTDE / IIF(FTCONVCAIXA = 0, 1,FTCONVCAIXA)),0)) [CAIXA]
		,AVG([PESOCAIXA])*CONVERT(NUMERIC(18,2),IIF((QTDE % IIF(FTCONVCAIXA = 0, 1,FTCONVCAIXA))<>0,1,0)+ ROUND((QTDE / IIF(FTCONVCAIXA = 0, 1,FTCONVCAIXA)),0)) [PESO]
		,[UNIDADE]
		,[SUPERVISOR]
		,[DTNF]
		,[VERSION]  
		,-SUM([FATLIQ]) [FATLIQ]
	from #dev
	GROUP BY ITEMCODE, ITEMNAME,ORIGEM,QTDE, FTCONVCAIXA,
		 [EMPRESA]
		,[USO]
		,[UNIDADE]
		,[SUPERVISOR]
		,[DTNF]
		,[VERSION]  

