/*
**AUDITORIA DE NFE x NFS - VERSAO ROBOT DIARIO**
*/

/*
> 1\. Aqui vamos introduzir o código para excluir tabelas temporárias do sistema:
*/

DROP TABLE IF EXISTS #OUT
DROP TABLE IF EXISTS #IN
DROP TABLE IF EXISTS #BASEREFERENCIA
DROP TABLE IF EXISTS #BASEDEVIN
DROP TABLE IF EXISTS #BASEDEVOUT
DROP TABLE IF EXISTS #RESULT
DROP TABLE IF EXISTS MBS..NFSRESULT

/*
> 2\. A seguir, criaremos as tabelas temporárias:
*/

CREATE TABLE #BASEREFERENCIA(
	[MODO] [nvarchar](3) NULL,
	[BASE] [nvarchar](10) NULL,
	[CNPJ] [nvarchar](22) NULL,
	[CODPN] [nvarchar](10) NULL
) ON [PRIMARY]

CREATE TABLE #BASEDEVIN(
	[MODO] [nvarchar](3) NULL,
	[BASE] [nvarchar](10) NULL,
	[CNPJ] [nvarchar](22) NULL,
	[CODPN] [nvarchar](10) NULL
) ON [PRIMARY]

CREATE TABLE #BASEDEVOUT(
	[MODO] [nvarchar](3) NULL,
	[BASE] [nvarchar](10) NULL,
	[CNPJ] [nvarchar](22) NULL,
	[CODPN] [nvarchar](10) NULL
) ON [PRIMARY]

CREATE TABLE #OUT(
	[MODO] [nvarchar](3) NULL,
	[BASE] [nvarchar](10) NULL,
	[CNPJORIGEM] [nvarchar](22) NULL,
	[CNPJDESTINO] [nvarchar](22) NULL,
	[KEYCNPJ] [nvarchar](22) NULL,
	[CODPN] [nvarchar](10) NULL,
	[NOMPN] [nvarchar](100) NULL,
	[NFNUM] [int] NULL,
	[CANCELADO] [nvarchar](1) NULL,
	[DOCSAP] [int] NULL,
	[TRANSID] [int] NULL,
	[DTNF] [date] NULL,
	[PERIODO] [nvarchar](10) NULL,
	[UTILIZACAO] [nvarchar](50) NULL,
	[VLRTOTPRO] [float] NULL,
	[VLRTOTIPI] [float] NULL,
	[VLRTOTNFS] [float] NULL
) ON [PRIMARY]

CREATE TABLE #IN(
	[MODO] [nvarchar](3) NULL,
	[BASE] [nvarchar](10) NULL,
	[CNPJORIGEM] [nvarchar](22) NULL,
	[CNPJDESTINO] [nvarchar](22) NULL,
	[KEYCNPJ] [nvarchar](22) NULL,
	[CODPN] [nvarchar](10) NULL,
	[NOMPN] [nvarchar](100) NULL,
	[NFNUM] [int] NULL,
	[CANCELADO] [nvarchar](1) NULL,
	[DOCSAP] [int] NULL,
	[TRANSID] [int] NULL,
	[DTNF] [date] NULL,
	[PERIODO] [nvarchar](10) NULL,
	[UTILIZACAO] [nvarchar](50) NULL,
	[VLRTOTPRO] [float] NULL,
	[VLRTOTIPI] [float] NULL,
	[VLRTOTNFS] [float] NULL
) ON [PRIMARY]

CREATE TABLE #RESULT(
	[MODO] [nvarchar](3) NULL,
	[BASE] [nvarchar](10) NULL,
	[CNPJORIGEM] [nvarchar](22) NULL,
	[CNPJDESTINO] [nvarchar](22) NULL,
	[KEYCNPJ] [nvarchar](22) NULL,
	[CODPN] [nvarchar](10) NULL,
	[NOMPN] [nvarchar](100) NULL,
	[NFNUM] [int] NULL,
	[CANCELADO] [nvarchar](1) NULL,
	[DOCSAP] [int] NULL,
	[TRANSID] [int] NULL,
	[DTNF] [date] NULL,
	[PERIODO] [nvarchar](10) NULL,
	[UTILIZACAO] [nvarchar](50) NULL,
	[VLRTOTPRO] [float] NULL,
	[VLRTOTIPI] [float] NULL,
	[VLRTOTNFS] [float] NULL,
	[REPORTDATE] [datetime] NULL
) ON [PRIMARY]

