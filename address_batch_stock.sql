DROP TABLE IF EXISTS MBS.[dbo].[RPA015]
DROP TABLE IF EXISTS MBS.[dbo].[RPA015_final]
DROP TABLE IF EXISTS #base

--CRIA A TABELA PARA RECEBER O INVENTARIO DO DIA DE TODEMPRESAS
	CREATE TABLE MBS.[dbo].[RPA015](
		[BASE] [nvarchar](50) NULL,
		[DTPOSICAO] [date] NULL,
		[CODITEM] [nvarchar](50) NULL,
		[ITEMDESC] [nvarchar](100) NULL,
		[DEPOSITO] [nvarchar](111) NULL,
		[OPERACAO] [nvarchar](50) NULL,
		[COD_ENDER] [nvarchar](228) NULL,
		[DESC_ENDER] [nvarchar](50) NULL,
		[LOTE] [nvarchar](50) NULL,
		[QTD] [float] NULL,
		[CUSTOMEDIO] [float] NULL,
		[VRLESTOQUE] [float] NULL,
		[OBSERVACAO] [nvarchar](max) NULL
	) ON [PRIMARY]

CREATE TABLE MBS.[dbo].[RPA015_final](
	[BASE] [nvarchar](50) NULL,
	[DTPOSICAO] [date] NULL,
	[CODITEM] [nvarchar](50) NULL,
	[ITEMNAME] [nvarchar](100) NULL,
	[DEPOSITO] [nvarchar](111) NULL,
	[OPERACAO] [nvarchar](50) NULL,
	[COD_ENDER] [nvarchar](228) NULL,
	[DESC_ENDER] [nvarchar](50) NULL,
	[LOTE] [nvarchar](50) NULL,
	[QTD] [float] NULL,
	[customedio] [float] NULL,
	[VRLESTOQUE] [float] NULL,
	[OBSERVACAO] [nvarchar](max) NULL
) ON [PRIMARY]

--CRIA TABELA COM BANCOS DE DADOS QUE FARAO PARTE DA CONSULTA
	CREATE TABLE #base([BASEID] int NOT NULL,[EMPRESA] nvarchar(max) NULL)
		INSERT INTO #base VALUES (1,'SBOMW');
		INSERT INTO #base VALUES (2,'SBOA7');
		INSERT INTO #base VALUES (3,'SBODL');
		INSERT INTO #base VALUES (4,'SBOEquilibrium');
		INSERT INTO #base VALUES (5,'SBOGDSMARCAS');
		INSERT INTO #base VALUES (6,'SboInnovaLab');
		INSERT INTO #base VALUES (7,'SBONutGynMatriz');
		INSERT INTO #base VALUES (8,'SBONutriexInd');
		INSERT INTO #base VALUES (9,'SboOralls');
		INSERT INTO #base VALUES (10,'SBOVidafarma');
		INSERT INTO #base VALUES (11,'SBOInnovaBR');

