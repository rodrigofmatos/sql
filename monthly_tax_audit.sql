DECLARE @loop int = (SELECT COUNT(baseid) FROM mbs..bases);
DECLARE @i int = 0; 
DECLARE @empresa nvarchar(MAX);
DECLARE @pathinv4 nvarchar(MAX);
DECLARE @pathinv1 nvarchar(MAX);
DECLARE @pathoinv nvarchar(MAX);
DECLARE @pathrpc4 nvarchar(MAX);
DECLARE @pathrpc1 nvarchar(MAX);
DECLARE @pathorpc nvarchar(MAX);
DECLARE @pathousg nvarchar(MAX);
DECLARE @pathorca nvarchar(MAX);
DECLARE @pathoncm nvarchar(MAX);
DECLARE @pathoitm nvarchar(MAX);

DROP TABLE mbs.dbo.rpa006

CREATE TABLE mbs.[dbo].[rpa006](
	[MODELO] [nvarchar](30) NULL,
	[BASE] [nvarchar](30) NULL,
	[UFDest] [nvarchar](2) NULL,
	[DTHR] [nvarchar](50) NULL,
	[PERIODO] [nvarchar](50) NULL,
	[NF] [bigint] NULL,
	[ITEMCOD] [nvarchar](20) NULL,
	[ITEMNOM] [nvarchar](100) NULL,
	[DEP] [nvarchar](8) NULL,
	[NCM] [nvarchar](18) NULL,
	[CFOP] [nvarchar](6) NULL,
	[CSTPIS] [nvarchar](2) NULL,
	[CSTCOFINS] [nvarchar](2) NULL,
	[CSTICMS] [nvarchar](8) NULL,
	[ALIQICMS] [nvarchar](8) NULL,
	[VLRICMS] [float] NULL,
	[BASEICMS] [float] NULL,
	[VLRitemCUSTO] [float] NULL,
	[VLRitemVENDA] [float] NULL,
	[VLRtotVENDA] [float] NULL,
	[TIPO] [nvarchar](20) NULL
) ON [PRIMARY]


while @i < @loop
	begin
		set @i = @i + 1; --inicio do laco
		set @empresa = (select empresa from mbs..bases where baseid = @i)
		set @pathinv1 = CONCAT(N'CREATE SYNONYM tpathinv1 FOR ',@empresa,N'.DBO.inv1');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathinv1') > 0 BEGIN DROP SYNONYM tpathinv1; EXEC(@pathinv1); END ELSE BEGIN exec(@pathinv1); END
		set @pathinv4 = CONCAT(N'CREATE SYNONYM tpathinv4 FOR ',@empresa,N'.DBO.inv4');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathinv4') > 0 BEGIN DROP SYNONYM tpathinv4; EXEC(@pathinv4); END ELSE BEGIN exec(@pathinv4); END
		set @pathoinv = CONCAT(N'CREATE SYNONYM tpathoinv FOR ',@empresa,N'.DBO.oinv');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathoinv') > 0 BEGIN DROP SYNONYM tpathoinv; EXEC(@pathoinv); END ELSE BEGIN exec(@pathoinv); END
		set @pathrpc1 = CONCAT(N'CREATE SYNONYM tpathrpc1 FOR ',@empresa,N'.DBO.rpc1');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathrpc1') > 0 BEGIN DROP SYNONYM tpathrpc1; EXEC(@pathrpc1); END ELSE BEGIN exec(@pathrpc1); END
		set @pathrpc4 = CONCAT(N'CREATE SYNONYM tpathrpc4 FOR ',@empresa,N'.DBO.rpc4');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathrpc4') > 0 BEGIN DROP SYNONYM tpathrpc4; EXEC(@pathrpc4); END ELSE BEGIN exec(@pathrpc4); END
		set @pathorpc = CONCAT(N'CREATE SYNONYM tpathorpc FOR ',@empresa,N'.DBO.orpc');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathorpc') > 0 BEGIN DROP SYNONYM tpathorpc; EXEC(@pathorpc); END ELSE BEGIN exec(@pathorpc); END
		set @pathousg = CONCAT(N'CREATE SYNONYM tpathousg FOR ',@empresa,N'.DBO.ousg');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathousg') > 0 BEGIN DROP SYNONYM tpathousg; EXEC(@pathousg); END ELSE BEGIN exec(@pathousg); END
		set @pathorca = CONCAT(N'CREATE SYNONYM tpathorca FOR ',@empresa,N'.DBO.[@FT_ORCA]');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathorca') > 0 BEGIN DROP SYNONYM tpathorca; EXEC(@pathorca); END ELSE BEGIN exec(@pathorca); END
		set @pathoncm = CONCAT(N'CREATE SYNONYM tpathoncm FOR ',@empresa,N'.DBO.oncm');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathoncm') > 0 BEGIN DROP SYNONYM tpathoncm; EXEC(@pathoncm); END ELSE BEGIN exec(@pathoncm); END
		set @pathoitm = CONCAT(N'CREATE SYNONYM tpathoitm FOR ',@empresa,N'.DBO.oitm');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathoitm') > 0 BEGIN DROP SYNONYM tpathoitm; EXEC(@pathoitm); END ELSE BEGIN exec(@pathoitm); END
		
		--NOTAS FISCAIS DE SAIDA
		INSERT INTO mbs..rpa006
			select 'FAT_NFS' MODELO,
				replace(upper(@empresa),'sbo','') BASE
				,replace(left(right(i.shiptodesc,9),2),char(13),'') UFDest
				,concat(cast(o.docdate as date),' ',left(format(o.createts,'00\:0000'),5)) DTHR
				,FORMAT(cast(o.docdate as date),'yyyy/MM') PERIODO
				,o.serial NFNUM
				,i.ItemCode ITEMCOD
				,i.Dscription ITEMNOM
				,i.whscode DEP
				,coalesce((SELECT NCMCODE FROM tpathoncm WHERE ABSENTRY = (select ncmcode from tpathoitm where itemcode = i.itemcode)),format((select ncmcode from tpathoitm where itemcode = i.itemcode),'0')) NCM
				,i.cfopcode CFOP
				,i.cstfpis CSTPIS
				,i.cstfcofins CSTCOFINS
				,i.cstcode CSTICMS
				,FORMAT(v.taxrate/100,'0%') ALIQICMS
				,CAST(v.taxsum AS FLOAT) VLRICMS
				,CAST(COALESCE(v.basesum,0) AS FLOAT) BASEICMS
				,CAST(i.stockprice AS FLOAT) VLRitemCUSTO
				,CAST(i.price AS FLOAT) VLRitemVENDA
				,CAST(i.linetotal AS FLOAT) VLRtotVENDA
				,g.usage TIPO

			from 
				tpathoinv o WITH (NOLOCK) inner join 
				tpathinv1 i WITH (NOLOCK) on i.docentry = o.docentry and i.openqty > 0 inner join
				tpathinv4 v WITH (NOLOCK) on v.docentry = i.docentry and v.linenum = i.linenum left join
				tpathousg g WITH (NOLOCK) on g.id = i.usage

			where 
				year(o.docdate)>=2012 and i.cstfpis IN ('01','02') AND i.cstFCOFINS IN ('01','02') AND-- i.cstcode > '%2%' AND
				(g.usage like '%venda%' or g.usage like '%bonif%') and
				 o.canceled = 'n' AND V.TAXRATE > 0  AND o.docdate>= '2020-01-01'