CREATE TABLE MBS..NFSRESULT(
	[MODO] [nvarchar](3) NULL,
	[BASE] [nvarchar](10) NULL,
	[CNPJORIGEM] [nvarchar](22) NULL,
	[CNPJDESTINO] [nvarchar](22) NULL,
	[KEYCNPJ] [nvarchar](22) NULL,
	[CODPN] [nvarchar](10) NULL,
	[NOMPN] [nvarchar](100) NULL,
	[NFNUM] [int] NULL,
	[CANCELADO] [nvarchar](1) NULL,
	[DOCSAP] [int] NULL,
	[TRANSID] [int] NULL,
	[DTNF] [date] NULL,
	[PERIODO] [nvarchar](10) NULL,
	[UTILIZACAO] [nvarchar](50) NULL,
	[VLRTOTPRO] [float] NULL,
	[VLRTOTIPI] [float] NULL,
	[VLRTOTNFS] [float] NULL,
	[REPORTDATE] [datetime] NULL
) ON [PRIMARY]

--DECLARA AS VARIAVEIS PARA FILTROS E APELIDOS DE TABELAS
DECLARE @loop int = (SELECT COUNT(baseid) FROM mbs..bases);
DECLARE @i int = 0; 
DECLARE @reportdate nvarchar(max) = format(getdate(),'dd.MMM.yyyy HH:mm')
DECLARE @empresa nvarchar(MAX);
DECLARE @pathOINV nvarchar(MAX);
DECLARE @pathOCRD nvarchar(MAX);
DECLARE @pathOCRG nvarchar(MAX);
DECLARE @pathOBPL nvarchar(MAX);
DECLARE @pathINV1 nvarchar(MAX);
DECLARE @PATHOUSG nvarchar(MAX);
DECLARE @PATHOPCH nvarchar(MAX);
DECLARE @PATHPCH1 nvarchar(MAX);
DECLARE @PATHCRD7 nvarchar(MAX);
DECLARE @PATHORPC nvarchar(MAX);
DECLARE @PATHRPC1 nvarchar(MAX);
DECLARE @PATHORIN nvarchar(MAX);
DECLARE @PATHRIN1 nvarchar(MAX);

--EXECUTA A CONSULTA EM LOOP VARRENDO TODAS AS EMPRESAS LISTADAS NO INICIO DO SCRIPT
while @i < @loop
	begin
		set @i = @i + 1; --inicio do laco
		set @empresa = (select empresa from mbs..bases where baseid = @i)
		set @pathOINV = CONCAT(N'CREATE SYNONYM tpathOINV FOR ',@empresa,N'.DBO.OINV');
		set @pathOCRD = CONCAT(N'CREATE SYNONYM tpathOCRD FOR ',@empresa,N'.DBO.OCRD');
		set @pathOCRG = CONCAT(N'CREATE SYNONYM tpathOCRG FOR ',@empresa,N'.DBO.OCRG');
		set @pathOBPL = CONCAT(N'CREATE SYNONYM tpathOBPL FOR ',@empresa,N'.DBO.OBPL');
		set @pathINV1 = CONCAT(N'CREATE SYNONYM tpathINV1 FOR ',@empresa,N'.DBO.INV1');
		set @pathOUSG = CONCAT(N'CREATE SYNONYM tpathOUSG FOR ',@empresa,N'.DBO.OUSG');
		set @pathOPCH = CONCAT(N'CREATE SYNONYM tpathOPCH FOR ',@empresa,N'.DBO.OPCH');
		set @pathPCH1 = CONCAT(N'CREATE SYNONYM tpathPCH1 FOR ',@empresa,N'.DBO.PCH1');
		set @pathCRD7 = CONCAT(N'CREATE SYNONYM tpathCRD7 FOR ',@empresa,N'.DBO.CRD7');
		set @pathORPC = CONCAT(N'CREATE SYNONYM tpathORPC FOR ',@empresa,N'.DBO.ORPC');
		set @pathRPC1 = CONCAT(N'CREATE SYNONYM tpathRPC1 FOR ',@empresa,N'.DBO.RPC1');
		set @pathORIN = CONCAT(N'CREATE SYNONYM tpathORIN FOR ',@empresa,N'.DBO.ORIN');
		set @pathRIN1 = CONCAT(N'CREATE SYNONYM tpathRIN1 FOR ',@empresa,N'.DBO.RIN1');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOINV') > 0 BEGIN DROP SYNONYM tpathOINV; EXEC(@pathOINV); END ELSE BEGIN exec(@pathOINV); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOCRD') > 0 BEGIN DROP SYNONYM tpathOCRD; EXEC(@pathOCRD); END ELSE BEGIN exec(@pathOCRD); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOCRG') > 0 BEGIN DROP SYNONYM tpathOCRG; EXEC(@pathOCRG); END ELSE BEGIN exec(@pathOCRG); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOBPL') > 0 BEGIN DROP SYNONYM tpathOBPL; EXEC(@pathOBPL); END ELSE BEGIN exec(@pathOBPL); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathINV1') > 0 BEGIN DROP SYNONYM tpathINV1; EXEC(@pathINV1); END ELSE BEGIN exec(@pathINV1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOUSG') > 0 BEGIN DROP SYNONYM tpathOUSG; EXEC(@pathOUSG); END ELSE BEGIN exec(@pathOUSG); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOPCH') > 0 BEGIN DROP SYNONYM tpathOPCH; EXEC(@pathOPCH); END ELSE BEGIN exec(@pathOPCH); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathPCH1') > 0 BEGIN DROP SYNONYM tpathPCH1; EXEC(@pathPCH1); END ELSE BEGIN exec(@pathPCH1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathCRD7') > 0 BEGIN DROP SYNONYM tpathCRD7; EXEC(@pathCRD7); END ELSE BEGIN exec(@pathCRD7); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathORPC') > 0 BEGIN DROP SYNONYM tpathORPC; EXEC(@pathORPC); END ELSE BEGIN exec(@pathORPC); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathRPC1') > 0 BEGIN DROP SYNONYM tpathRPC1; EXEC(@pathRPC1); END ELSE BEGIN exec(@pathRPC1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathORIN') > 0 BEGIN DROP SYNONYM tpathORIN; EXEC(@pathORIN); END ELSE BEGIN exec(@pathORIN); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathRIN1') > 0 BEGIN DROP SYNONYM tpathRIN1; EXEC(@pathRIN1); END ELSE BEGIN exec(@pathRIN1); END


