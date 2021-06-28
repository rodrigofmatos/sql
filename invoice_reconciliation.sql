DROP TABLE MBS..XXOUT
DROP TABLE MBS..XXIN

CREATE TABLE MBS.[dbo].[XXIN](
[Empresa] [varchar](10) NULL,
[CNPJ] [nvarchar](22) NULL,
[RAZAOSOCIAL] [nvarchar](100) NULL,
[NF] [int] NULL,
[SAP] [int] NULL,
[DTNF] [date] NULL,
[VLRTOTNF] [float] NULL
) ON [PRIMARY]

CREATE TABLE MBS.[dbo].[XXOUT](
[Empresa] [varchar](10) NULL,
[CNPJ] [nvarchar](22) NULL,
[RAZAOSOCIAL] [nvarchar](100) NULL,
[NF] [int] NULL,
[SAP] [int] NULL,
[DTNF] [date] NULL,
[VLRTOTNF] [float] NULL
) ON [PRIMARY]

INSERT INTO MBS..XXOUT


--SAIDAS RESUMO EMPRESAS
	select DISTINCT
		'OUT' MODO, 'NPH' Empresa, 
		C.LICTRADNUM, 
		o.cardname
	From 
		SBONutGynMatriz..oinv o inner join 
		SBONutGynMatriz..ocrd c on c.cardcode = o.cardcode inner join 
		SBONutGynMatriz..ocrg g on g.groupcode = c.groupcode 
	where 
		g.groupname like '%ligada%' and 
		o.canceled = 'n' AND 
		C.LICTRADNUM IS NOT NULL AND 
		YEAR(o.docdate) >= 2015 AND
		ROUND(cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) - CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM SBONutGynMatriz..INV1 WHERE DOCENTRY = O.DOCENTRY)),0) > 0

--SAIDAS NPH
	select
		'OUT' MODO, 'NPH' Empresa, 
		C.LICTRADNUM, 
		o.cardname, 
		o.serial NF, 
		o.docentry SAP, 
		cast(o.docdate as date) DTNF, FORMAT(o.docdate,'yyyy/MM') PERIODO,
		(SELECT TOP 1 U.USAGE FROM SBONutGynMatriz..INV1 V LEFT JOIN SBONutGynMatriz..OUSG U ON U.ID = V.USAGE WHERE DOCENTRY = O.DOCENTRY) UTILIZACAO,
		CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM SBONutGynMatriz..INV1 WHERE DOCENTRY = O.DOCENTRY)) VLRTOTPRO,
		ROUND(CONVERT(FLOAT,(SELECT SUM(LINEVAT) FROM SBONutGynMatriz..INV1 WHERE DOCENTRY = O.DOCENTRY)),0) VLRTOTIPI,
		cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) VLRTOTNFS 
	From 
		SBONutGynMatriz..oinv o inner join 
		SBONutGynMatriz..ocrd c on c.cardcode = o.cardcode inner join 
		SBONutGynMatriz..ocrg g on g.groupcode = c.groupcode 
	where 
		g.groupname like '%ligada%' and 
		o.canceled = 'n' AND 
		C.LICTRADNUM IS NOT NULL AND 
		YEAR(o.docdate) >= 2015 AND
		ROUND(cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) - CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM SBONutGynMatriz..INV1 WHERE DOCENTRY = O.DOCENTRY)),0) > 0

UNION

--ENTRADAS VDM
	select 
		'IN' MODO, 'VDM' Empresa, 
		C1.LICTRADNUM, 
		o.cardname, 
		o.serial NF, 
		o.docentry SAP, 
		cast(o.docdate as date) DTNF, FORMAT(o.docdate,'yyyy/MM') PERIODO,
		(SELECT TOP 1 U.USAGE FROM SBOVIDAFARMA..pch1 V LEFT JOIN SBOVIDAFARMA..OUSG U ON U.ID = V.USAGE WHERE DOCENTRY = O.DOCENTRY) UTILIZACAO,
		CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM SBOVIDAFARMA..pch1 WHERE DOCENTRY = O.DOCENTRY)) VLRTOTPRO,
		ROUND(CONVERT(FLOAT,(SELECT SUM(LINEVAT) FROM SBOVIDAFARMA..pch1 WHERE DOCENTRY = O.DOCENTRY)),0) VLRTOTIPI,
		cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) VLRTOTNFS 
	From 
		SBOVIDAFARMA..opch o inner join 
		SBOVIDAFARMA..ocrd c1 on c1.cardcode = o.cardcode inner join 
		SBOVIDAFARMA..ocrg g on g.groupcode = c1.groupcode 
	where c1.lictradnum like '06.172.459/0001-59' and o.serial in
					(select distinct
						o.serial
					From 
						SBONutGynMatriz..oinv o inner join 
						SBONutGynMatriz..ocrd c on c.cardcode = o.cardcode inner join 
						SBONutGynMatriz..ocrg g on g.groupcode = c.groupcode 
					where 
						g.groupname like '%ligada%' and O.CARDNAME LIKE 'VDM%' AND
						o.canceled = 'n' AND 
						C.LICTRADNUM IS NOT NULL AND 
						YEAR(o.docdate) >= 2015
						)	and
		o.canceled = 'n' AND
		YEAR(o.docdate) >= 2015 

