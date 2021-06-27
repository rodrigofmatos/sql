----------------------------------------------------------
--// TEMA: ROBO TITULOS EM ABERTO
--// -----------------------------------------------------
--// CRIADO POR: RODRIGO MATOS (CIENTISTA DADOS)
--// VERSAO: 1.0.0		
--// DATA: 06.JUL.2020
--// SOLIC.: BRANDAO/PIO (CREDITO E COBRANCA)
--// -----------------------------------------------------

IF OBJECT_ID('[mbs].[dbo].[CONTAS_A_RECEBER2]', 'U') IS NOT NULL begin DROP TABLE [mbs].[dbo].[CONTAS_A_RECEBER2] end
IF OBJECT_ID('tempdb..##empresas', 'U') IS NOT NULL begin DROP TABLE ##empresas end

CREATE TABLE [mbs].[dbo].[CONTAS_A_RECEBER2](
	[SEGMENTO] [nvarchar](50) NULL,
	[SEMAFORO] [nvarchar](50) NULL,
	[BASE] [nvarchar](50) NULL,
	[EMPRESA] [nvarchar](50) NULL,
	[NF] [nvarchar](50) NULL,
	[DocumentoSAP] [int] NULL,
	[FormaCobranca] [varchar](20) NULL,
	[SALDONF] [decimal](18,2) NULL,
	[Emissao] [date] NULL,
	[Vencimento] [date] NULL,
	[Atraso] [int] NULL,
	[Grupo] [nvarchar](50) NULL,
	[CodigoCliente] [nvarchar](15) NULL,
	[RazaoSocial] [nvarchar](100) NULL,
	[CodigoItem] [nvarchar](15) NULL,
	[DescItem] [nvarchar](100) NULL,
	[VlrTotItem] [decimal](18,2) NULL
) ON [PRIMARY]

DECLARE @loop int = (SELECT COUNT(baseid) FROM mbs..bases);
DECLARE @i int = 0;
DECLARE @empresa nvarchar(MAX);
DECLARE @pathocrd nvarchar(MAX);
DECLARE @pathINV1 nvarchar(MAX);
DECLARE @pathOINV nvarchar(MAX);
DECLARE @pathOCRG nvarchar(MAX);

while @i < @loop
	begin
		set @i = @i + 1; --inicio do laço
		set @empresa = (select empresa from mbs..bases where baseid = @i)
		set @pathocrd = CONCAT(N'CREATE SYNONYM tpathocrd FOR ',@empresa,N'.DBO.ocrd');
		set @pathINV1 = CONCAT(N'CREATE SYNONYM tpathINV1 FOR ',@empresa,N'.DBO.INV1');
		set @pathOINV = CONCAT(N'CREATE SYNONYM tpathOINV FOR ',@empresa,N'.DBO.OINV');
		set @pathOCRG = CONCAT(N'CREATE SYNONYM tpathOCRG FOR ',@empresa,N'.DBO.OCRG');

		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathocrd') > 0 BEGIN DROP SYNONYM tpathocrd; EXEC(@pathocrd); END ELSE BEGIN exec(@pathocrd); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathINV1') > 0 BEGIN DROP SYNONYM tpathINV1; EXEC(@pathINV1); END ELSE BEGIN exec(@pathINV1); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOINV') > 0 BEGIN DROP SYNONYM tpathOINV; EXEC(@pathOINV); END ELSE BEGIN exec(@pathOINV); END
		IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tpathOCRG') > 0 BEGIN DROP SYNONYM tpathOCRG; EXEC(@pathOCRG); END ELSE BEGIN exec(@pathOCRG); END

		INSERT INTO [mbs].[dbo].[CONTAS_A_RECEBER2]
			Select 
				  'SEGMENTO' AS SEGMENTO
				 , 'OKAY' AS SEMAFORO
				 , upper(@empresa) as BASE
				 , replace(upper(@empresa),'SBO','') AS EMPRESA
				 ,  (Convert (NvarChar (10),v.Serial)) NF 
				 , V.DocEntry As DocumentoSAP
				 , FormaCobranca=(Case When IsNull(v.Indicator, '-1')='CH' Then 'CHEQUE DEVOLVIDO' Else 'CARTEIRA' End)
				 , ((V.DOCTOTALSY - V.PaidToDate)) As SALDO
				 , CAST(v.DOCDate AS DATE) As Emissao
				 , CAST(V.DOCDUEDATE AS DATE) As Vencimento
				 , DateDiff (D, V.DOCDUEDATE , GetDate()) As Atraso
				 , UPPER((Select g.Groupname From tpathOCRG g Where g.GroupCode = c.GroupCode)) As Grupo
				 , V.CardCode As CodigoCliente
				 , Upper (V.CardName) As RazaoSocial, N.ITEMCODE, N.DSCRIPTION, N.LINETOTAL VLRTOTITEM
			From
				tpathocrd c inner Join 
				tpathOINV v On c.CardCode = v.CardCode inner Join
				tpathINV1 N On v.DocEntry = N.DocEntry
			Where
				V.DOCStatus = 'O' AND V.CANCELED = 'N' AND
				(V.DOCTOTALSY - V.PaidToDate) > 0 and year((v.DOCDate)) = 2020 AND
				(N.DSCRIPTION LIKE '%COVID%' OR N.DSCRIPTION LIKE '%ALCOOL%' OR N.DSCRIPTION LIKE '%MASCARA%')
	end;	  