/*
> > 3\. Carregar tabelas de empresas coligadas para extração nas etapas posteriores:
*/

		INSERT INTO #BASEREFERENCIA
			select DISTINCT
				'OUT' MODO, 
				LEFT(REPLACE(@empresa,'sbo',''),10) BASE, 
				C.LICTRADNUM,
				O.CARDCODE CODPN
			From 
				tpathoinv o inner join 
				tpathocrd c on c.cardcode = o.cardcode inner join 
				tpathocrg g on g.groupcode = c.groupcode 
			where 
				g.groupname like '%ligada%'  

	end

set @i = 0

while @i < @loop
	begin
		set @i = @i + 1; --inicio do laco
		set @empresa = (select empresa from mbs..bases where baseid = @i)
		set @pathOINV = CONCAT(N'CREATE SYNONYM tpathOINV FOR ',@empresa,N'.DBO.OINV');
		set @pathOCRD = CONCAT(N'CREATE SYNONYM tpathOCRD FOR ',@empresa,N'.DBO.OCRD');
		set @pathOCRG = CONCAT(N'CREATE SYNONYM tpathOCRG FOR ',@empresa,N'.DBO.OCRG');
		set @pathOBPL = CONCAT(N'CREATE SYNONYM tpathOBPL FOR ',@empresa,N'.DBO.OBPL');
		set @pathINV1 = CONCAT(N'CREATE SYNONYM tpathINV1 FOR ',@empresa,N'.DBO.INV1');
		set @pathOUSG = CONCAT(N'CREATE SYNONYM tpathOUSG FOR ',@empresa,N'.DBO.OUSG');
		set @pathOPCH = CONCAT(N'CREATE SYNONYM tpathOPCH FOR ',@empresa,N'.DBO.OPCH');
		set @pathPCH1 = CONCAT(N'CREATE SYNONYM tpathPCH1 FOR ',@empresa,N'.DBO.PCH1');
		set @pathCRD7 = CONCAT(N'CREATE SYNONYM tpathCRD7 FOR ',@empresa,N'.DBO.CRD7');
		set @pathORPC = CONCAT(N'CREATE SYNONYM tpathORPC FOR ',@empresa,N'.DBO.ORPC');
		set @pathRPC1 = CONCAT(N'CREATE SYNONYM tpathRPC1 FOR ',@empresa,N'.DBO.RPC1');
		set @pathORIN = CONCAT(N'CREATE SYNONYM tpathORIN FOR ',@empresa,N'.DBO.ORIN');
		set @pathRIN1 = CONCAT(N'CREATE SYNONYM tpathRIN1 FOR ',@empresa,N'.DBO.RIN1');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOINV') > 0 BEGIN DROP SYNONYM tpathOINV; EXEC(@pathOINV); END ELSE BEGIN exec(@pathOINV); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOCRD') > 0 BEGIN DROP SYNONYM tpathOCRD; EXEC(@pathOCRD); END ELSE BEGIN exec(@pathOCRD); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOCRG') > 0 BEGIN DROP SYNONYM tpathOCRG; EXEC(@pathOCRG); END ELSE BEGIN exec(@pathOCRG); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOBPL') > 0 BEGIN DROP SYNONYM tpathOBPL; EXEC(@pathOBPL); END ELSE BEGIN exec(@pathOBPL); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathINV1') > 0 BEGIN DROP SYNONYM tpathINV1; EXEC(@pathINV1); END ELSE BEGIN exec(@pathINV1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOUSG') > 0 BEGIN DROP SYNONYM tpathOUSG; EXEC(@pathOUSG); END ELSE BEGIN exec(@pathOUSG); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOPCH') > 0 BEGIN DROP SYNONYM tpathOPCH; EXEC(@pathOPCH); END ELSE BEGIN exec(@pathOPCH); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathPCH1') > 0 BEGIN DROP SYNONYM tpathPCH1; EXEC(@pathPCH1); END ELSE BEGIN exec(@pathPCH1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathCRD7') > 0 BEGIN DROP SYNONYM tpathCRD7; EXEC(@pathCRD7); END ELSE BEGIN exec(@pathCRD7); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathORPC') > 0 BEGIN DROP SYNONYM tpathORPC; EXEC(@pathORPC); END ELSE BEGIN exec(@pathORPC); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathRPC1') > 0 BEGIN DROP SYNONYM tpathRPC1; EXEC(@pathRPC1); END ELSE BEGIN exec(@pathRPC1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathORIN') > 0 BEGIN DROP SYNONYM tpathORIN; EXEC(@pathORIN); END ELSE BEGIN exec(@pathORIN); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathRIN1') > 0 BEGIN DROP SYNONYM tpathRIN1; EXEC(@pathRIN1); END ELSE BEGIN exec(@pathRIN1); END

		INSERT INTO #OUT
			SELECT 
				'OUT' MODO, 
				LEFT(REPLACE(@empresa,'sbo',''),10) BASE, 
				ISNULL(CONVERT(nvarchar,(SELECT TOP 1 B.TaxIdNum From TPATHOBPL B WHERE O.BPLId = B.BPLID)),(SELECT TOP 1 B.TaxIdNum From TPATHOBPL B)) CNPJ2,
				O.LICTRADNUM CNPJ,									  																	  
				ISNULL(CONVERT(nvarchar,(SELECT TOP 1 B.TaxIdNum From TPATHOBPL B WHERE O.BPLId = B.BPLID)),(SELECT TOP 1 B.TaxIdNum From TPATHOBPL B)) KEYCNPJ,
				o.CARDCODE CODPN,
				O.CARDNAME NOMPN, 
				o.serial NFNUM, 
				O.CANCELED [STATUS],
				o.docentry DOCSAP, 
				o.TransId TRANSID, 
				cast(o.docdate as date) DTNF, 
				FORMAT(o.docdate,'yyyy/MM') PERIODO,
				(SELECT TOP 1 U.USAGE FROM TPATHINV1 V LEFT JOIN TPATHOUSG U ON U.ID = V.USAGE WHERE DOCENTRY = O.DOCENTRY) UTILIZACAO,
				CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM TPATHINV1 WHERE DOCENTRY = O.DOCENTRY)) VLRTOTPRO,
				ROUND(CONVERT(FLOAT,(SELECT SUM(LINEVAT) FROM TPATHINV1 WHERE DOCENTRY = O.DOCENTRY)),0) VLRTOTIPI,
				cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) VLRTOTNFS 
			From 
				TPATHoinv o
			where 
				O.CardCode COLLATE DATABASE_DEFAULT IN (SELECT CODPN FROM #BASEREFERENCIA WHERE BASE = LEFT(REPLACE(@empresa,'sbo',''),10)) AND
				YEAR(o.docdate) >= 2020 AND
				O.CANCELED <> 'C' and o.model = 39
	end

/*
> > 5\. Inserir as notas de entrada nas distribuidoras (IN) para cruzar com as informações de saída das indústrias:
*/

set @i = 0

while @i < @loop
	begin
		set @i = @i + 1; --inicio do laco
		set @empresa = (select empresa from mbs..bases where baseid = @i)
		set @pathOINV = CONCAT(N'CREATE SYNONYM tpathOINV FOR ',@empresa,N'.DBO.OINV');
		set @pathOCRD = CONCAT(N'CREATE SYNONYM tpathOCRD FOR ',@empresa,N'.DBO.OCRD');
		set @pathOCRG = CONCAT(N'CREATE SYNONYM tpathOCRG FOR ',@empresa,N'.DBO.OCRG');
		set @pathOBPL = CONCAT(N'CREATE SYNONYM tpathOBPL FOR ',@empresa,N'.DBO.OBPL');
		set @pathINV1 = CONCAT(N'CREATE SYNONYM tpathINV1 FOR ',@empresa,N'.DBO.INV1');
		set @pathOUSG = CONCAT(N'CREATE SYNONYM tpathOUSG FOR ',@empresa,N'.DBO.OUSG');
		set @pathOPCH = CONCAT(N'CREATE SYNONYM tpathOPCH FOR ',@empresa,N'.DBO.OPCH');
		set @pathPCH1 = CONCAT(N'CREATE SYNONYM tpathPCH1 FOR ',@empresa,N'.DBO.PCH1');
		set @pathCRD7 = CONCAT(N'CREATE SYNONYM tpathCRD7 FOR ',@empresa,N'.DBO.CRD7');
		set @pathORPC = CONCAT(N'CREATE SYNONYM tpathORPC FOR ',@empresa,N'.DBO.ORPC');
		set @pathRPC1 = CONCAT(N'CREATE SYNONYM tpathRPC1 FOR ',@empresa,N'.DBO.RPC1');
		set @pathORIN = CONCAT(N'CREATE SYNONYM tpathORIN FOR ',@empresa,N'.DBO.ORIN');
		set @pathRIN1 = CONCAT(N'CREATE SYNONYM tpathRIN1 FOR ',@empresa,N'.DBO.RIN1');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOINV') > 0 BEGIN DROP SYNONYM tpathOINV; EXEC(@pathOINV); END ELSE BEGIN exec(@pathOINV); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOCRD') > 0 BEGIN DROP SYNONYM tpathOCRD; EXEC(@pathOCRD); END ELSE BEGIN exec(@pathOCRD); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOCRG') > 0 BEGIN DROP SYNONYM tpathOCRG; EXEC(@pathOCRG); END ELSE BEGIN exec(@pathOCRG); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOBPL') > 0 BEGIN DROP SYNONYM tpathOBPL; EXEC(@pathOBPL); END ELSE BEGIN exec(@pathOBPL); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathINV1') > 0 BEGIN DROP SYNONYM tpathINV1; EXEC(@pathINV1); END ELSE BEGIN exec(@pathINV1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOUSG') > 0 BEGIN DROP SYNONYM tpathOUSG; EXEC(@pathOUSG); END ELSE BEGIN exec(@pathOUSG); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOPCH') > 0 BEGIN DROP SYNONYM tpathOPCH; EXEC(@pathOPCH); END ELSE BEGIN exec(@pathOPCH); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathPCH1') > 0 BEGIN DROP SYNONYM tpathPCH1; EXEC(@pathPCH1); END ELSE BEGIN exec(@pathPCH1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathCRD7') > 0 BEGIN DROP SYNONYM tpathCRD7; EXEC(@pathCRD7); END ELSE BEGIN exec(@pathCRD7); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathORPC') > 0 BEGIN DROP SYNONYM tpathORPC; EXEC(@pathORPC); END ELSE BEGIN exec(@pathORPC); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathRPC1') > 0 BEGIN DROP SYNONYM tpathRPC1; EXEC(@pathRPC1); END ELSE BEGIN exec(@pathRPC1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathORIN') > 0 BEGIN DROP SYNONYM tpathORIN; EXEC(@pathORIN); END ELSE BEGIN exec(@pathORIN); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathRIN1') > 0 BEGIN DROP SYNONYM tpathRIN1; EXEC(@pathRIN1); END ELSE BEGIN exec(@pathRIN1); END


		INSERT INTO #IN
			SELECT
				'IN' MODO, 
				LEFT(REPLACE(@empresa,'sbo',''),10) BASE, 
				ISNULL(CONVERT(nvarchar,(SELECT TOP 1 B.TaxIdNum From TPATHOBPL B WHERE O.BPLId = B.BPLID)),(SELECT TOP 1 B.TaxIdNum From TPATHOBPL B)) CNPJ2,
				ISNULL(O.LICTRADNUM,isnull((select top 1 r.lictradnum from TPATHocrd r where r.cardcode = o.cardcode),(select max(case when not (d.taxid0 = '' or d.taxid0 is null) then d.taxid0 else case when not (d.taxid4 = '' or d.taxid4 is null) then d.taxid4 else '' end end) from TPATHcrd7 d where d.cardcode = o.cardcode))) CNPJ,
				ISNULL(O.LICTRADNUM,isnull((select top 1 r.lictradnum from TPATHocrd r where r.cardcode = o.cardcode),(select max(case when not (d.taxid0 = '' or d.taxid0 is null) then d.taxid0 else case when not (d.taxid4 = '' or d.taxid4 is null) then d.taxid4 else '' end end) from TPATHcrd7 d where d.cardcode = o.cardcode))) KEYCNPJ,
				o.CARDCODE CODPN,
				O.CARDNAME NOMPN, 
				o.serial NFNUM, 
				O.CANCELED [STATUS],
				o.docentry DOCSAP, 
				o.TransId TRANSID, 
				cast(o.docdate as date) DTNF, 
				FORMAT(o.docdate,'yyyy/MM') PERIODO,
				(SELECT TOP 1 U.USAGE FROM TPATHpch1 V LEFT JOIN TPATHOUSG U ON U.ID = V.USAGE WHERE DOCENTRY = O.DOCENTRY) UTILIZACAO,
				CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM TPATHpch1 WHERE DOCENTRY = O.DOCENTRY)) VLRTOTPRO,
				ROUND(CONVERT(FLOAT,(SELECT SUM(LINEVAT) FROM TPATHpch1 WHERE DOCENTRY = O.DOCENTRY)),0) VLRTOTIPI,
				cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) VLRTOTNFS 
			From 
				TPATHopch o INNER JOIN
				TPATHocrd c on c.cardcode = o.cardcode inner join 
				TPATHocrg g on g.groupcode = c.groupcode 
			where 
				g.groupname like '%ligada%' and 
				FORMAT(o.docdate,'yyyy/MM') >= '2020/02' AND 
				O.CANCELED <> 'C' and o.model = 39

	end


