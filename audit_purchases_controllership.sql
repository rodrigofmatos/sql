DROP TABLE [Mbs].[dbo].[hidra001]
DROP TABLE [Mbs].[dbo].[hidra002]

CREATE TABLE [Mbs].[dbo].[hidra001](
	[EMPRESA] [varchar](2) NULL,
	[CODSAP] [int] NULL,
	[TIPODOC] [int] NULL,
	[NFNUM] [int] NULL,
	[CODSAP_Ref] [int] NULL,
	[TIPODOC_Ref] [int] NULL,
	[CODITEM] [nvarchar](50) NULL,
	[NOMITEM] [nvarchar](100) NULL,
	[DTDOC] [date] NULL,
	[CODFORN] [nvarchar](15) NULL,
	[NOMFORN] [nvarchar](100) NULL,
	[UTILIZACAO] [nvarchar](20) NULL,
	[CFOP] [nvarchar](6) NULL,
	[COLIGADA] [varchar](1) NULL,
	[QTDE] [float] NULL,
	[VLRUNIT] [float] NULL,
	[VLRTOTAL] [float] NULL
) ON [PRIMARY]

CREATE TABLE [Mbs].[dbo].[hidra002](
	[EMPRESA] [varchar](2) NULL,
	[ORIGEM] [varchar](25) NULL,
	[CODSAP] [int] NULL,
	[TIPODOC] [int] NULL,
	[NFNUM] [int] NULL,
	[CODSAP_Ref] [int] NULL,
	[TIPODOC_Ref] [int] NULL,
	[NFNUM_Ref] [int] NULL,
	[CODITEM] [nvarchar](50) NULL,
	[NOMITEM] [nvarchar](100) NULL,
	[DTDOC] [date] NULL,
	[DTDOC_Ref] [date] NULL,
	[CODFORN] [nvarchar](15) NULL,
	[NOMFORN] [nvarchar](100) NULL,
	[UTILIZACAO] [nvarchar](20) NULL,
	[CFOP] [nvarchar](6) NULL,
	[COLIGADA] [varchar](1) NULL,
	[QTDE] [float] NULL,
	[VLRUNIT] [float] NULL,
	[VLRTOTAL] [float] NULL,
	[VLRTOTDOC_Ref] [float] NULL
) ON [PRIMARY]

