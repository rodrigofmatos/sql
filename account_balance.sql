DROP TABLE IF EXISTS #base
DROP TABLE IF EXISTS #database
DROP TABLE IF EXISTS #contascontabeis
DROP TABLE IF EXISTS #resultado
DROP TABLE IF EXISTS #conferencia

CREATE TABLE MBS.DBO.SALDOCONTASDP(
	BASE [nvarchar](max) null,
	CODCONTA [nvarchar](max) null,
	CONTANOME [nvarchar](max) null,
	SALDOPLANOCONTAS [float] null,
	SALDORAZAO [float] null,
	DTHRSNAPSHOT [datetime] null
) ON [PRIMARY]

CREATE TABLE #conferencia(
	BASE [nvarchar](max) null,
	CODCONTA [nvarchar](max) null,
	CONTANOME [nvarchar](max) null,
	SALDOPLANOCONTAS [float] null,
	SALDORAZAO [float] null,
	DTHRSNAPSHOT [datetime] null
) ON [PRIMARY]

CREATE TABLE #resultado(
	BASE [nvarchar](max) null,
	CODCONTA [nvarchar](max) null,
	CONTANOME [nvarchar](max) null,
	DTINICIAL [nvarchar](max) null,
	SALDOINICI [float] null,
	SALDOMOVIM [float] null,
	SALDOATUAL [float] null,
	DTHORASALDO [datetime] null
) ON [PRIMARY]

select distinct [database_name] 
into #database 
from mbs..bkp_integra_folha_sap 
WHERE [database_name] NOT LIKE 'SBOEmpreendimentosLREZENDE'
order by [database_name]

select distinct [database_name], LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE([CONTA_CONTABIL], CHAR(10), ''), CHAR(13), ''), CHAR(9), ''), CHAR(160), ''))) [CONTA_CONTABIL]
into #contascontabeis
from mbs..bkp_integra_folha_sap 
WHERE [database_name] NOT LIKE 'SBOEmpreendimentosLREZENDE' AND LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE([CONTA_CONTABIL], CHAR(10), ''), CHAR(13), ''), CHAR(9), ''), CHAR(160), ''))) IS NOT NULL

select ROW_NUMBER() OVER (ORDER BY [database_name]) [BASEID], [database_name] into #base from #database order by [database_name]

DECLARE @loop int = (SELECT COUNT(baseid) FROM #base);
DECLARE @i int = 0; 
DECLARE @dthrsnapshot datetime = getdate();
DECLARE @empresa nvarchar(MAX);
DECLARE @pathJDT1 nvarchar(MAX);
DECLARE @pathOACT nvarchar(MAX);

while @i < @loop
	begin
		set @i = @i + 1;
		set @empresa = (select [database_name] from #base where baseid = @i)
		set @pathJDT1 = CONCAT(N'CREATE SYNONYM tpathJDT1 FOR ',@empresa,N'.DBO.JDT1');
		set @pathOACT = CONCAT(N'CREATE SYNONYM tpathOACT FOR ',@empresa,N'.DBO.OACT');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathJDT1') > 0 BEGIN DROP SYNONYM tpathJDT1; EXEC(@pathJDT1); END ELSE BEGIN exec(@pathJDT1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOACT') > 0 BEGIN DROP SYNONYM tpathOACT; EXEC(@pathOACT); END ELSE BEGIN exec(@pathOACT); END

	INSERT INTO #resultado
		SELECT
			@empresa BASE, 
			LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(J.account, CHAR(10), ''), CHAR(13), ''), CHAR(9), ''), CHAR(160), ''))) CODCONTA, 
			(SELECT ACCTNAME FROM tpathOACT WHERE ACCTCODE = LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(J.account, CHAR(10), ''), CHAR(13), ''), CHAR(9), ''), CHAR(160), '')))) CONTANOME,
			format(CAST(MIN(REFDATE) AS DATE),'dd/MM/yyyy') DATA_INICIAL,
			ROUND(((SELECT CAST(CURRTOTAL AS FLOAT) FROM tpathOACT WHERE ACCTCODE = LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(J.account, CHAR(10), ''), CHAR(13), ''), CHAR(9), ''), CHAR(160), '')))))-(SUM(CAST(J.DEBIT-J.CREDIT AS FLOAT))),2) SALDO_INICIAL,
			ROUND(SUM(CAST(J.DEBIT-J.CREDIT AS FLOAT)),2) SALDO_MOVIMENTO,
			ROUND(((SELECT CAST(CURRTOTAL AS FLOAT) FROM tpathOACT WHERE ACCTCODE = LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(J.account, CHAR(10), ''), CHAR(13), ''), CHAR(9), ''), CHAR(160), ''))))),2) SALDO_ATUAL, 
			FORMAT(GETDATE(),'dd/MM/yyyy HH:mm') DATA_HORA_SALDO_ATUAL
		FROM  tpathJDT1 J 
		WHERE 
			LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(J.account, CHAR(10), ''), CHAR(13), ''), CHAR(9), ''), CHAR(160), ''))) COLLATE DATABASE_DEFAULT in (SELECT LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE([CONTA_CONTABIL], CHAR(10), ''), CHAR(13), ''), CHAR(9), ''), CHAR(160), ''))) FROM #contascontabeis WHERE [database_name] LIKE @empresa) AND
			j.REFDATE <= '2020-12-31'
		GROUP BY J.account
