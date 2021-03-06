DECLARE @integra TABLE (ROW# int, DATABASE_NAME varchar(max), FILIAL varchar(max), TIPO_FOLHA varchar(max), OJDT_NUMBER int);
DECLARE @integrasap nvarchar(max) = '';
DECLARE @dataref VARCHAR(MAX) = ''; 
DECLARE @filial VARCHAR(MAX) = ''; 
DECLARE @tipofolha VARCHAR(MAX) = ''; 
DECLARE @loop int = 0;
DECLARE @ojdt nvarchar(max) = '';
DECLARE @ofpr nvarchar(max) = '';
DECLARE @database VARCHAR(max) = '';
DECLARE @teste nvarchar(max) = '';
DECLARE @ojdtnumber int = 0;
DECLARE @texto NVARCHAR(MAX);

SET @integrasap = N'CREATE SYNONYM INTEGRASAP1 FOR [Mbs].[dbo].[INTEGRA_FOLHA_SAP]';
SET @teste = N'CREATE SYNONYM TESTE1 FOR SBOMW_TESTE.DBO.OJDT';

IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'INTEGRASAP1') > 0 
	BEGIN DROP SYNONYM INTEGRASAP1; EXEC(@integrasap); END
	ELSE BEGIN exec(@integrasap); END
	
IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'TESTE1') > 0 
	BEGIN DROP SYNONYM TESTE1; EXEC(@teste); END
	ELSE BEGIN exec(@teste); END