/*
> > 6\. Bases que serão usadas para filtrar as coligadas que participarão da extração das devoluções de entradas e saídas:
*/

INSERT INTO #BASEDEVIN
	select DISTINCT
		MODO, 
		BASE, 
		CNPJDESTINO,
		CODPN
	From 
		#IN

INSERT INTO #BASEDEVOUT
	select DISTINCT
		MODO, 
		BASE, 
		CNPJDESTINO,
		CODPN
	From 
		#OUT


set @i = 0

while @i < @loop
	begin
		set @i = @i + 1; --inicio do laco
		set @empresa = (select empresa from mbs..bases where baseid = @i)
		set @pathOINV = CONCAT(N'CREATE SYNONYM tpathOINV FOR ',@empresa,N'.DBO.OINV');
		set @pathOCRD = CONCAT(N'CREATE SYNONYM tpathOCRD FOR ',@empresa,N'.DBO.OCRD');
		set @pathOCRG = CONCAT(N'CREATE SYNONYM tpathOCRG FOR ',@empresa,N'.DBO.OCRG');
		set @pathOBPL = CONCAT(N'CREATE SYNONYM tpathOBPL FOR ',@empresa,N'.DBO.OBPL');
		set @pathINV1 = CONCAT(N'CREATE SYNONYM tpathINV1 FOR ',@empresa,N'.DBO.INV1');
		set @pathOUSG = CONCAT(N'CREATE SYNONYM tpathOUSG FOR ',@empresa,N'.DBO.OUSG');
		set @pathOPCH = CONCAT(N'CREATE SYNONYM tpathOPCH FOR ',@empresa,N'.DBO.OPCH');
		set @pathPCH1 = CONCAT(N'CREATE SYNONYM tpathPCH1 FOR ',@empresa,N'.DBO.PCH1');
		set @pathCRD7 = CONCAT(N'CREATE SYNONYM tpathCRD7 FOR ',@empresa,N'.DBO.CRD7');
		set @pathORPC = CONCAT(N'CREATE SYNONYM tpathORPC FOR ',@empresa,N'.DBO.ORPC');
		set @pathRPC1 = CONCAT(N'CREATE SYNONYM tpathRPC1 FOR ',@empresa,N'.DBO.RPC1');
		set @pathORIN = CONCAT(N'CREATE SYNONYM tpathORIN FOR ',@empresa,N'.DBO.ORIN');
		set @pathRIN1 = CONCAT(N'CREATE SYNONYM tpathRIN1 FOR ',@empresa,N'.DBO.RIN1');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOINV') > 0 BEGIN DROP SYNONYM tpathOINV; EXEC(@pathOINV); END ELSE BEGIN exec(@pathOINV); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOCRD') > 0 BEGIN DROP SYNONYM tpathOCRD; EXEC(@pathOCRD); END ELSE BEGIN exec(@pathOCRD); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOCRG') > 0 BEGIN DROP SYNONYM tpathOCRG; EXEC(@pathOCRG); END ELSE BEGIN exec(@pathOCRG); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOBPL') > 0 BEGIN DROP SYNONYM tpathOBPL; EXEC(@pathOBPL); END ELSE BEGIN exec(@pathOBPL); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathINV1') > 0 BEGIN DROP SYNONYM tpathINV1; EXEC(@pathINV1); END ELSE BEGIN exec(@pathINV1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOUSG') > 0 BEGIN DROP SYNONYM tpathOUSG; EXEC(@pathOUSG); END ELSE BEGIN exec(@pathOUSG); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOPCH') > 0 BEGIN DROP SYNONYM tpathOPCH; EXEC(@pathOPCH); END ELSE BEGIN exec(@pathOPCH); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathPCH1') > 0 BEGIN DROP SYNONYM tpathPCH1; EXEC(@pathPCH1); END ELSE BEGIN exec(@pathPCH1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathCRD7') > 0 BEGIN DROP SYNONYM tpathCRD7; EXEC(@pathCRD7); END ELSE BEGIN exec(@pathCRD7); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathORPC') > 0 BEGIN DROP SYNONYM tpathORPC; EXEC(@pathORPC); END ELSE BEGIN exec(@pathORPC); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathRPC1') > 0 BEGIN DROP SYNONYM tpathRPC1; EXEC(@pathRPC1); END ELSE BEGIN exec(@pathRPC1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathORIN') > 0 BEGIN DROP SYNONYM tpathORIN; EXEC(@pathORIN); END ELSE BEGIN exec(@pathORIN); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathRIN1') > 0 BEGIN DROP SYNONYM tpathRIN1; EXEC(@pathRIN1); END ELSE BEGIN exec(@pathRIN1); END

		/*
		> > 7\. Inserir as notas fiscais devolvidas referentes às notas fiscais de saída (IN):
		*/
		INSERT INTO #IN
			SELECT
				'DIN' MODO, 
				LEFT(REPLACE(@empresa,'sbo',''),10) BASE, 
				ISNULL(CONVERT(nvarchar,(SELECT TOP 1 B.TaxIdNum From TPATHOBPL B WHERE O.BPLId = B.BPLID)),(SELECT TOP 1 B.TaxIdNum From TPATHOBPL B)) CNPJ2,
				O.LICTRADNUM CNPJ,
				O.LICTRADNUM KEYCNPJ,
				o.CARDCODE CODPN,
				O.CARDNAME NOMPN, 
				o.serial NFNUM, 
				O.CANCELED [STATUS],
				o.docentry DOCSAP, 
				o.TransId TRANSID, 
				cast(o.docdate as date) DTNF, 
				FORMAT(o.docdate,'yyyy/MM') PERIODO,
				(SELECT TOP 1 U.USAGE FROM TPATHrin1 V LEFT JOIN TPATHOUSG U ON U.ID = V.USAGE WHERE DOCENTRY = O.DOCENTRY) UTILIZACAO,
				CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM TPATHrin1 WHERE DOCENTRY = O.DOCENTRY)) VLRTOTPRO,
				ROUND(CONVERT(FLOAT,(SELECT SUM(LINEVAT) FROM TPATHrin1 WHERE DOCENTRY = O.DOCENTRY)),0) VLRTOTIPI,
				cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) VLRTOTNFS 
			From 
				TPATHorin o
			where 
				O.CardCode COLLATE DATABASE_DEFAULT IN (SELECT CODPN FROM #BASEDEVOUT WHERE BASE = LEFT(REPLACE(@empresa,'sbo',''),10)) AND
				FORMAT(o.docdate,'yyyy/MM') >= '2020/02' AND 
				O.CANCELED <> 'C' and o.model = 39
		/*
		> > <span style="background-color: rgba(127, 127, 127, 0.1);">8. Inserir as notas fiscais devolvidas referentes às notas fiscais de saída (IN):</span>
		*/

		INSERT INTO #OUT
			SELECT
				'DOU' MODO, 
				LEFT(REPLACE(@empresa,'sbo',''),10) BASE, 
				ISNULL(CONVERT(nvarchar,(SELECT TOP 1 B.TaxIdNum From TPATHOBPL B WHERE O.BPLId = B.BPLID)),(SELECT TOP 1 B.TaxIdNum From TPATHOBPL B)) CNPJ2,
				ISNULL(O.LICTRADNUM,isnull((select top 1 r.lictradnum from TPATHocrd r where r.cardcode = o.cardcode),(select max(case when not (d.taxid0 = '' or d.taxid0 is null) then d.taxid0 else case when not (d.taxid4 = '' or d.taxid4 is null) then d.taxid4 else '' end end) from TPATHcrd7 d where d.cardcode = o.cardcode))) CNPJ,
				ISNULL(CONVERT(nvarchar,(SELECT TOP 1 B.TaxIdNum From TPATHOBPL B WHERE O.BPLId = B.BPLID)),(SELECT TOP 1 B.TaxIdNum From TPATHOBPL B)) KEYCNPJ,
				o.CARDCODE CODPN,
				O.CARDNAME NOMPN, 
				o.serial NFNUM, 
				O.CANCELED [STATUS],
				o.docentry DOCSAP, 
				o.TransId TRANSID, 
				cast(o.docdate as date) DTNF, 
				FORMAT(o.docdate,'yyyy/MM') PERIODO,
				(SELECT TOP 1 U.USAGE FROM TPATHrpc1 V LEFT JOIN TPATHOUSG U ON U.ID = V.USAGE WHERE DOCENTRY = O.DOCENTRY) UTILIZACAO,
				CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM TPATHrpc1 WHERE DOCENTRY = O.DOCENTRY)) VLRTOTPRO,
				ROUND(CONVERT(FLOAT,(SELECT SUM(LINEVAT) FROM TPATHrpc1 WHERE DOCENTRY = O.DOCENTRY)),0) VLRTOTIPI,
				cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) VLRTOTNFS 
			From 
				TPATHorpc o INNER JOIN
				TPATHocrd c on c.cardcode = o.cardcode inner join 
				TPATHocrg g on g.groupcode = c.groupcode 
			where 
				g.groupname like '%ligada%' and 
				YEAR(o.docdate) >= 2020 AND
				O.CANCELED <> 'C' and o.model = 39
	end