insert into [Mbs].[dbo].[hidra001]
	select 
		'EQ' AS EMPRESA,
		o.docentry CODSAP,
		o.DocType TIPODOC,


		CAST((case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.SERIAL FROM SBOEquilibrium..oinv p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 14 then COALESCE((SELECT top 1 p.SERIAL FROM SBOEquilibrium..orin p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 17 then COALESCE((SELECT top 1 p.SERIAL FROM SBOEquilibrium..ordr p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 18 then COALESCE((SELECT top 1 p.SERIAL FROM SBOEquilibrium..opch p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 19 then COALESCE((SELECT top 1 p.SERIAL FROM SBOEquilibrium..orpc p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 20 then COALESCE((SELECT top 1 p.SERIAL FROM SBOEquilibrium..opdn p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 59 then COALESCE((SELECT top 1 p.SERIAL FROM SBOEquilibrium..oign p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 60 then COALESCE((SELECT top 1 p.SERIAL FROM SBOEquilibrium..oige p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			else 0
		end) AS FLOAT) NFNUM,

		o.BaseEntry CODSAP_Ref,
		o.basetype TIPODOC_Ref,	
		o.ItemCode CODITEM,
		m.ItemName NOMITEM,
		CAST(o.DocDate AS DATE) DTDOC,
		o.cardcode CODFORN,
		o.cardname NOMFORN,

		(case
			when o.DocType = 13 then COALESCE((SELECT top 1 u.Usage FROM SBOEquilibrium..inv1 p inner join SBOEquilibrium..oinv s on s.docentry = p.docentry left join SBOEquilibrium..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 14 then COALESCE((SELECT top 1 u.Usage FROM SBOEquilibrium..rin1 p inner join SBOEquilibrium..orin s on s.docentry = p.docentry left join SBOEquilibrium..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 17 then COALESCE((SELECT top 1 u.Usage FROM SBOEquilibrium..rdr1 p inner join SBOEquilibrium..ordr s on s.docentry = p.docentry left join SBOEquilibrium..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 18 then COALESCE((SELECT top 1 u.Usage FROM SBOEquilibrium..pch1 p inner join SBOEquilibrium..opch s on s.docentry = p.docentry left join SBOEquilibrium..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 19 then COALESCE((SELECT top 1 u.Usage FROM SBOEquilibrium..rpc1 p inner join SBOEquilibrium..orpc s on s.docentry = p.docentry left join SBOEquilibrium..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 20 then COALESCE((SELECT top 1 u.Usage FROM SBOEquilibrium..pdn1 p inner join SBOEquilibrium..opdn s on s.docentry = p.docentry left join SBOEquilibrium..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 59 then COALESCE((SELECT top 1 u.Usage FROM SBOEquilibrium..ign1 p inner join SBOEquilibrium..oign s on s.docentry = p.docentry left join SBOEquilibrium..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 60 then COALESCE((SELECT top 1 u.Usage FROM SBOEquilibrium..ige1 p inner join SBOEquilibrium..oige s on s.docentry = p.docentry left join SBOEquilibrium..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			else ''
		end) UTILIZACAO,

			(case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOEquilibrium..inv1 p inner join SBOEquilibrium..oinv s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 14 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOEquilibrium..rin1 p inner join SBOEquilibrium..orin s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 17 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOEquilibrium..rdr1 p inner join SBOEquilibrium..ordr s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 18 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOEquilibrium..pch1 p inner join SBOEquilibrium..opch s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 19 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOEquilibrium..rpc1 p inner join SBOEquilibrium..orpc s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 20 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOEquilibrium..pdn1 p inner join SBOEquilibrium..opdn s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 59 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOEquilibrium..ign1 p inner join SBOEquilibrium..oign s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 60 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOEquilibrium..ige1 p inner join SBOEquilibrium..oige s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			else ''
		end) CFOP,
	
		coalesce((SELECT top 1 case when g.groupname like '%ligada%' then 'S' else 'N' end FROM SBOEquilibrium..ocrd c left join SBOEquilibrium..ocrg g on g.groupcode = c.GroupCode where c.cardcode = o.cardcode),'S') COLIGADA,

		CAST(o.DocQty AS FLOAT) QTDE,

		CAST((case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.price FROM SBOEquilibrium..inv1 p inner join SBOEquilibrium..oinv s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 14 then COALESCE((SELECT top 1 p.price FROM SBOEquilibrium..rin1 p inner join SBOEquilibrium..orin s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 17 then COALESCE((SELECT top 1 p.price FROM SBOEquilibrium..rdr1 p inner join SBOEquilibrium..ordr s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 18 then COALESCE((SELECT top 1 p.price FROM SBOEquilibrium..pch1 p inner join SBOEquilibrium..opch s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 19 then COALESCE((SELECT top 1 p.price FROM SBOEquilibrium..rpc1 p inner join SBOEquilibrium..orpc s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 20 then COALESCE((SELECT top 1 p.price FROM SBOEquilibrium..pdn1 p inner join SBOEquilibrium..opdn s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 59 then COALESCE((SELECT top 1 p.price FROM SBOEquilibrium..ign1 p inner join SBOEquilibrium..oign s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 60 then COALESCE((SELECT top 1 p.price FROM SBOEquilibrium..ige1 p inner join SBOEquilibrium..oige s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			else 0
		end) AS FLOAT) VLRUNIT,

		CAST((case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.linetotal FROM SBOEquilibrium..inv1 p inner join SBOEquilibrium..oinv s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 14 then COALESCE((SELECT top 1 p.linetotal FROM SBOEquilibrium..rin1 p inner join SBOEquilibrium..orin s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 17 then COALESCE((SELECT top 1 p.linetotal FROM SBOEquilibrium..rdr1 p inner join SBOEquilibrium..ordr s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 18 then COALESCE((SELECT top 1 p.linetotal FROM SBOEquilibrium..pch1 p inner join SBOEquilibrium..opch s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 19 then COALESCE((SELECT top 1 p.linetotal FROM SBOEquilibrium..rpc1 p inner join SBOEquilibrium..orpc s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 20 then COALESCE((SELECT top 1 p.linetotal FROM SBOEquilibrium..pdn1 p inner join SBOEquilibrium..opdn s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 59 then COALESCE((SELECT top 1 p.linetotal FROM SBOEquilibrium..ign1 p inner join SBOEquilibrium..oign s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 60 then COALESCE((SELECT top 1 p.linetotal FROM SBOEquilibrium..ige1 p inner join SBOEquilibrium..oige s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			else 0
		end) AS FLOAT) VLRTOTAL  
	from 
		SBOEquilibrium..oitl o inner join 
		SBOEquilibrium..oitm m on m.itemcode = o.ItemCode
	where 
		(case
			when o.DocType = 13 then (SELECT top 1 canceled FROM SBOEquilibrium..OINV where docnum = o.docentry)
			when o.DocType = 14 then (SELECT top 1 canceled FROM SBOEquilibrium..ORIN where docnum = o.docentry)
			when o.DocType = 17 then (SELECT top 1 canceled FROM SBOEquilibrium..ORDR where docnum = o.docentry)
			when o.DocType = 18 then (SELECT top 1 canceled FROM SBOEquilibrium..OPCH where docnum = o.docentry)
			when o.DocType = 19 then (SELECT top 1 canceled FROM SBOEquilibrium..ORPC where docnum = o.docentry)
			when o.DocType = 20 then (SELECT top 1 canceled FROM SBOEquilibrium..OPDN where docnum = o.docentry)
			when o.DocType = 59 then (SELECT top 1 canceled FROM SBOEquilibrium..OIGN where docnum = o.docentry)
			when o.DocType = 60 then (SELECT top 1 canceled FROM SBOEquilibrium..OIGE where docnum = o.docentry)
			else ''
		end) = 'N' and
		--left(o.cardcode,1) not like 'C' and 
		--o.doctype not in (59,60,67,202,10000071) and 
		--o.basetype not in (22) and
		o.cardname not like '%em processo' and o.cardname not like 'Varia%mercadorias' and 
		year(o.docdate) = 2020 and 
		o.itemcode in ('0088872','0663633','0663635','0663636','0663653','0663654','0663655','0663656','0663657','0663658','0663659','0663660','0663666','0663667','0663668','0663669','0663670','0663671','0663672','0663673','0663674','0663675','0663679','0663682','0663688','0663690','0663695','0663699','0663701','0663705','0883737','0883738','3003316','3021649','3034782','3075892','3075935','3075959','3076080','3076288') and
		(case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.itemcode FROM SBOEquilibrium..inv1 p inner join SBOEquilibrium..oinv s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 14 then COALESCE((SELECT top 1 p.itemcode FROM SBOEquilibrium..rin1 p inner join SBOEquilibrium..orin s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 17 then COALESCE((SELECT top 1 p.itemcode FROM SBOEquilibrium..rdr1 p inner join SBOEquilibrium..ordr s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 18 then COALESCE((SELECT top 1 p.itemcode FROM SBOEquilibrium..pch1 p inner join SBOEquilibrium..opch s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 19 then COALESCE((SELECT top 1 p.itemcode FROM SBOEquilibrium..rpc1 p inner join SBOEquilibrium..orpc s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 20 then COALESCE((SELECT top 1 p.itemcode FROM SBOEquilibrium..pdn1 p inner join SBOEquilibrium..opdn s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 59 then COALESCE((SELECT top 1 p.itemcode FROM SBOEquilibrium..ign1 p inner join SBOEquilibrium..oign s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 60 then COALESCE((SELECT top 1 p.itemcode FROM SBOEquilibrium..ige1 p inner join SBOEquilibrium..oige s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			else ''
		end) = o.itemcode


insert into [Mbs].[dbo].[hidra001]
	select 
		'MW' AS EMPRESA,
		o.docentry CODSAP,
		o.DocType TIPODOC,
	
		CAST((case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.SERIAL FROM SBOMW..oinv p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 14 then COALESCE((SELECT top 1 p.SERIAL FROM SBOMW..orin p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 17 then COALESCE((SELECT top 1 p.SERIAL FROM SBOMW..ordr p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 18 then COALESCE((SELECT top 1 p.SERIAL FROM SBOMW..opch p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 19 then COALESCE((SELECT top 1 p.SERIAL FROM SBOMW..orpc p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 20 then COALESCE((SELECT top 1 p.SERIAL FROM SBOMW..opdn p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 59 then COALESCE((SELECT top 1 p.SERIAL FROM SBOMW..oign p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 60 then COALESCE((SELECT top 1 p.SERIAL FROM SBOMW..oige p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			else 0
		end) AS FLOAT) NFNUM,

		o.BaseEntry CODSAP_Ref,
		o.basetype TIPODOC_Ref,	
		o.ItemCode CODITEM,
		m.ItemName NOMITEM,
		CAST(o.DocDate AS DATE) DTDOC,
		o.cardcode CODFORN,
		o.cardname NOMFORN,

		(case
			when o.DocType = 13 then COALESCE((SELECT top 1 u.Usage FROM SBOMW..inv1 p inner join SBOMW..oinv s on s.docentry = p.docentry left join SBOMW..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 14 then COALESCE((SELECT top 1 u.Usage FROM SBOMW..rin1 p inner join SBOMW..orin s on s.docentry = p.docentry left join SBOMW..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 17 then COALESCE((SELECT top 1 u.Usage FROM SBOMW..rdr1 p inner join SBOMW..ordr s on s.docentry = p.docentry left join SBOMW..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 18 then COALESCE((SELECT top 1 u.Usage FROM SBOMW..pch1 p inner join SBOMW..opch s on s.docentry = p.docentry left join SBOMW..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 19 then COALESCE((SELECT top 1 u.Usage FROM SBOMW..rpc1 p inner join SBOMW..orpc s on s.docentry = p.docentry left join SBOMW..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 20 then COALESCE((SELECT top 1 u.Usage FROM SBOMW..pdn1 p inner join SBOMW..opdn s on s.docentry = p.docentry left join SBOMW..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 59 then COALESCE((SELECT top 1 u.Usage FROM SBOMW..ign1 p inner join SBOMW..oign s on s.docentry = p.docentry left join SBOMW..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 60 then COALESCE((SELECT top 1 u.Usage FROM SBOMW..ige1 p inner join SBOMW..oige s on s.docentry = p.docentry left join SBOMW..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			else ''
		end) UTILIZACAO,

			(case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOMW..inv1 p inner join SBOMW..oinv s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 14 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOMW..rin1 p inner join SBOMW..orin s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 17 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOMW..rdr1 p inner join SBOMW..ordr s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 18 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOMW..pch1 p inner join SBOMW..opch s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 19 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOMW..rpc1 p inner join SBOMW..orpc s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 20 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOMW..pdn1 p inner join SBOMW..opdn s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 59 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOMW..ign1 p inner join SBOMW..oign s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 60 then COALESCE((SELECT top 1 p.CFOPCode FROM SBOMW..ige1 p inner join SBOMW..oige s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			else ''
		end) CFOP,
	
		coalesce((SELECT top 1 case when g.groupname like '%ligada%' then 'S' else 'N' end FROM SBOMW..ocrd c left join SBOMW..ocrg g on g.groupcode = c.GroupCode where c.cardcode = o.cardcode),'S') COLIGADA,

		CAST(o.DocQty AS FLOAT) QTDE,

		CAST((case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.price FROM SBOMW..inv1 p inner join SBOMW..oinv s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 14 then COALESCE((SELECT top 1 p.price FROM SBOMW..rin1 p inner join SBOMW..orin s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 17 then COALESCE((SELECT top 1 p.price FROM SBOMW..rdr1 p inner join SBOMW..ordr s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 18 then COALESCE((SELECT top 1 p.price FROM SBOMW..pch1 p inner join SBOMW..opch s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 19 then COALESCE((SELECT top 1 p.price FROM SBOMW..rpc1 p inner join SBOMW..orpc s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 20 then COALESCE((SELECT top 1 p.price FROM SBOMW..pdn1 p inner join SBOMW..opdn s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 59 then COALESCE((SELECT top 1 p.price FROM SBOMW..ign1 p inner join SBOMW..oign s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 60 then COALESCE((SELECT top 1 p.price FROM SBOMW..ige1 p inner join SBOMW..oige s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			else 0
		end) AS FLOAT) VLRUNIT,

		CAST((case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.linetotal FROM SBOMW..inv1 p inner join SBOMW..oinv s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 14 then COALESCE((SELECT top 1 p.linetotal FROM SBOMW..rin1 p inner join SBOMW..orin s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 17 then COALESCE((SELECT top 1 p.linetotal FROM SBOMW..rdr1 p inner join SBOMW..ordr s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 18 then COALESCE((SELECT top 1 p.linetotal FROM SBOMW..pch1 p inner join SBOMW..opch s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 19 then COALESCE((SELECT top 1 p.linetotal FROM SBOMW..rpc1 p inner join SBOMW..orpc s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 20 then COALESCE((SELECT top 1 p.linetotal FROM SBOMW..pdn1 p inner join SBOMW..opdn s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 59 then COALESCE((SELECT top 1 p.linetotal FROM SBOMW..ign1 p inner join SBOMW..oign s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 60 then COALESCE((SELECT top 1 p.linetotal FROM SBOMW..ige1 p inner join SBOMW..oige s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			else 0
		end) AS FLOAT) VLRTOTAL  
	from 
		SBOMW..oitl o inner join 
		SBOMW..oitm m on m.itemcode = o.ItemCode
	where 
		(case
			when o.DocType = 13 then (SELECT top 1 canceled FROM SBOMW..OINV where docnum = o.docentry)
			when o.DocType = 14 then (SELECT top 1 canceled FROM SBOMW..ORIN where docnum = o.docentry)
			when o.DocType = 17 then (SELECT top 1 canceled FROM SBOMW..ORDR where docnum = o.docentry)
			when o.DocType = 18 then (SELECT top 1 canceled FROM SBOMW..OPCH where docnum = o.docentry)
			when o.DocType = 19 then (SELECT top 1 canceled FROM SBOMW..ORPC where docnum = o.docentry)
			when o.DocType = 20 then (SELECT top 1 canceled FROM SBOMW..OPDN where docnum = o.docentry)
			when o.DocType = 59 then (SELECT top 1 canceled FROM SBOMW..OIGN where docnum = o.docentry)
			when o.DocType = 60 then (SELECT top 1 canceled FROM SBOMW..OIGE where docnum = o.docentry)
			else ''
		end) = 'N' and
		--left(o.cardcode,1) not like 'C' and 
		--o.doctype not in (59,60,67,202,10000071) and 
--		o.basetype not in (22) and
		o.cardname not like '%em processo' and o.cardname not like 'Varia%mercadorias' and 
		year(o.docdate) = 2020 and o.itemcode in ('0088872','0663633','0663635','0663636','0663653','0663654','0663655','0663656','0663657','0663658','0663659','0663660','0663666','0663667','0663668','0663669','0663670','0663671','0663672','0663673','0663674','0663675','0663679','0663682','0663688','0663690','0663695','0663699','0663701','0663705','0883737','0883738','3003316','3021649','3034782','3075892','3075935','3075959','3076080','3076288') and
		(case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.itemcode FROM SBOMW..inv1 p inner join SBOMW..oinv s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 14 then COALESCE((SELECT top 1 p.itemcode FROM SBOMW..rin1 p inner join SBOMW..orin s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 17 then COALESCE((SELECT top 1 p.itemcode FROM SBOMW..rdr1 p inner join SBOMW..ordr s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 18 then COALESCE((SELECT top 1 p.itemcode FROM SBOMW..pch1 p inner join SBOMW..opch s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 19 then COALESCE((SELECT top 1 p.itemcode FROM SBOMW..rpc1 p inner join SBOMW..orpc s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 20 then COALESCE((SELECT top 1 p.itemcode FROM SBOMW..pdn1 p inner join SBOMW..opdn s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 59 then COALESCE((SELECT top 1 p.itemcode FROM SBOMW..ign1 p inner join SBOMW..oign s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 60 then COALESCE((SELECT top 1 p.itemcode FROM SBOMW..ige1 p inner join SBOMW..oige s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			else ''
		end) = o.itemcode


		insert into [Mbs].[dbo].[hidra001]
	select 
		'NH' AS EMPRESA,
		o.docentry CODSAP,
		o.DocType TIPODOC,
	
		CAST((case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.SERIAL FROM SBONUTGYNMATRIZ..oinv p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 14 then COALESCE((SELECT top 1 p.SERIAL FROM SBONUTGYNMATRIZ..orin p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 17 then COALESCE((SELECT top 1 p.SERIAL FROM SBONUTGYNMATRIZ..ordr p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 18 then COALESCE((SELECT top 1 p.SERIAL FROM SBONUTGYNMATRIZ..opch p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 19 then COALESCE((SELECT top 1 p.SERIAL FROM SBONUTGYNMATRIZ..orpc p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 20 then COALESCE((SELECT top 1 p.SERIAL FROM SBONUTGYNMATRIZ..opdn p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 59 then COALESCE((SELECT top 1 p.SERIAL FROM SBONUTGYNMATRIZ..oign p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			when o.DocType = 60 then COALESCE((SELECT top 1 p.SERIAL FROM SBONUTGYNMATRIZ..oige p where p.cardcode = o.cardcode and p.docnum = o.docentry),0)
			else 0
		end) AS FLOAT) NFNUM,

		o.BaseEntry CODSAP_Ref,
		o.basetype TIPODOC_Ref,	
		o.ItemCode CODITEM,
		m.ItemName NOMITEM,
		CAST(o.DocDate AS DATE) DTDOC,
		o.cardcode CODFORN,
		o.cardname NOMFORN,

		(case
			when o.DocType = 13 then COALESCE((SELECT top 1 u.Usage FROM SBONUTGYNMATRIZ..inv1 p inner join SBONUTGYNMATRIZ..oinv s on s.docentry = p.docentry left join SBONUTGYNMATRIZ..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 14 then COALESCE((SELECT top 1 u.Usage FROM SBONUTGYNMATRIZ..rin1 p inner join SBONUTGYNMATRIZ..orin s on s.docentry = p.docentry left join SBONUTGYNMATRIZ..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 17 then COALESCE((SELECT top 1 u.Usage FROM SBONUTGYNMATRIZ..rdr1 p inner join SBONUTGYNMATRIZ..ordr s on s.docentry = p.docentry left join SBONUTGYNMATRIZ..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 18 then COALESCE((SELECT top 1 u.Usage FROM SBONUTGYNMATRIZ..pch1 p inner join SBONUTGYNMATRIZ..opch s on s.docentry = p.docentry left join SBONUTGYNMATRIZ..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 19 then COALESCE((SELECT top 1 u.Usage FROM SBONUTGYNMATRIZ..rpc1 p inner join SBONUTGYNMATRIZ..orpc s on s.docentry = p.docentry left join SBONUTGYNMATRIZ..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 20 then COALESCE((SELECT top 1 u.Usage FROM SBONUTGYNMATRIZ..pdn1 p inner join SBONUTGYNMATRIZ..opdn s on s.docentry = p.docentry left join SBONUTGYNMATRIZ..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 59 then COALESCE((SELECT top 1 u.Usage FROM SBONUTGYNMATRIZ..ign1 p inner join SBONUTGYNMATRIZ..oign s on s.docentry = p.docentry left join SBONUTGYNMATRIZ..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 60 then COALESCE((SELECT top 1 u.Usage FROM SBONUTGYNMATRIZ..ige1 p inner join SBONUTGYNMATRIZ..oige s on s.docentry = p.docentry left join SBONUTGYNMATRIZ..ousg u on u.id = p.Usage where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			else ''
		end) UTILIZACAO,

			(case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.CFOPCode FROM SBONUTGYNMATRIZ..inv1 p inner join SBONUTGYNMATRIZ..oinv s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 14 then COALESCE((SELECT top 1 p.CFOPCode FROM SBONUTGYNMATRIZ..rin1 p inner join SBONUTGYNMATRIZ..orin s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 17 then COALESCE((SELECT top 1 p.CFOPCode FROM SBONUTGYNMATRIZ..rdr1 p inner join SBONUTGYNMATRIZ..ordr s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 18 then COALESCE((SELECT top 1 p.CFOPCode FROM SBONUTGYNMATRIZ..pch1 p inner join SBONUTGYNMATRIZ..opch s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 19 then COALESCE((SELECT top 1 p.CFOPCode FROM SBONUTGYNMATRIZ..rpc1 p inner join SBONUTGYNMATRIZ..orpc s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 20 then COALESCE((SELECT top 1 p.CFOPCode FROM SBONUTGYNMATRIZ..pdn1 p inner join SBONUTGYNMATRIZ..opdn s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 59 then COALESCE((SELECT top 1 p.CFOPCode FROM SBONUTGYNMATRIZ..ign1 p inner join SBONUTGYNMATRIZ..oign s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 60 then COALESCE((SELECT top 1 p.CFOPCode FROM SBONUTGYNMATRIZ..ige1 p inner join SBONUTGYNMATRIZ..oige s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			else ''
		end) CFOP,
	
		coalesce((SELECT top 1 case when g.groupname like '%ligada%' then 'S' else 'N' end FROM SBONUTGYNMATRIZ..ocrd c left join SBONUTGYNMATRIZ..ocrg g on g.groupcode = c.GroupCode where c.cardcode = o.cardcode),'S') COLIGADA,

		CAST(o.DocQty AS FLOAT) QTDE,

		CAST((case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.price FROM SBONUTGYNMATRIZ..inv1 p inner join SBONUTGYNMATRIZ..oinv s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 14 then COALESCE((SELECT top 1 p.price FROM SBONUTGYNMATRIZ..rin1 p inner join SBONUTGYNMATRIZ..orin s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 17 then COALESCE((SELECT top 1 p.price FROM SBONUTGYNMATRIZ..rdr1 p inner join SBONUTGYNMATRIZ..ordr s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 18 then COALESCE((SELECT top 1 p.price FROM SBONUTGYNMATRIZ..pch1 p inner join SBONUTGYNMATRIZ..opch s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 19 then COALESCE((SELECT top 1 p.price FROM SBONUTGYNMATRIZ..rpc1 p inner join SBONUTGYNMATRIZ..orpc s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 20 then COALESCE((SELECT top 1 p.price FROM SBONUTGYNMATRIZ..pdn1 p inner join SBONUTGYNMATRIZ..opdn s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 59 then COALESCE((SELECT top 1 p.price FROM SBONUTGYNMATRIZ..ign1 p inner join SBONUTGYNMATRIZ..oign s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 60 then COALESCE((SELECT top 1 p.price FROM SBONUTGYNMATRIZ..ige1 p inner join SBONUTGYNMATRIZ..oige s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			else 0
		end) AS FLOAT) VLRUNIT,

		CAST((case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.linetotal FROM SBONUTGYNMATRIZ..inv1 p inner join SBONUTGYNMATRIZ..oinv s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 14 then COALESCE((SELECT top 1 p.linetotal FROM SBONUTGYNMATRIZ..rin1 p inner join SBONUTGYNMATRIZ..orin s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 17 then COALESCE((SELECT top 1 p.linetotal FROM SBONUTGYNMATRIZ..rdr1 p inner join SBONUTGYNMATRIZ..ordr s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 18 then COALESCE((SELECT top 1 p.linetotal FROM SBONUTGYNMATRIZ..pch1 p inner join SBONUTGYNMATRIZ..opch s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 19 then COALESCE((SELECT top 1 p.linetotal FROM SBONUTGYNMATRIZ..rpc1 p inner join SBONUTGYNMATRIZ..orpc s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 20 then COALESCE((SELECT top 1 p.linetotal FROM SBONUTGYNMATRIZ..pdn1 p inner join SBONUTGYNMATRIZ..opdn s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 59 then COALESCE((SELECT top 1 p.linetotal FROM SBONUTGYNMATRIZ..ign1 p inner join SBONUTGYNMATRIZ..oign s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			when o.DocType = 60 then COALESCE((SELECT top 1 p.linetotal FROM SBONUTGYNMATRIZ..ige1 p inner join SBONUTGYNMATRIZ..oige s on s.docentry = p.docentry where p.BaseCard = o.cardcode and s.docnum = o.docentry),0)
			else 0
		end) AS FLOAT) VLRTOTAL  
	from 
		SBONUTGYNMATRIZ..oitl o inner join 
		SBONUTGYNMATRIZ..oitm m on m.itemcode = o.ItemCode
	where 
		(case
			when o.DocType = 13 then (SELECT top 1 canceled FROM SBONUTGYNMATRIZ..OINV where docnum = o.docentry)
			when o.DocType = 14 then (SELECT top 1 canceled FROM SBONUTGYNMATRIZ..ORIN where docnum = o.docentry)
			when o.DocType = 17 then (SELECT top 1 canceled FROM SBONUTGYNMATRIZ..ORDR where docnum = o.docentry)
			when o.DocType = 18 then (SELECT top 1 canceled FROM SBONUTGYNMATRIZ..OPCH where docnum = o.docentry)
			when o.DocType = 19 then (SELECT top 1 canceled FROM SBONUTGYNMATRIZ..ORPC where docnum = o.docentry)
			when o.DocType = 20 then (SELECT top 1 canceled FROM SBONUTGYNMATRIZ..OPDN where docnum = o.docentry)
			when o.DocType = 59 then (SELECT top 1 canceled FROM SBONUTGYNMATRIZ..OIGN where docnum = o.docentry)
			when o.DocType = 60 then (SELECT top 1 canceled FROM SBONUTGYNMATRIZ..OIGE where docnum = o.docentry)
			else ''
		end) = 'N' and
		--left(o.cardcode,1) not like 'C' and 
		--o.doctype not in (59,60,67,202,10000071) and 
		--o.basetype not in (22) and
		o.cardname not like '%em processo' and o.cardname not like 'Varia%mercadorias' and 
		year(o.docdate) = 2020 and o.itemcode in ('0088872','0663633','0663635','0663636','0663653','0663654','0663655','0663656','0663657','0663658','0663659','0663660','0663666','0663667','0663668','0663669','0663670','0663671','0663672','0663673','0663674','0663675','0663679','0663682','0663688','0663690','0663695','0663699','0663701','0663705','0883737','0883738','3003316','3021649','3034782','3075892','3075935','3075959','3076080','3076288') and
		(case
			when o.DocType = 13 then COALESCE((SELECT top 1 p.itemcode FROM SBONUTGYNMATRIZ..inv1 p inner join SBONUTGYNMATRIZ..oinv s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 14 then COALESCE((SELECT top 1 p.itemcode FROM SBONUTGYNMATRIZ..rin1 p inner join SBONUTGYNMATRIZ..orin s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 17 then COALESCE((SELECT top 1 p.itemcode FROM SBONUTGYNMATRIZ..rdr1 p inner join SBONUTGYNMATRIZ..ordr s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 18 then COALESCE((SELECT top 1 p.itemcode FROM SBONUTGYNMATRIZ..pch1 p inner join SBONUTGYNMATRIZ..opch s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 19 then COALESCE((SELECT top 1 p.itemcode FROM SBONUTGYNMATRIZ..rpc1 p inner join SBONUTGYNMATRIZ..orpc s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 20 then COALESCE((SELECT top 1 p.itemcode FROM SBONUTGYNMATRIZ..pdn1 p inner join SBONUTGYNMATRIZ..opdn s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 59 then COALESCE((SELECT top 1 p.itemcode FROM SBONUTGYNMATRIZ..ign1 p inner join SBONUTGYNMATRIZ..oign s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			when o.DocType = 60 then COALESCE((SELECT top 1 p.itemcode FROM SBONUTGYNMATRIZ..ige1 p inner join SBONUTGYNMATRIZ..oige s on s.docentry = p.docentry and o.docline = p.linenum where p.BaseCard = o.cardcode and s.docnum = o.docentry),'')
			else ''
		end) = o.itemcode

insert into [Mbs].[dbo].[hidra002]
	SELECT 
			[EMPRESA]
			,case 
				when codforn like 'F918011' then 'sboNutGynMatriz'
				when codforn like 'F918204' then 'sboMW'
				when codforn in ('F813949','F867317','F918391','F918326') then 'sboEquilibrium'
				else codforn
			end ORIGEM
		  ,[CODSAP]
		  ,[TIPODOC]
		  ,[NFNUM]
		  ,[CODSAP_Ref]
		  ,[TIPODOC_Ref]
			,CASE
				WHEN EMPRESA = 'EQ' THEN
					case
						when tipodoc in (19,20) and tipodoc_ref = 18 then (select top 1 SERIAL from sboEquilibrium..opch where docentry = hidra.CODSAP_Ref)
						else 0 end
				WHEN EMPRESA = 'MW' THEN
					case
						when tipodoc in (19,20) and tipodoc_ref = 18 then (select top 1 SERIAL from SBOMW..opch where docentry = hidra.CODSAP_Ref)
						else 0 end
				ELSE
					case
						when tipodoc in (19,20) and tipodoc_ref = 18 then (select top 1 SERIAL from SBONutGynMatriz..opch where docentry = hidra.CODSAP_Ref)
						else 0 end
				END NFNUM_REF
		  ,[CODITEM]
		  ,[NOMITEM]
		  ,[DTDOC]
			,CASE
				WHEN EMPRESA = 'EQ' THEN
					case
						when tipodoc in (19,20) and tipodoc_ref = 18 then (select top 1 CAST(docdate AS DATE) from sboEquilibrium..opch where docentry = hidra.CODSAP_Ref)
						else '' end
				WHEN EMPRESA = 'MW' THEN
					case
						when tipodoc in (19,20) and tipodoc_ref = 18 then (select top 1 CAST(docdate AS DATE) from SBOMW..opch where docentry = hidra.CODSAP_Ref)
						else '' end
				ELSE
					case
						when tipodoc in (19,20) and tipodoc_ref = 18 then (select top 1 CAST(docdate AS DATE) from SBONutGynMatriz..opch where docentry = hidra.CODSAP_Ref)
						else '' end
				END DTDOC_REF

		  ,[CODFORN]
		  ,[NOMFORN]
		  ,[UTILIZACAO]
		  ,[CFOP]
		  ,[COLIGADA]
		  ,[QTDE]
		  ,[VLRUNIT]
		  ,[VLRTOTAL]
			,CASE
				WHEN EMPRESA = 'EQ' THEN
					case
						when tipodoc in (19,20) and tipodoc_ref = 18 then (select top 1 CAST(MAX1099 AS FLOAT) from sboEquilibrium..opch where docentry = hidra.CODSAP_Ref)
						else 0 end
				WHEN EMPRESA = 'MW' THEN
					case
						when tipodoc in (19,20) and tipodoc_ref = 18 then (select top 1 CAST(MAX1099 AS FLOAT) from SBOMW..opch where docentry = hidra.CODSAP_Ref)
						else 0 end
				ELSE
					case
						when tipodoc in (19,20) and tipodoc_ref = 18 then (select top 1 CAST(MAX1099 AS FLOAT) from SBONutGynMatriz..opch where docentry = hidra.CODSAP_Ref)
						else 0 end
				END VLRTOTDOC_REF
	  FROM [Mbs].[dbo].[hidra001] hidra


SELECT 
	[EMPRESA]
	,[ORIGEM]
	,[CODSAP]
	,[TIPODOC]
	,[NFNUM]
	,[CODSAP_Ref]
	,[TIPODOC_Ref]
	,[NFNUM_Ref]
	,[CODITEM]
	,[NOMITEM]
	,[DTDOC]
	,[DTDOC_Ref]
	,[CODFORN]
	,[NOMFORN]
	,[UTILIZACAO]
	,[CFOP]
	,[COLIGADA]
	,SUM([QTDE]) [QTDE]
	,AVG([VLRUNIT]) [VLRUNIT]
	,AVG([VLRTOTAL]) [VLRTOTAL]
	,AVG([VLRTOTDOC_Ref]) [VLRTOTDOC_Ref]
FROM [Mbs].[dbo].[hidra002]
GROUP BY
	[EMPRESA]
	,[ORIGEM]
	,[CODSAP]
	,[TIPODOC]
	,[NFNUM]
	,[CODSAP_Ref]
	,[TIPODOC_Ref]
	,[NFNUM_Ref]
	,[CODITEM]
	,[NOMITEM]
	,[DTDOC]
	,[DTDOC_Ref]
	,[CODFORN]
	,[NOMFORN]
	,[UTILIZACAO]
	,[CFOP]
	,[COLIGADA]


--, serial

--select top 10 * from sboEquilibrium..opch where docentry = 28371

----(SELECT u.Usage, p.BaseCard, c.cardname,g.groupname,linetotal,price, CFOPCode FROM SBOEquilibrium..pdn1 p inner join SBOEquilibrium..ocrd c on c.cardcode = p.BaseCard left join ousg u on u.id = p.Usage left join ocrg g on g.groupcode = c.GroupCode where  g.groupname not like '%ligada%')


----select o.serial,* from opch o inner join pch1 p on p.docentry = o.docentry where o.docentry = 49991

----select i.itemcode, o.serial,o.*, i.* from SBONutGynMatriz..oinv o inner join SBONutGynMatriz..inv1 i on i.docentry = o.docentry where o.serial = 9317


----select o.ItemCode PAI, o.prodname, i.itemcode COMPONENTE, i.ItemName NOMECOMP,* from SBONutGynMatriz..owor o inner join SBONutGynMatriz..wor1 i on i.docentry = o.docentry where (o.itemcode = '0883737' or o.itemcode = '0883738')



----select P.PRICE,p.itemcode,p.Dscription,o.serial,* from OPDN o inner join pdn1 p on p.docentry = o.docentry where o.docentry = 49990

----select i.price, i.StockPrice,i.itemcode, o.serial,o.*, i.* from SBONutGynMatriz..oinv o inner join SBONutGynMatriz..inv1 i on i.docentry = o.docentry where o.serial = 9952


----select * from SBONutGynMatriz..OPCH o inner join SBONutGynMatriz..PCH1 i on i.docentry = o.docentry where I.ITEMCODE = '0663675'


----select * from SBONutGynMatriz..oibt where itemcode = '0663633'--in ('0088872','0663633','0663635','0663636','0663653','0663654','0663655','0663656','0663657','0663658','0663659','0663660','0663666','0663667','0663668','0663669','0663670','0663671','0663673','0663674','0663675','0663679','0663682','0663688','0663690','0663695','0663701','0663705','0883737','0883738','3003316','3021649','3034782','3075892','3075935','3075959','3076080','3076288')


----select o.ItemCode PAI, o.prodname, i.itemcode COMPONENTE, i.ItemName NOMECOMP,* from SBONutGynMatriz..owor o inner join SBONutGynMatriz..wor1 i on i.docentry = o.docentry where (o.itemcode = '0663675')


----select O.CANCELED, I.PRICE, * from SBONutGynMatriz..OPCH o inner join SBONutGynMatriz..PCH1 i on i.docentry = o.docentry where I.DOCENTRY = 22951