END

set @i = 0;
while @i < @loop
	begin
		set @i = @i + 1;
		set @empresa = (select [database_name] from #base where baseid = @i)
		set @pathOACT = CONCAT(N'CREATE SYNONYM tpathOACT FOR ',@empresa,N'.DBO.OACT');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOACT') > 0 BEGIN DROP SYNONYM tpathOACT; EXEC(@pathOACT); END ELSE BEGIN exec(@pathOACT); END

		INSERT INTO MBS.DBO.SALDOCONTASDP
			SELECT
				@empresa BASE,
				acctcode CODCONTA,
				acctname NOMCONTA, 
				currtotal SALDOPLANOCONTAS, 
				CONVERT(NUMERIC(18,6),(select r.SALDOMOVIM from #resultado r where r.codconta COLLATE DATABASE_DEFAULT = acctcode and r.base = @empresa)) SALDORAZAO,
				@dthrsnapshot SNAPSHOT
			FROM
				tpathoact
			WHERE
				acctcode COLLATE DATABASE_DEFAULT in (select codconta from #resultado where base = @empresa)
	end

SELECT * FROM MBS.DBO.SALDOCONTASDP

set @i = 0;
while @i < @loop
	begin
		set @i = @i + 1;
		set @empresa = (select [database_name] from #base where baseid = @i)
		set @pathOACT = CONCAT(N'CREATE SYNONYM tpathOACT FOR ',@empresa,N'.DBO.OACT');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOACT') > 0 BEGIN DROP SYNONYM tpathOACT; EXEC(@pathOACT); END ELSE BEGIN exec(@pathOACT); END

		BEGIN TRANSACTION
			UPDATE tpathoact
				SET 
					currtotal = CONVERT(NUMERIC(18,6),(select r.SALDOMOVIM from #resultado r where r.codconta COLLATE DATABASE_DEFAULT = acctcode and r.base = @empresa)),
					systotal = CONVERT(NUMERIC(18,6),(select r.SALDOMOVIM from #resultado r where r.codconta COLLATE DATABASE_DEFAULT = acctcode and r.base = @empresa))
				WHERE
					acctcode COLLATE DATABASE_DEFAULT in (select codconta from #resultado where base = @empresa)
			
			INSERT INTO #conferencia
				SELECT
					@empresa BASE,
					acctcode CODCONTA,
					acctname NOMCONTA, 
					currtotal SALDOPLANOCONTAS, 
					CONVERT(NUMERIC(18,6),(select r.SALDOMOVIM from #resultado r where r.codconta COLLATE DATABASE_DEFAULT = acctcode and r.base = @empresa)) SALDORAZAO,
					@dthrsnapshot SNAPSHOT
				FROM
					tpathoact
				WHERE
					acctcode COLLATE DATABASE_DEFAULT in (select codconta from #resultado where base = @empresa)
			
			select * from #conferencia

		ROLLBACK TRANSACTION
	end