UPDATE 
	[Mbs].[dbo].[CONTAS_A_RECEBER2] 
	SET 
		SEMAFORO = 
			CASE
				WHEN ATRASO < 5 THEN '9OKAY (-5D)'
				WHEN ATRASO >= 5 AND ATRASO <= 15 THEN '1ALERTA (+5D)'
				WHEN ATRASO >= 16 AND ATRASO <= 40 THEN '2PROT. (+15D)'
				WHEN ATRASO >= 41 AND ATRASO <= 60 THEN '3NEGOC. (+40D)'
				WHEN ATRASO >= 61 AND ATRASO <= 90 THEN '4CRITIC. (+60D)'
				ELSE '5PERDA (+90D)'
			END,

		EMPRESA = 
				CASE
					WHEN EMPRESA = 'A7' THEN 'A7'
					WHEN EMPRESA = 'ChuaChua' THEN 'CHUA CHUA'
					WHEN EMPRESA = 'DL' THEN 'DL'
					WHEN EMPRESA = 'EmpLREZENDE' THEN 'LREZENDE'
					WHEN EMPRESA = 'EmpreendimentosRZ' THEN 'RZ'
					WHEN EMPRESA = 'EmpreendimentosSM' THEN 'SM'
					WHEN EMPRESA = 'Equilibrium' THEN 'EQUILIBRIUM'
					WHEN EMPRESA = 'GDSMARCAS' THEN 'BELA CARIOCA'
					WHEN EMPRESA = 'GdsMarcasEU' THEN 'GDS EUROPA'
					WHEN EMPRESA = 'Infinix1' THEN 'INFINIX 1'
					WHEN EMPRESA = 'Infinix2' THEN 'INFINIX 2'
					WHEN EMPRESA = 'InnovaBR' THEN 'INNOVA BR'
					WHEN EMPRESA = 'InnovaLab' THEN 'INNOVA LAB'
					WHEN EMPRESA = 'InnovaPA' THEN 'INNOVA PA'
					WHEN EMPRESA = 'LCA' THEN 'LCA'
					WHEN EMPRESA = 'ML' THEN 'ML'
					WHEN EMPRESA = 'MW' THEN 'MW'
					WHEN EMPRESA = 'NutGynMatriz' THEN 'NPH'
					WHEN EMPRESA = 'NutriexInd' THEN 'NUTRIEX COSMETICOS'
					WHEN EMPRESA = 'Oralls' THEN 'ORALLS'
					WHEN EMPRESA = 'RZLaboratorios' THEN 'RZ PORTUGAL'
					WHEN EMPRESA = 'Vidafarma' THEN 'VDM'
					WHEN EMPRESA = 'VZ' THEN 'VZ'
					WHEN EMPRESA = 'Z9' THEN 'Z9'
					ELSE EMPRESA
				END,

		SEGMENTO = 
				CASE
					WHEN BASE LIKE 'SBOEQUILIBRIUM'	THEN 'INN/LIC/NUT'
					WHEN BASE IN ('SBOINNOVABR', 'SBOINNOVAPA', 'SBOVIDAFARMA')	THEN 'INNOVA'
					WHEN BASE IN ('SBOA7', 'SBODL', 'SBOINNOVALAB', 'SBOLICITAACAO') THEN 'LICITACAO'
					WHEN BASE IN ('SBOML', 'SBOMW', 'SBONUTGYNMATRIZ', 'SBONUTRIEXIND','SBOLCA','SboChuaChua','SBOGDSMARCAS') THEN 'NUTRIEX'					
					WHEN BASE IN ('SBOEmpLREZENDE', 'SBOEmpreendimentosRZ', 'SBOEmpreendimentosSM', 'SBOInfinix1','SBOInfinix2') THEN 'HOLDING'					
					WHEN BASE IN ('SBOGdsMarcasEU', 'SBOOralls', 'SBORZLaboratorios', 'SBOVZ', 'SBOZ9') THEN 'DIST_LUCROS'					
					ELSE 'GERAL'
				END,
		
		GRUPO = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(GRUPO,'É','E'),'Ê','E'),'Á','A'),'Â','A'),'Ã','A'),'À','A'),'Ç','C'),'Ú','U'),'Í','I'),'Ó','O'),'Õ','O'),'Ô','O'),',',' '),

		RAZAOSOCIAL = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(RAZAOSOCIAL,'É','E'),'Ê','E'),'Á','A'),'Â','A'),'Ã','A'),'À','A'),'Ç','C'),'Ú','U'),'Í','I'),'Ó','O'),'Õ','O'),'Ô','O'),',',' ')
		

SELECT [SEGMENTO]
      ,[SEMAFORO]
      ,[BASE]
      ,[EMPRESA]
      ,[NF]
      ,[DocumentoSAP]
      ,[FormaCobranca]
      ,cast([Emissao] as date) [Emissao]
      ,cast([Vencimento] as date) [Vencimento]
      ,[Atraso]
      ,[Grupo]
      ,[CodigoCliente]
      ,[RazaoSocial]
      ,[CodigoItem]
      ,[DescItem]
      ,cast([VlrTotItem] as float) VLRTOTITEM
      ,cast([SALDO] as float) SALDONF
  FROM [Mbs].[dbo].[CONTAS_A_RECEBER2]