UNION

--ENTRADAS MW
	select 
		'IN' MODO, 'MW' Empresa, 
		C1.LICTRADNUM, 
		o.cardname, 
		o.serial NF, 
		o.docentry SAP, 
		cast(o.docdate as date) DTNF, FORMAT(o.docdate,'yyyy/MM') PERIODO,
		(SELECT TOP 1 U.USAGE FROM SBOMW..pch1 V LEFT JOIN SBOMW..OUSG U ON U.ID = V.USAGE WHERE DOCENTRY = O.DOCENTRY) UTILIZACAO,
		CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM SBOMW..pch1 WHERE DOCENTRY = O.DOCENTRY)) VLRTOTPRO,
		ROUND(CONVERT(FLOAT,(SELECT SUM(LINEVAT) FROM SBOMW..pch1 WHERE DOCENTRY = O.DOCENTRY)),0) VLRTOTIPI,
		cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) VLRTOTNFS 
	From 
		SBOMW..opch o inner join 
		SBOMW..ocrd c1 on c1.cardcode = o.cardcode inner join 
		SBOMW..ocrg g on g.groupcode = c1.groupcode 
	where c1.lictradnum like '06.172.459/0001-59' and o.serial in
					(select distinct
						o.serial
					From 
						SBONutGynMatriz..oinv o inner join 
						SBONutGynMatriz..ocrd c on c.cardcode = o.cardcode inner join 
						SBONutGynMatriz..ocrg g on g.groupcode = c.groupcode 
					where 
						g.groupname like '%ligada%' and (O.CARDNAME LIKE 'MW%' OR O.CARDNAME LIKE '%NUTRAC%') AND
						o.canceled = 'n' AND 
						C.LICTRADNUM IS NOT NULL AND 
						YEAR(o.docdate) >= 2015
						)	and
		o.canceled = 'n' AND
		YEAR(o.docdate) >= 2015 

UNION

--ENTRADAS EQUILIBRIUM
	select 
		'IN' MODO, 'EQ' Empresa, 
		C1.LICTRADNUM, 
		o.cardname, 
		o.serial NF, 
		o.docentry SAP, 
		cast(o.docdate as date) DTNF, FORMAT(o.docdate,'yyyy/MM') PERIODO,
		(SELECT TOP 1 U.USAGE FROM SBOEQUILIBRIUM..pch1 V LEFT JOIN SBOEQUILIBRIUM..OUSG U ON U.ID = V.USAGE WHERE DOCENTRY = O.DOCENTRY) UTILIZACAO,
		CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM SBOEQUILIBRIUM..pch1 WHERE DOCENTRY = O.DOCENTRY)) VLRTOTPRO,
		ROUND(CONVERT(FLOAT,(SELECT SUM(LINEVAT) FROM SBOEQUILIBRIUM..pch1 WHERE DOCENTRY = O.DOCENTRY)),0) VLRTOTIPI,
		cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) VLRTOTNFS 
	From 
		SBOEQUILIBRIUM..opch o inner join 
		SBOEQUILIBRIUM..ocrd c1 on c1.cardcode = o.cardcode inner join 
		SBOEQUILIBRIUM..ocrg g on g.groupcode = c1.groupcode 
	where c1.lictradnum like '06.172.459/0001-59' and o.serial in
					(select distinct
						o.serial
					From 
						SBONutGynMatriz..oinv o inner join 
						SBONutGynMatriz..ocrd c on c.cardcode = o.cardcode inner join 
						SBONutGynMatriz..ocrg g on g.groupcode = c.groupcode 
					where 
						g.groupname like '%ligada%' and O.CARDNAME LIKE 'EQUILIBRIUM%' AND
						o.canceled = 'n' AND 
						C.LICTRADNUM IS NOT NULL AND 
						YEAR(o.docdate) >= 2015
						)	and
		o.canceled = 'n' AND
		YEAR(o.docdate) >= 2015 


UNION

--ENTRADAS A7
	select 
		'IN' MODO, 'A7' Empresa, 
		C1.LICTRADNUM, 
		o.cardname, 
		o.serial NF, 
		o.docentry SAP, 
		cast(o.docdate as date) DTNF, FORMAT(o.docdate,'yyyy/MM') PERIODO,
		(SELECT TOP 1 U.USAGE FROM SBOA7..pch1 V LEFT JOIN SBOA7..OUSG U ON U.ID = V.USAGE WHERE DOCENTRY = O.DOCENTRY) UTILIZACAO,
		CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM SBOA7..pch1 WHERE DOCENTRY = O.DOCENTRY)) VLRTOTPRO,
		ROUND(CONVERT(FLOAT,(SELECT SUM(LINEVAT) FROM SBOA7..pch1 WHERE DOCENTRY = O.DOCENTRY)),0) VLRTOTIPI,
		cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) VLRTOTNFS 
	From 
		SBOA7..opch o inner join 
		SBOA7..ocrd c1 on c1.cardcode = o.cardcode inner join 
		SBOA7..ocrg g on g.groupcode = c1.groupcode 
	where c1.lictradnum like '06.172.459/0001-59' and o.serial in
					(select distinct
						o.serial
					From 
						SBONutGynMatriz..oinv o inner join 
						SBONutGynMatriz..ocrd c on c.cardcode = o.cardcode inner join 
						SBONutGynMatriz..ocrg g on g.groupcode = c.groupcode 
					where 
						g.groupname like '%ligada%' and O.CARDNAME LIKE 'A7%' AND
						o.canceled = 'n' AND 
						C.LICTRADNUM IS NOT NULL AND 
						YEAR(o.docdate) >= 2015
						)	and
		o.canceled = 'n' AND
		YEAR(o.docdate) >= 2015 


