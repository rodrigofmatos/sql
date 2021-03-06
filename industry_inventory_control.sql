DROP TABLE MBS.DBO.RPA010_BASE
CREATE TABLE MBS.DBO.RPA010_BASE(
	[BASEID] [int] NULL,
	[EMPRESA] [nvarchar](40) NULL
) ON [PRIMARY]

INSERT INTO MBS.DBO.RPA010_BASE
	SELECT ROW_NUMBER() OVER(ORDER BY EMPRESA ASC) AS BASEID, EMPRESA FROM MBS..BASES where EMPRESA not in ('SboChuaChua','SBOEmpLREZENDE','SBOEmpreendimentosRZ','SBOEmpreendimentosSM','SBOGdsMarcasEU','SBOLCA','SBOLICITAACAO','SBOML','SBOVZ','SBOZ9')

DECLARE @loop int = (SELECT COUNT(baseid) FROM MBS.DBO.RPA010_BASE);
DECLARE @i int = 0;
DECLARE @empresa nvarchar(MAX);
DECLARE @pathoitm nvarchar(MAX);
DECLARE @pathOMTP nvarchar(MAX);
DECLARE @pathOMGP nvarchar(MAX);
DECLARE @pathOITB nvarchar(MAX);

DROP TABLE mbs.dbo.rpa010

CREATE TABLE mbs.[dbo].[rpa010](
	[BASE] [nvarchar](40) NULL,
	[COD] [nvarchar](40) NULL,
	[ITEM] [nvarchar](100) NULL,
	[U_TIPO] [nvarchar](100) NULL,
	[TIPO_MAT] [nvarchar](100) NULL,
	[TIPO_GRP] [nvarchar](100) NULL,
	[TIPO_IMP] [nvarchar](100) NULL,
	[NCM] [int] NULL
) ON [PRIMARY]


while @i < @loop
	begin
		set @i = @i + 1; --inicio do laco
		set @empresa = (select empresa from MBS.DBO.RPA010_BASE where baseid = @i)
		set @pathoitm = CONCAT(N'CREATE SYNONYM tpathoitm FOR ',@empresa,N'.DBO.oitm');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathoitm') > 0 BEGIN DROP SYNONYM tpathoitm; EXEC(@pathoitm); END ELSE BEGIN exec(@pathoitm); END
		set @pathOMTP = CONCAT(N'CREATE SYNONYM tpathOMTP FOR ',@empresa,N'.DBO.OMTP');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOMTP') > 0 BEGIN DROP SYNONYM tpathOMTP; EXEC(@pathOMTP); END ELSE BEGIN exec(@pathOMTP); END
		set @pathOMGP = CONCAT(N'CREATE SYNONYM tpathOMGP FOR ',@empresa,N'.DBO.OMGP');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOMGP') > 0 BEGIN DROP SYNONYM tpathOMGP; EXEC(@pathOMGP); END ELSE BEGIN exec(@pathOMGP); END
		set @pathOITB = CONCAT(N'CREATE SYNONYM tpathOITB FOR ',@empresa,N'.DBO.OITB');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOITB') > 0 BEGIN DROP SYNONYM tpathOITB; EXEC(@pathOITB); END ELSE BEGIN exec(@pathOITB); END
		
		INSERT INTO mbs..rpa010
			SELECT
				 @empresa BASE
				,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(o.ITEMCODE,';','|'),'"',''),',',' '),CHAR(13),''),CHAR(10),''),CHAR(9),''),'*',''),':','') COD
				,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(o.ITEMNAME,';','|'),'"',''),',',' '),CHAR(13),''),CHAR(10),''),CHAR(9),''),'*',''),':','') ITEM
				,'ITEM'
				,CONCAT(o.MATTYPE COLLATE DATABASE_DEFAULT,'_',REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(m.MatType,';','|'),'"',''),',',' '),CHAR(13),''),CHAR(10),''),CHAR(9),''),'*',''),':','') COLLATE DATABASE_DEFAULT) TIPO_MAT
				,CONCAT(o.MATGRP,'_',REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(g.Descrip,';','|'),'"',''),',',' '),CHAR(13),''),CHAR(10),''),CHAR(9),''),'*',''),':','') COLLATE DATABASE_DEFAULT) TIPO_GRP
				,CONCAT(o.ITMSGRPCOD,'_',REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(t.ItmsGrpNam,';','|'),'"',''),',',' '),CHAR(13),''),CHAR(10),''),CHAR(9),''),'*',''),':','') COLLATE DATABASE_DEFAULT) TIPO_IMP
				,o.NCMCODE NCM
			FROM 
				tpathoitm o WITH (NOLOCK) LEFT JOIN
				tpathOMTP m WITH (NOLOCK) ON m.absentry = o.MatType LEFT JOIN
				tpathOMGP g WITH (NOLOCK) ON g.absentry = o.MatGrp LEFT JOIN
				tpathOITB t WITH (NOLOCK) ON t.ItmsGrpCod = o.ItmsGrpCod
			WHERE
				o.itemclass = 2

	end;	  

UPDATE MBS..RPA010 SET U_TIPO = CASE WHEN CHARINDEX(' ',ITEM) = 0 THEN ITEM ELSE SUBSTRING(ITEM,1,CHARINDEX(' ',ITEM)) END

select * from mbs..rpa010