--DEVOLUCAO DE NOTAS FISCAIS DE ENTRADA
		INSERT INTO mbs..rpa006
			select 'DEV_COMPRA' MODELO,
				replace(upper(@empresa),'sbo','') BASE
				,replace(left(right(i.shiptodesc,9),2),char(13),'') UFDest
				,concat(cast(o.docdate as date),' ',left(format(o.createts,'00\:0000'),5)) DTHR
				,FORMAT(cast(o.docdate as date),'yyyy/MM') PERIODO
				,o.serial NFNUM
				,i.ItemCode ITEMCOD
				,i.Dscription ITEMNOM
				,i.whscode DEP
				,coalesce((SELECT NCMCODE FROM tpathoncm WHERE ABSENTRY = (select ncmcode from tpathoitm where itemcode = i.itemcode)),format((select ncmcode from tpathoitm where itemcode = i.itemcode),'0')) NCM
				,i.cfopcode CFOP
				,i.cstfpis CSTPIS
				,i.cstfcofins CSTCOFINS
				,i.cstcode CSTICMS
				,FORMAT(v.taxrate/100,'0%') ALIQICMS
				,CAST(v.taxsum AS FLOAT) VLRICMS
				,CAST(COALESCE(v.basesum,0) AS FLOAT) BASEICMS
				,CAST(i.stockprice AS FLOAT) VLRitemCUSTO
				,CAST(i.price AS FLOAT) VLRitemVENDA
				,CAST(i.linetotal AS FLOAT) VLRtotVENDA
				,g.usage TIPO

			from 
				tpathorpc o WITH (NOLOCK) inner join 
				tpathrpc1 i WITH (NOLOCK) on i.docentry = o.docentry and i.openqty > 0 inner join
				tpathrpc4 v WITH (NOLOCK) on v.docentry = i.docentry and v.linenum = i.linenum left join
				tpathousg g WITH (NOLOCK) on g.id = i.usage

			where 
				year(o.docdate)>=2012 and i.cstfpis IN ('01','02') AND i.cstFCOFINS IN ('01','02') AND-- i.cstcode > '%2%' AND
				o.canceled = 'n' AND V.TAXRATE > 0 AND o.docdate>= '2020-01-01'

		end;	  

select * from mbs..rpa006