/*
> > 9\. Agrupa os resultados em forma de tabela dos filtros aplicados noutra de RESULTADOS:
*/

INSERT INTO #RESULT
	SELECT 
		MODO
		,BASE
		,CNPJORIGEM
		,CNPJDESTINO
		,KEYCNPJ
		,CODPN
		,NOMPN
		,NFNUM
		,CANCELADO
		,DOCSAP
		,TRANSID
		,DTNF
		,PERIODO
		,isnull(UTILIZACAO,'') UTILIZACAO
		,VLRTOTPRO
		,VLRTOTIPI
		,VLRTOTNFS
		,@reportdate
	FROM #OUT

INSERT INTO #RESULT
	SELECT 
		MODO
		,BASE
		,CNPJORIGEM
		,CNPJDESTINO
		,KEYCNPJ
		,CODPN
		,NOMPN
		,NFNUM
		,CANCELADO
		,DOCSAP
		,TRANSID
		,DTNF
		,PERIODO
		,isnull(UTILIZACAO,'') UTILIZACAO
		,VLRTOTPRO
		,VLRTOTIPI
		,VLRTOTNFS
		,@reportdate
	FROM #IN

/*
> > 10\. Filtra os registros nao cancelados e elimina repeticoes iguais a 2 para um mesmo keycnpj vs nfnum:
*/