UNION

--ENTRADAS INDCOSM
	select 
		'IN' MODO, 'IC' Empresa, 
		C1.LICTRADNUM, 
		o.cardname, 
		o.serial NF, 
		o.docentry SAP, 
		cast(o.docdate as date) DTNF, FORMAT(o.docdate,'yyyy/MM') PERIODO,
		(SELECT TOP 1 U.USAGE FROM SBONUTRIEXIND..pch1 V LEFT JOIN SBONUTRIEXIND..OUSG U ON U.ID = V.USAGE WHERE DOCENTRY = O.DOCENTRY) UTILIZACAO,
		CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM SBONUTRIEXIND..pch1 WHERE DOCENTRY = O.DOCENTRY)) VLRTOTPRO,
		ROUND(CONVERT(FLOAT,(SELECT SUM(LINEVAT) FROM SBONUTRIEXIND..pch1 WHERE DOCENTRY = O.DOCENTRY)),0) VLRTOTIPI,
		cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) VLRTOTNFS 
	From 
		SBONUTRIEXIND..opch o inner join 
		SBONUTRIEXIND..ocrd c1 on c1.cardcode = o.cardcode inner join 
		SBONUTRIEXIND..ocrg g on g.groupcode = c1.groupcode 
	where c1.lictradnum like '06.172.459/0001-59' and o.serial in
					(select distinct
						o.serial
					From 
						SBONutGynMatriz..oinv o inner join 
						SBONutGynMatriz..ocrd c on c.cardcode = o.cardcode inner join 
						SBONutGynMatriz..ocrg g on g.groupcode = c.groupcode 
					where 
						g.groupname like '%ligada%' and O.CARDNAME LIKE '%COSM%' AND
						o.canceled = 'n' AND 
						C.LICTRADNUM IS NOT NULL AND 
						YEAR(o.docdate) >= 2015
						)	and
		o.canceled = 'n' AND
		YEAR(o.docdate) >= 2015 


UNION

--ENTRADAS IL
	select 
		'IN' MODO, 'IL' Empresa, 
		COALESCE(C1.LICTRADNUM,'06.172.459/0001-59') LICTRADNUM, 
		o.cardname, 
		o.serial NF, 
		o.docentry SAP, 
		cast(o.docdate as date) DTNF, FORMAT(o.docdate,'yyyy/MM') PERIODO,
		(SELECT TOP 1 U.USAGE FROM SBOINNOVALAB..pch1 V LEFT JOIN SBOINNOVALAB..OUSG U ON U.ID = V.USAGE WHERE DOCENTRY = O.DOCENTRY) UTILIZACAO,
		CONVERT(FLOAT,(SELECT SUM(LINETOTAL) FROM SBOINNOVALAB..pch1 WHERE DOCENTRY = O.DOCENTRY)) VLRTOTPRO,
		ROUND(CONVERT(FLOAT,(SELECT SUM(LINEVAT) FROM SBOINNOVALAB..pch1 WHERE DOCENTRY = O.DOCENTRY)),0) VLRTOTIPI,
		cast(CASE WHEN o.MAX1099 IS NULL OR O.MAX1099 = 0 THEN O.DOCTOTAL ELSE O.MAX1099 END AS FLOAT) VLRTOTNFS 
	From 
		SBOINNOVALAB..opch o inner join 
		SBOINNOVALAB..ocrd c1 on c1.cardcode = o.cardcode inner join 
		SBOINNOVALAB..ocrg g on g.groupcode = c1.groupcode 
	where c1.CardName like 'NUT%IMP%' and o.serial in
					(select distinct
						o.serial
					From 
						SBONutGynMatriz..oinv o inner join 
						SBONutGynMatriz..ocrd c on c.cardcode = o.cardcode inner join 
						SBONutGynMatriz..ocrg g on g.groupcode = c.groupcode 
					where 
						g.groupname like '%ligada%' and O.CARDNAME LIKE 'INNOVA%' AND
						o.canceled = 'n' AND 
						C.LICTRADNUM IS NOT NULL AND 
						YEAR(o.docdate) >= 2015
						)	and
		o.canceled = 'n' AND
		YEAR(o.docdate) >= 2015