--DECLARA AS VARIAVEIS PARA FILTROS E APELIDOS DE TABELAS
	DECLARE @DATAREF DATETIME = '2020-09-30'
	DECLARE @ITEMCODE NVARCHAR(MAX) = '0064311'
	DECLARE @loop int = (SELECT COUNT(baseid) FROM #base);
	DECLARE @i int = 0; 
	DECLARE @empresa nvarchar(MAX);
	DECLARE @pathOILM nvarchar(MAX);
	DECLARE @pathILM1 nvarchar(MAX);
	DECLARE @pathOBTL nvarchar(MAX);
	DECLARE @pathOBTN nvarchar(MAX);
	DECLARE @pathOBIN nvarchar(MAX);
	DECLARE @pathOITM nvarchar(MAX);
	DECLARE @pathOWHS nvarchar(MAX);

--EXECUTA A CONSULTA EM LOOP VARRENDO TODAS AS EMPRESAS LISTADAS NO INICIO DO SCRIPT
	while @i < @loop
		begin
			set @i = @i + 1; --inicio do laco
			set @empresa = (select empresa from #base where baseid = @i)
			set @pathOILM = CONCAT(N'CREATE SYNONYM tpathOILM FOR ',@empresa,N'.DBO.OILM');
			set @pathILM1 = CONCAT(N'CREATE SYNONYM tpathILM1 FOR ',@empresa,N'.DBO.ILM1');
			set @pathOBTL = CONCAT(N'CREATE SYNONYM tpathOBTL FOR ',@empresa,N'.DBO.OBTL');
			set @pathOBTN = CONCAT(N'CREATE SYNONYM tpathOBTN FOR ',@empresa,N'.DBO.OBTN');
			set @pathOBIN = CONCAT(N'CREATE SYNONYM tpathOBIN FOR ',@empresa,N'.DBO.OBIN');
			set @pathOITM = CONCAT(N'CREATE SYNONYM tpathOITM FOR ',@empresa,N'.DBO.OITM');
			set @pathOWHS = CONCAT(N'CREATE SYNONYM tpathOWHS FOR ',@empresa,N'.DBO.OWHS');
			IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOILM') > 0 BEGIN DROP SYNONYM tpathOILM; EXEC(@pathOILM); END ELSE BEGIN exec(@pathOILM); END
			IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathILM1') > 0 BEGIN DROP SYNONYM tpathILM1; EXEC(@pathILM1); END ELSE BEGIN exec(@pathILM1); END
			IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOBTL') > 0 BEGIN DROP SYNONYM tpathOBTL; EXEC(@pathOBTL); END ELSE BEGIN exec(@pathOBTL); END
			IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOBTN') > 0 BEGIN DROP SYNONYM tpathOBTN; EXEC(@pathOBTN); END ELSE BEGIN exec(@pathOBTN); END
			IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOBIN') > 0 BEGIN DROP SYNONYM tpathOBIN; EXEC(@pathOBIN); END ELSE BEGIN exec(@pathOBIN); END
			IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOITM') > 0 BEGIN DROP SYNONYM tpathOITM; EXEC(@pathOITM); END ELSE BEGIN exec(@pathOITM); END
			IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOWHS') > 0 BEGIN DROP SYNONYM tpathOWHS; EXEC(@pathOWHS); END ELSE BEGIN exec(@pathOWHS); END

	INSERT INTO MBS..[RPA015]
		SELECT @empresa BASE,
			CONVERT(DATE,@DATAREF) DTPOSICAO,
			 T2.ItemCode CODITEM
			,''--(SELECT ITEMNAME FROM tpathOITM WHERE ITEMCODE = T2.ITEMCODE) ITEMDESC
			,t6.whscode--CONCAT(t6.whscode,' - ',(SELECT WHSNAME FROM tpathOWHS WHERE WHSCODE = t6.whscode)) DEPOSITO
			,CASE
					WHEN t2.comment LIKE '%CANCEL%' THEN 'CANCELADO'
					WHEN T2.TransType = 13 THEN 'FATURAMENTO'
					WHEN T2.TransType IN (14,19) OR T6.BinCode LIKE '%DEV%' THEN 'DEVOLUCAO'
					WHEN T2.TransType = 15 THEN 'ENTREGA'
					WHEN T2.TransType IN (16,21) THEN 'RETORNO'
					WHEN T2.TransType = 18 THEN 'COMPRA'
					WHEN T2.TransType = 20 THEN 'RECEB.MERC.'
					WHEN T2.TransType = 59 THEN 'PROD.ACABADO'
					WHEN T2.TransType = 60 THEN 'SAIDA_INSUMO'
					WHEN T2.TransType = 67 THEN 'TRANSFERENCIA'
					WHEN T2.TransType = 10000071 THEN 'INVENTARIO'
					ELSE 'DIVERSOS'
			 END OPERACAO
			,T6.BinCode COD_ENDER
			,COALESCE(t6.descr,'') DESC_ENDER
			,T5.DistNumber LOTE
			,convert(float,SUM(IIF(T2.ActionType IN('1','19'),T4.Quantity,IIF(T2.ActionType IN('2','20'),(T4.Quantity *-1),0)))) QTD
			,0--ISNULL((select CUSTOMEDIO from mbs..inventario WHERE CONVERT(DATE,dtsnapshot) = @DATAREF AND PRODCOD = T2.ItemCode AND DEPOSITO = CONCAT(t6.whscode,' - ',(SELECT WHSNAME FROM tpathOWHS WHERE WHSCODE = t6.whscode))),0) CUSTOMEDIO
			,0--ISNULL((select CUSTOMEDIO from mbs..inventario WHERE CONVERT(DATE,dtsnapshot) = @DATAREF AND PRODCOD = T2.ItemCode AND DEPOSITO = CONCAT(t6.whscode,' - ',(SELECT WHSNAME FROM tpathOWHS WHERE WHSCODE = t6.whscode))),0)*SUM(IIF(T2.ActionType IN('1','19'),T4.Quantity,IIF(T2.ActionType IN('2','20'),(T4.Quantity *-1),0))) VRLESTOQUE
			,ISNULL(t2.comment,'') OBSERVACAO 
		FROM 
			tpathOILM T2 INNER JOIN 
			tpathILM1 T3 ON (T2.[MessageID] = T3.[MessageID]) INNER JOIN -- Tabela Numero de Serie e Lotes de Log Inventario
			tpathOBTL T4 ON (T2.MessageID = T4.MessageID AND T3.[MdAbsEntry] = T4.[SnBMDAbs]) INNER JOIN-- Tabela Log de enderecos
			tpathOBTN T5 ON (T3.[MdAbsEntry] = T5.[AbsEntry])INNER JOIN-- Tabela Lotes
			tpathOBIN T6 ON (T4.BinAbs = T6.AbsEntry) INNER JOIN-- Tabela enderecos
			tpathOITM T7 ON (T2.ItemCode = T7.ItemCode)-- Tabela itens
		WHERE 
			(1=1) AND
			--T2.ItemCode LIKE @ITEMCODE AND
			(T2.DocDate <= @DATAREF) AND
			(T7.ManBtchNum ='Y') 
		GROUP BY
			T2.TransType,T2.[ItemCode],t6.whscode,t2.comment, T5.[DistNumber],T6.[BinCode],COALESCE(t6.descr,''),T2.PRICE, T2.DOCDATE
		HAVING 
			(SUM(IIF(T2.ActionType IN('1','19'),T4.Quantity,IIF(T2.ActionType IN('2','20'),(T4.Quantity *-1),0)))<> 0)

	INSERT INTO MBS..[RPA015]
		SELECT @empresa BASE,
			CONVERT(DATE,@DATAREF) DTPOSICAO,
			T2.ItemCode CODITEM
			,''--(SELECT ITEMNAME FROM tpathOITM WHERE ITEMCODE = T2.ITEMCODE) ITEMDESC
			,t6.whscode --CONCAT(t6.whscode,' - ',(SELECT WHSNAME FROM tpathOWHS WHERE WHSCODE = t6.whscode)) DEPOSITO
			,CASE
					WHEN t2.comment LIKE '%CANCEL%' THEN 'CANCELADO'
					WHEN T2.TransType = 13 THEN 'FATURAMENTO'
					WHEN T2.TransType IN (14,19) OR T6.BinCode LIKE '%DEV%' THEN 'DEVOLUCAO'
					WHEN T2.TransType = 15 THEN 'ENTREGA'
					WHEN T2.TransType IN (16,21) THEN 'RETORNO'
					WHEN T2.TransType = 18 THEN 'COMPRA'
					WHEN T2.TransType = 20 THEN 'RECEB.MERC.'
					WHEN T2.TransType = 59 THEN 'PROD.ACABADO'
					WHEN T2.TransType = 60 THEN 'SAIDA_INSUMO'
					WHEN T2.TransType = 67 THEN 'TRANSFERENCIA'
					WHEN T2.TransType = 10000071 THEN 'INVENTARIO'
					ELSE 'DIVERSOS'
			 END OPERACAO
			,T6.BinCode ENDERECO
			,COALESCE(t6.descr,'') DESCRICAO
			,'' LOTE
			,convert(float,SUM(IIF(T2.ActionType IN('1','19'),T4.Quantity,IIF(T2.ActionType IN('2','20'),(T4.Quantity *-1),0))))QTD
			,0--ISNULL((select CUSTOMEDIO from mbs..inventario WHERE CONVERT(DATE,dtsnapshot) = @DATAREF AND PRODCOD = T2.ItemCode AND DEPOSITO = CONCAT(t6.whscode,' - ',(SELECT WHSNAME FROM tpathOWHS WHERE WHSCODE = t6.whscode))),0) CUSTOMEDIO
			,0--ISNULL((select CUSTOMEDIO from mbs..inventario WHERE CONVERT(DATE,dtsnapshot) = @DATAREF AND PRODCOD = T2.ItemCode AND DEPOSITO = CONCAT(t6.whscode,' - ',(SELECT WHSNAME FROM tpathOWHS WHERE WHSCODE = t6.whscode))),0)*SUM(IIF(T2.ActionType IN('1','19'),T4.Quantity,IIF(T2.ActionType IN('2','20'),(T4.Quantity *-1),0))) VRLESTOQUE
			,ISNULL(t2.comment,'') OBSERVACAO
		FROM
			tpathOILM T2 INNER JOIN
			tpathOBTL T4 ON (T2.MessageID = T4.MessageID) INNER JOIN-- Tabela Log de Enderecos
			tpathOBIN T6 ON (T4.BinAbs = T6.AbsEntry) INNER JOIN-- Tabela Enderecos
			tpathOITM T7 ON (T2.ItemCode = T7.ItemCode)-- Tabela Itens
		WHERE 
			(1 = 1) AND 
			--T2.ItemCode LIKE @ITEMCODE AND
			(T2.DocDate <= @DATAREF) AND 
			(T7.ManBtchNum ='N')
		GROUP BY 
			T2.TransType,T2.[ItemCode],t6.whscode,t2.comment,T6.[BinCode],COALESCE(t6.descr,''),T2.PRICE, T2.DOCDATE
		HAVING 
			(SUM(IIF(T2.ActionType IN('1','19'),T4.Quantity,IIF(T2.ActionType IN('2','20'),(T4.Quantity *-1),0)))<> 0)

	end


	SET @i = 0
	while @i < @loop
		begin
			set @i = @i + 1; --inicio do laco
			set @empresa = (select empresa from #base where baseid = @i)
			set @pathOITM = CONCAT(N'CREATE SYNONYM tpathOITM FOR ',@empresa,N'.DBO.OITM');
			set @pathOWHS = CONCAT(N'CREATE SYNONYM tpathOWHS FOR ',@empresa,N'.DBO.OWHS');
			IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOITM') > 0 BEGIN DROP SYNONYM tpathOITM; EXEC(@pathOITM); END ELSE BEGIN exec(@pathOITM); END
			IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOWHS') > 0 BEGIN DROP SYNONYM tpathOWHS; EXEC(@pathOWHS); END ELSE BEGIN exec(@pathOWHS); END

		INSERT INTO MBS.[dbo].[RPA015_final]	
			SELECT 
				   replace(r.[BASE],'SBO','') BASE
				  ,r.[DTPOSICAO]
				  ,r.[CODITEM]
				  ,left(t.itemname,50) ITEMNAME--(SELECT ITEMNAME FROM tpathOITM WHERE ITEMCODE COLLATE DATABASE_DEFAULT = r.[CODITEM]) [ITEMDESC]
				  ,r.[DEPOSITO]--CONCAT(r.[DEPOSITO] COLLATE DATABASE_DEFAULT ,' - ',(SELECT WHSNAME FROM tpathOWHS WHERE WHSCODE COLLATE DATABASE_DEFAULT = r.[DEPOSITO])) [DEPOSITO]
				  ,r.[OPERACAO]
				  ,r.[COD_ENDER]
				  ,r.[DESC_ENDER]
				  ,r.[LOTE]
				  ,r.[QTD]
				  ,isnull(i.customedio,0) CUSTOMEDIO--ISNULL((select CUSTOMEDIO from mbs..inventario WHERE CONVERT(DATE,dtsnapshot) = @DATAREF AND PRODCOD COLLATE DATABASE_DEFAULT = r.[CODITEM] AND DEPOSITO COLLATE DATABASE_DEFAULT = CONCAT(r.[DEPOSITO] COLLATE DATABASE_DEFAULT ,' - ',(SELECT WHSNAME FROM tpathOWHS WHERE WHSCODE COLLATE DATABASE_DEFAULT = r.[DEPOSITO]))),0) CUSTOMEDIO
				  ,isnull(i.customedio*r.[QTD],0) VRLESTOQUE--ISNULL((select CUSTOMEDIO from mbs..inventario WHERE CONVERT(DATE,dtsnapshot) = @DATAREF AND PRODCOD COLLATE DATABASE_DEFAULT = r.[CODITEM] AND DEPOSITO COLLATE DATABASE_DEFAULT = CONCAT(r.[DEPOSITO] COLLATE DATABASE_DEFAULT ,' - ',(SELECT WHSNAME FROM tpathOWHS WHERE WHSCODE COLLATE DATABASE_DEFAULT = r.[DEPOSITO]))),0)*r.[QTD] VRLESTOQUE
				  ,left(COALESCE((REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(r.[OBSERVACAO]),'É','E'),'Ê','E'),'Á','A'),'Â','A'),'Ã','A'),'À','A'),'Ç','C'),'Ú','U'),'Í','I'),'Ó','O'),'Õ','O'),'Ô','O'),',',' '),CHAR(13), ' '), CHAR(10), ' '), CHAR(9), ' '),'*',''),'  ',' '),';','|')), ''), 50) [OBSERVACAO]
			  FROM
					[Mbs].[dbo].[RPA015] r inner join 
					tpathOITM t on t.ITEMCODE COLLATE DATABASE_DEFAULT = r.[CODITEM] 
					left join
					mbs..inventario i on CONVERT(DATE,i.dtsnapshot) = @DATAREF 
					and i.PRODCOD COLLATE DATABASE_DEFAULT = r.[CODITEM] and left(replace(i.deposito,'-',''),4) COLLATE DATABASE_DEFAULT = replace(r.deposito,'-','')
			  WHERE
					r.[BASE] = @empresa and
					r.[OPERACAO] not like 'cancel%'

		end


	SELECT 
		 [BASE]
		,[DTPOSICAO]
		,[CODITEM]
		,[ITEMNAME]
		,[DEPOSITO]
		,[OPERACAO]
		,[COD_ENDER]
		,[DESC_ENDER]
		,[LOTE]
		,[QTD]
		,[customedio]
		,[VRLESTOQUE]
		,[OBSERVACAO]
	FROM MBS.[dbo].[RPA015_final]