INSERT INTO MBS..NFSRESULT
	SELECT 
		 MODO
		,upper(BASE) BASE
		,CNPJORIGEM
		,CNPJDESTINO
		,KEYCNPJ
		,CODPN
		,NOMPN
		,NFNUM
		,CANCELADO
		,DOCSAP
		,isnull(TRANSID,0) TRANSID
		,DTNF
		,PERIODO
		,UTILIZACAO
		,VLRTOTPRO
		,VLRTOTIPI
		,VLRTOTNFS
		,REPORTDATE
	FROM #RESULT
	WHERE 
			NOMPN not like 'INNOVAPHARMA S.A' and
			((DTNF < GETDATE() - 6 AND
			DTNF > GETDATE() - 8 AND 
			MODO LIKE '%OU%' AND
			CONCAT(KEYCNPJ,NFNUM) IN 
									(SELECT 
										 CONCAT(KEYCNPJ,NFNUM)
									FROM #RESULT
									GROUP BY
										 CONCAT(KEYCNPJ,NFNUM)
										,CANCELADO
									HAVING CANCELADO = 'N' AND count(nfnum) <> 2)) OR

			(MODO LIKE '%IN%' AND
			DTNF > GETDATE() - 8 AND
			CONCAT(KEYCNPJ,NFNUM) IN 
									(SELECT 
											CONCAT(KEYCNPJ,NFNUM)
									FROM #RESULT
									GROUP BY
											CONCAT(KEYCNPJ,NFNUM)
										,CANCELADO
									HAVING CANCELADO = 'N' AND count(nfnum) <> 2)))
