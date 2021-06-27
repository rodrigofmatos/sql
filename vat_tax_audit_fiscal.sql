DECLARE @loop int = (SELECT COUNT(baseid) FROM mbs..bases);
DECLARE @i int = 0; 
DECLARE @empresa nvarchar(MAX);
DECLARE @pathinv4 nvarchar(MAX);
DECLARE @pathinv1 nvarchar(MAX);
DECLARE @pathoinv nvarchar(MAX);
DECLARE @pathousg nvarchar(MAX);
DECLARE @pathorca nvarchar(MAX);

DROP TABLE mbs.dbo.rpa006

CREATE TABLE mbs.[dbo].[rpa006](
	[BASE] [nvarchar](30) NULL,
	[UFDest] [nvarchar](2) NULL,
	[DTHR] [nvarchar](50) NULL,
	[NF] [bigint] NULL,
	[ITEMCOD] [nvarchar](20) NULL,
	[ITEMNOM] [nvarchar](100) NULL,
	[DEP] [nvarchar](8) NULL,
	[CFOP] [nvarchar](6) NULL,
	[CSTPIS] [nvarchar](2) NULL,
	[CSTICMS] [nvarchar](8) NULL,
	[ALIQICMS] [nvarchar](8) NULL,
	[VLRICMS] [float] NULL,
	[BASEICMS] [float] NULL,
	[VLRCUSTO] [float] NULL,
	[VLRVENDA] [float] NULL,
	[TIPO] [nvarchar](20) NULL,
	[VENDEDOR] [nvarchar](100) NULL
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
		set @pathousg = CONCAT(N'CREATE SYNONYM tpathousg FOR ',@empresa,N'.DBO.ousg');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathousg') > 0 BEGIN DROP SYNONYM tpathousg; EXEC(@pathousg); END ELSE BEGIN exec(@pathousg); END
		set @pathorca = CONCAT(N'CREATE SYNONYM tpathorca FOR ',@empresa,N'.DBO.[@FT_ORCA]');
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathorca') > 0 BEGIN DROP SYNONYM tpathorca; EXEC(@pathorca); END ELSE BEGIN exec(@pathorca); END
		
		INSERT INTO mbs..rpa006
			select
				replace(upper(@empresa),'sbo','') BASE
				,replace(left(right(i.shiptodesc,9),2),char(13),'') UFDest
				,concat(cast(o.docdate as date),' ',left(format(o.createts,'00\:0000'),5)) DTHR
				,o.serial NF
				,i.ItemCode ITEMCOD
				,i.Dscription ITEMNOM
				,i.whscode DEP
				,i.cfopcode CFOP
				,i.cstfpis CSTPIS
				,i.cstcode CSTICMS
				,FORMAT(v.taxrate/100,'0%') ALIQICMS
				,CAST(v.taxsum AS FLOAT) VLRICMS
				,CAST(v.basesum AS FLOAT) BASEICMS
				,CAST(i.stockprice AS FLOAT) VLRCUSTO
				,CAST(i.price AS FLOAT) VLRVENDA
				,g.usage TIPO
				,left(r.name,40) VENDEDOR

			from 
				tpathoinv o WITH (NOLOCK) inner join 
				tpathinv1 i WITH (NOLOCK) on i.docentry = o.docentry and i.openqty > 0 inner join
				tpathinv4 v WITH (NOLOCK) on v.docentry = i.docentry and v.linenum = i.linenum left join
				tpathousg g WITH (NOLOCK) on g.id = i.usage left join
				tpathorca r WITH (NOLOCK) on r.code = o.slpcode	

			where 
				year(o.docdate)=2020 and month(o.docdate)=10 and
				v.statype = 2 AND
				(g.usage like '%venda%' or g.usage like '%bonif%') and
				r.name not like 'coligadas' and o.canceled = 'n'
		end;	  

select * from mbs..rpa006