BEGIN TRANSACTION
	IF (SELECT MAX(DATAREF) FROM INTEGRASAP1 WHERE STATUS_GERACAO = 0) IS NOT NULL
	BEGIN

		SET @dataref = (SELECT MAX(DATAREF) FROM INTEGRASAP1 WHERE STATUS_GERACAO = 0); 

		INSERT INTO @integra SELECT DISTINCT 0, DATABASE_NAME, FILIAL, TIPO_FOLHA, OJDT_NUMBER FROM INTEGRASAP1 WHERE DATAREF = @dataref ORDER BY DATABASE_NAME, FILIAL, TIPO_FOLHA, OJDT_NUMBER;
		INSERT INTO @integra SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY DATABASE_NAME ASC, FILIAL ASC) AS Row#, DATABASE_NAME, FILIAL, TIPO_FOLHA, OJDT_NUMBER FROM @integra;
		DELETE FROM @integra WHERE ROW# = 0;
		SET @loop = (SELECT COUNT(ROW#) AS ROW# FROM @integra);
	
		--==================== INSERE OS DADOS DE CADA FILIAL DA FOLHA MENSAL DENTRO DO OJDT X 4 CATEGORIAS (MENSAL, PROLABORE, RESCISAO, PROVISOES FERIAS + DEC. TERC.) ================
		BEGIN
			WHILE @loop > 0
			BEGIN
				SET @ojdt = CONCAT(N'CREATE SYNONYM tOJDT1 FOR ',(SELECT DATABASE_NAME FROM @integra WHERE ROW# = @loop),N'.[dbo].OJDT');
				SET @ofpr = CONCAT(N'CREATE SYNONYM tOFPR1 FOR ',(SELECT DATABASE_NAME FROM @integra WHERE ROW# = @loop),N'.[dbo].OFPR');


				IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tOJDT1') > 0 
					BEGIN DROP SYNONYM tOJDT1; EXEC(@ojdt); END
					ELSE BEGIN exec(@ojdt); END

				IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tOFPR1') > 0 
					BEGIN DROP SYNONYM tOFPR1; EXEC(@ofpr); END
					ELSE BEGIN exec(@ofpr); END

				SET @filial = (SELECT FILIAL FROM @integra WHERE ROW# = @loop);
				SET @database = (SELECT DATABASE_NAME FROM @integra WHERE ROW# = @loop);
				SET @tipofolha = (SELECT TIPO_FOLHA FROM @integra WHERE ROW# = @loop);
			-- /////	SET @ojdtnumber = (SELECT CAST((SELECT MAX(TransId)+1 FROM tOJDT1) AS INT));--///// TESTE PARA GERAR O NAO OFICIAL PARA CONFERENCIA
				 SET @ojdtnumber = (SELECT CAST((SELECT MAX(TransId)+1 FROM TESTE1) AS INT)); 

			INSERT INTO SBOMW_TESTE.DBO.OJDT (Creator, VersionNum, DataSource, AdjTran, AutoStorno, AutoVAT, AutoWT, BlockDunn, Corisptivi, DeferedTax, ECDPosTyp, GenRegNo, Printed, PrlLinked, RefndRprt, Report347, ReportEU, RevSource, StampTax, BtfStatus, ResidenNum, DocSeries, Series, ObjType, TransType, UserSign, UserSign2, LocTotal, SysTotal, FinncPriod, BaseRef, CreatedBy, Number, TransId, DueDate, RefDate, TaxDate, CreateTime, Memo, CreateDate, UpdateDate, FcTotal)
			--///// TESTE PARA GERAR O NAO OFICIAL PARA CONFERENCIA  //////  --INSERT INTO tOJDT1 (Creator, VersionNum, DataSource, AdjTran, AutoStorno, AutoVAT, AutoWT, BlockDunn, Corisptivi, DeferedTax, ECDPosTyp, GenRegNo, Printed, PrlLinked, RefndRprt, Report347, ReportEU, RevSource, StampTax, BtfStatus, ResidenNum, DocSeries, Series, ObjType, TransType, UserSign, UserSign2, LocTotal, SysTotal, FinncPriod, BaseRef, CreatedBy, Number, TransId, DueDate, RefDate, TaxDate, CreateTime, Memo, CreateDate, UpdateDate, FcTotal)
				SELECT TOP 1
					'FPW'--Creator
					,'10.00.120.02'--VersionNum
					,'I'--DataSource
					,'N'--AdjTran
					,'N'--AutoStorno
					,'N'--AutoVAT
					,'N'--AutoWT
					,'N'--BlockDunn
					,'N'--Corisptivi
					,'N'--DeferedTax
					,'N'--ECDPosTyp
					,'N'--GenRegNo
					,'N'--Printed
					,'N'--PrlLinked
					,'N'--RefndRprt
					,'N'--Report347
					,'N'--ReportEU
					,'N'--RevSource
					,'N'--StampTax
					,'O'--BtfStatus
					,1--ResidenNum
					,14--DocSeries
					,14--Series
					,30--ObjType
					,30--TransType
					,42--UserSign
					,42--UserSign2
					,(SELECT ABS(SUM([TOTAL])) AS TOTALFILIAL FROM INTEGRASAP1 WHERE [TIPO_FOLHA] = @tipofolha AND [DATAREF] = @dataref AND [FILIAL] = @filial)--LocTotal
					,(SELECT ABS(SUM([TOTAL])) AS TOTALFILIAL FROM INTEGRASAP1 WHERE [TIPO_FOLHA] = @tipofolha AND [DATAREF] = @dataref AND [FILIAL] = @filial)--SysTotal
					,CAST((SELECT R.ABSENTRY FROM tOFPR1 R WHERE R.CODE = CONCAT(LEFT(@dataref,4),'-',RIGHT(@dataref,2))) AS SMALLINT)--FinncPriod
					,@ojdtnumber--BaseRef
					,@ojdtnumber--CreatedBy
					,@ojdtnumber--Number
					,@ojdtnumber--TransId
					,CAST(EOMONTH(CONCAT(RIGHT(@dataref,2),'/','01','/',LEFT(@dataref,4))) AS DATETIME)--DueDate
					,CAST(EOMONTH(CONCAT(RIGHT(@dataref,2),'/','01','/',LEFT(@dataref,4))) AS DATETIME)--RefDate
					,CAST(EOMONTH(CONCAT(RIGHT(@dataref,2),'/','01','/',LEFT(@dataref,4))) AS DATETIME)--TaxDate
					,FORMAT(CURRENT_TIMESTAMP,'HHmm')--CreateTime
					,LEFT(CONCAT(@tipofolha,'_',@dataref,'_',LEFT(@filial,28),'..',RIGHT(@filial,6)),50)--Memo
					,GETDATE()--CreateDate
					,GETDATE()--UpdateDate
					,0--FcTotal
				FROM INTEGRASAP1 I
				WHERE I.FILIAL = @filial AND I.TIPO_FOLHA = @tipofolha AND I.DATAREF = @dataref AND I.DATABASE_NAME = @database;
		
				UPDATE INTEGRASAP1 SET OJDT_NUMBER = @ojdtnumber WHERE FILIAL = @filial AND TIPO_FOLHA = @tipofolha AND DATAREF = @dataref AND DATABASE_NAME = @database AND [STATUS_GERACAO] = 0;
				SET @loop = @loop - 1;

			END;
		END;
	END;
	--========================= ENVIA E-MAIL FINAL COM O RESULTADO DA IMPORTACAO DA FOLHA COM ERRO ========================

	ELSE 
		BEGIN 
			--Send mail
			SET @texto = N'ERRO OJDT!!! FOLHA DE PAGAMENTO AUTOMATIZADA NAO REALIZADA - PERIODO: ' + CAST(@dataref AS NVARCHAR(MAX)) 
			EXEC msdb.dbo.sp_send_dbmail
				@recipients=N'rodrigo.matos@nutriex.com.br',
				--@copy_recipients=N'junior.nunes@eficienciacont.com.br',
				@body= N'ETAPA 02/03 - NADA FOI GERADO PARA ESTA FOLHA! RODRIGO MATOS.',
				@body_format = 'HTML',
				@subject = @texto,
				@profile_name = 'NutriexReports'
		END;
ROLLBACK TRANSACTION