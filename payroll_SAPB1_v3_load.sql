DECLARE @integra TABLE (ROW# int, DATABASE_NAME varchar(max), FILIAL varchar(max), TIPO_FOLHA varchar(max), OJDT_NUMBER int);
DECLARE @integrasap nvarchar(max) = '';
DECLARE @dataref VARCHAR(MAX) = ''; 
DECLARE @filial VARCHAR(MAX) = ''; 
DECLARE @tipofolha VARCHAR(MAX) = ''; 
DECLARE @loop int = 0;
DECLARE @jdt1 nvarchar(max) = '';
DECLARE @ofpr nvarchar(max) = '';
DECLARE @nnm1 nvarchar(max) = '';
DECLARE @onnm nvarchar(max) = '';
DECLARE @ojdtnumber int = 0;
DECLARE @database VARCHAR(max) = '';
DECLARE @teste nvarchar(max) = '';

SET @integrasap = N'CREATE SYNONYM INTEGRASAP FOR [Mbs].[dbo].[INTEGRA_FOLHA_SAP]';
SET @teste = N'CREATE SYNONYM TESTE FOR SBOMW_TESTE.DBO.JDT1';

IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'INTEGRASAP') > 0 
	BEGIN DROP SYNONYM INTEGRASAP; EXEC(@integrasap); END
	ELSE BEGIN exec(@integrasap); END

IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'TESTE') > 0 
	BEGIN DROP SYNONYM TESTE; EXEC(@teste); END
	ELSE BEGIN exec(@teste); END

BEGIN TRANSACTION
	IF (SELECT MAX(DATAREF) FROM INTEGRASAP WHERE STATUS_GERACAO = 0) IS NOT NULL
	BEGIN

		SET @dataref = (SELECT MAX(DATAREF) FROM INTEGRASAP WHERE STATUS_GERACAO = 0); 
		SET @loop = (SELECT COUNT(DISTINCT (OJDT_NUMBER)) FROM INTEGRASAP WHERE STATUS_GERACAO = 0 AND DATAREF = @dataref);	  
		INSERT INTO @integra SELECT DISTINCT 0, DATABASE_NAME, FILIAL, TIPO_FOLHA, OJDT_NUMBER FROM INTEGRASAP WHERE DATAREF = @dataref ORDER BY OJDT_NUMBER;
		INSERT INTO @integra SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY OJDT_NUMBER DESC) AS Row#, DATABASE_NAME, FILIAL, TIPO_FOLHA, OJDT_NUMBER FROM @integra;
		DELETE FROM @integra WHERE ROW# = 0;
	--	select * from @integra;

		--==================== INSERE OS DADOS DE CADA FILIAL DA FOLHA MENSAL DENTRO DO JDT1 COM BASE NOS NUMEROS OJDT ================
		BEGIN
			WHILE @loop > 0
			BEGIN
				SET @jdt1 = N'CREATE SYNONYM tJDT1 FOR ' + (SELECT DATABASE_NAME FROM @integra WHERE ROW# = @loop) + N'.[dbo].JDT1';
				SET @ofpr = N'CREATE SYNONYM tOFPR FOR ' + (SELECT DATABASE_NAME FROM @integra WHERE ROW# = @loop) + N'.[dbo].OFPR';
				SET @onnm = N'CREATE SYNONYM tONNM FOR ' + (SELECT DATABASE_NAME FROM @integra WHERE ROW# = @loop) + N'.[dbo].ONNM';	
				SET @nnm1 = N'CREATE SYNONYM tNNM1 FOR ' + (SELECT DATABASE_NAME FROM @integra WHERE ROW# = @loop) + N'.[dbo].NNM1';
					
				IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tJDT1') > 0 
					BEGIN DROP SYNONYM tJDT1; EXEC(@jdt1); END
					ELSE BEGIN exec(@jdt1); END

				IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tOFPR') > 0 
					BEGIN DROP SYNONYM tOFPR; EXEC(@ofpr); END
					ELSE BEGIN exec(@ofpr); END

				IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tONNM') > 0 
					BEGIN DROP SYNONYM tONNM; EXEC(@onnm); END
					ELSE BEGIN exec(@onnm); END

				IF (select COUNT(NAME) from sys.synonyms WHERE NAME = 'tNNM1') > 0 
					BEGIN DROP SYNONYM tNNM1; EXEC(@nnm1); END
					ELSE BEGIN exec(@nnm1); END

				SET @ojdtnumber = (SELECT OJDT_NUMBER FROM @integra WHERE ROW# = @loop);
				SET @database = (SELECT DATABASE_NAME FROM @integra WHERE ROW# = @loop);
				SET @tipofolha = (SELECT TOP 1 TIPO_FOLHA FROM INTEGRASAP WHERE OJDT_NUMBER = @ojdtnumber AND STATUS_GERACAO = 0);

		 INSERT INTO SBOMW_TESTE.DBO.JDT1 (ExpUUID, RelTransId, RelLineID, CenVatCom, MatType, IntrnMatch, ExtrMatch, LogInstanc, MultMatch, LineType, SequenceNr, DunnLevel, TaxType, MIEntry, MIVEntry, ClsInTP, PstngType, InterimTyp, FCDebit, FCCredit, SystemRate, ToMthSum, BaseSum, VatRate, SYSBaseSum, VatAmount, SYSVatSum, GrossValue, BalFcDeb, BalFcCred, GrossValFc, EquVatRate, EquVatSum, SYSEquSum, TotalVat, SYSTVat, WTApplied, WTAppliedS, WTAppliedF, WTSum, WTSumFC, WTSumSC, TransType, ObjType, UserSign, ValidFrom, ValidFrom2, ValidFrom3, ValidFrom4, ValidFrom5, TransId, CreatedBy, BaseRef, FinncPriod, DueDate, RefDate, TaxDate, Line_ID, BPLId, Debit, SYSDeb, BalDueDeb, BalScDeb, Credit, SYSCred, BalDueCred, BalScCred, VatRegNum, Account, ShortName, ContraAct, DebCred, Project, BPLName, LineMemo, RelType, AdjTran, RevSource, VatLine, Closed, DunWizBlck, TaxPostAcc, WTLiable, WTLine, PayBlock, Ordered, IsNet)
					--///// TESTE PARA GERAR O NAO OFICIAL PARA CONFERENCIA  ////// 	INSERT INTO tJDT1 (ExpUUID, RelTransId, RelLineID, CenVatCom, MatType, IntrnMatch, ExtrMatch, LogInstanc, MultMatch, LineType, SequenceNr, DunnLevel, TaxType, MIEntry, MIVEntry, ClsInTP, PstngType, InterimTyp, FCDebit, FCCredit, SystemRate, ToMthSum, BaseSum, VatRate, SYSBaseSum, VatAmount, SYSVatSum, GrossValue, BalFcDeb, BalFcCred, GrossValFc, EquVatRate, EquVatSum, SYSEquSum, TotalVat, SYSTVat, WTApplied, WTAppliedS, WTAppliedF, WTSum, WTSumFC, WTSumSC, TransType, ObjType, UserSign, ValidFrom, ValidFrom2, ValidFrom3, ValidFrom4, ValidFrom5, TransId, CreatedBy, BaseRef, FinncPriod, DueDate, RefDate, TaxDate, Line_ID, BPLId, Debit, SYSDeb, BalDueDeb, BalScDeb, Credit, SYSCred, BalDueCred, BalScCred, VatRegNum, Account, ShortName, ContraAct, DebCred, Project, BPLName, LineMemo, RelType, AdjTran, RevSource, VatLine, Closed, DunWizBlck, TaxPostAcc, WTLiable, WTLine, PayBlock, Ordered, IsNet)
				SELECT
					 'FPW' --ExpUUID
					,-1 --RelTransId
					,-1 --RelLineID
					,-1 --CenVatCom
					,-1 --MatType
					,0 --IntrnMatch
					,0 --ExtrMatch
					,0 --LogInstanc
					,0 --MultMatch
					,0 --LineType
					,0 --SequenceNr
					,0 --DunnLevel
					,0 --TaxType
					,0 --MIEntry
					,0 --MIVEntry
					,0 --ClsInTP
					,0 --PstngType
					,0 --InterimTyp
					,0 --FCDebit
					,0 --FCCredit
					,0 --SystemRate
					,0 --ToMthSum
					,0 --BaseSum
					,0 --VatRate
					,0 --SYSBaseSum
					,0 --VatAmount
					,0 --SYSVatSum
					,0 --GrossValue
					,0 --BalFcDeb
					,0 --BalFcCred
					,0 --GrossValFc
					,0 --EquVatRate
					,0 --EquVatSum
					,0 --SYSEquSum
					,0 --TotalVat
					,0 --SYSTVat
					,0 --WTApplied
					,0 --WTAppliedS
					,0 --WTAppliedF
					,0 --WTSum
					,0 --WTSumFC
					,0 --WTSumSC
					,30 --TransType
					,30 --ObjType
					,42 --UserSign
					,'1900-01-01 00:00:00.000' --ValidFrom
					,'1900-01-01 00:00:00.000' --ValidFrom2
					,'1900-01-01 00:00:00.000' --ValidFrom3
					,'1900-01-01 00:00:00.000' --ValidFrom4
					,'1900-01-01 00:00:00.000' --ValidFrom5
					,@ojdtnumber --TransId
					,@ojdtnumber --CreatedBy
					,@ojdtnumber --BaseRef
					,CAST((SELECT ABSENTRY FROM tOFPR WHERE CODE = CONCAT(LEFT(@dataref,4),'-',RIGHT(@dataref,2))) AS SMALLINT) --FinncPriod
					,CAST(EOMONTH(CONCAT(RIGHT(@dataref,2),'/','01','/',LEFT(@dataref,4))) AS DATETIME)--DueDate
					,CAST(EOMONTH(CONCAT(RIGHT(@dataref,2),'/','01','/',LEFT(@dataref,4))) AS DATETIME)--RefDate
					,CAST(EOMONTH(CONCAT(RIGHT(@dataref,2),'/','01','/',LEFT(@dataref,4))) AS DATETIME)--TaxDate
					,JDT1_NUMBER --Line_ID
					,BPLId --BPLId
					,CASE WHEN TIPO_SAP = 'DEBITO' THEN ABS(TOTAL) ELSE 0 END --Debit
					,CASE WHEN TIPO_SAP = 'DEBITO' THEN ABS(TOTAL) ELSE 0 END --SYSDeb
					,CASE WHEN TIPO_SAP = 'DEBITO' THEN ABS(TOTAL) ELSE 0 END --BalDueDeb
					,CASE WHEN TIPO_SAP = 'DEBITO' THEN ABS(TOTAL) ELSE 0 END --BalScDeb
					,CASE WHEN TIPO_SAP = 'CREDITO' THEN ABS(TOTAL) ELSE 0 END --Credit
					,CASE WHEN TIPO_SAP = 'CREDITO' THEN ABS(TOTAL) ELSE 0 END --SYSCred
					,CASE WHEN TIPO_SAP = 'CREDITO' THEN ABS(TOTAL) ELSE 0 END --BalDueCred
					,CASE WHEN TIPO_SAP = 'CREDITO' THEN ABS(TOTAL) ELSE 0 END --BalScCred
					,BPLCNPJ --VatRegNum
					,CONTA_CONTABIL --Account
					,CONTA_CONTABIL --ShortName
					,CONTA_CONTABIL --ContraAct
					,CASE WHEN TIPO_SAP = 'DEBITO' THEN 'D' ELSE 'C' END --DebCred
					,PROJETO --Project
					,BPLName --BPLName
					,LEFT(HISTORICO,50) --LineMemo
					,'N' --RelType
					,'N' --AdjTran
					,'N' --RevSource
					,'N' --VatLine
					,'N' --Closed
					,'N' --DunWizBlck
					,'N' --TaxPostAcc
					,'N' --WTLiable
					,'N' --WTLine
					,'N' --PayBlock
					,'N' --Ordered
					,'Y' --IsNet
				FROM INTEGRASAP I
				WHERE I.OJDT_NUMBER = @ojdtnumber AND I.DATABASE_NAME = @database AND STATUS_GERACAO = 0;
		
				UPDATE INTEGRASAP SET STATUS_GERACAO = 1 WHERE OJDT_NUMBER = @ojdtnumber

				---- TESTE PARA ATUALIZACAO DA NUMERACAO DAS TABELAS DO SAP PARA SERIE LC -----------  UPDATE tONNM SET AUTOKEY = (@ojdtnumber + 1) WHERE OBJECTCODE = '30';
				UPDATE SBOMW_TESTE.DBO.ONNM SET AUTOKEY = (@ojdtnumber + 1) WHERE OBJECTCODE = '30';

				---- TESTE PARA ATUALIZACAO DA NUMERACAO DAS TABELAS DO SAP PARA SERIE LC -----------  UPDATE tNNM1 SET NEXTNUMBER = (@ojdtnumber + 1) WHERE SERIES = 14;
				UPDATE SBOMW_TESTE.DBO.NNM1 SET NEXTNUMBER = (@ojdtnumber + 1) WHERE SERIES = 14;

				SET @loop = @loop - 1;

			END;
		END;


	--========================= ENVIA E-MAIL FINAL COM O RESULTADO DA IMPORTACAO DA FOLHA ========================

		DECLARE @tableHTML NVARCHAR(MAX)
		DECLARE @texto NVARCHAR(MAX)

		SET @tableHTML =  
			N'<H2>EXITO NA GERACAO DA FOLHA DE PAGAMENTO AUTOMATIZADA</H2>' +  
			N'<p>' + 
			N'A folha de pagamento ' + CAST(@dataref AS NVARCHAR(MAX)) + 
			N' foi gerada com sucesso na Contabilidade!<br><br></p>' + 
			N'<table border="1">' +  
			N'<tr><th>BASE</th><th>FILIAL</th><th>CNPJ</th><th>FOLHA</th><th>LANCAMENTO</th><th>VALOR$</th></tr>' +  
			CAST ( ( SELECT 
							td = DATABASE_NAME, '',  
							td = FILIAL, '',  
							td = BPLCNPJ, '',   
							td = TIPO_FOLHA, '', 
							td = OJDT_NUMBER, '', 
							td = CASE WHEN TIPO_FOLHA LIKE 'PRV%' THEN CONVERT(DECIMAL(12,2), SUM(TOTAL)/2) ELSE CONVERT(DECIMAL(12,2), SUM(TOTAL)) END, ''
					  FROM MBS..INTEGRA_FOLHA_SAP WHERE DATAREF = @dataref AND STATUS_GERACAO = 1 AND HISTORICO NOT LIKE '%LIQUIDO A PAGAR%%'
					  GROUP BY DATABASE_NAME, FILIAL, BPLCNPJ, TIPO_FOLHA, OJDT_NUMBER, DATAREF
					  FOR XML PATH('tr'), TYPE   
			) AS NVARCHAR(MAX) ) +  
			N'</table>' +
			N'<p>TOTAL DESTA FOLHA: R$ ' + CAST((SELECT SUM(CASE WHEN TIPO_FOLHA LIKE 'PRV%' THEN CONVERT(DECIMAL(12,2), (TOTAL)/2) ELSE CONVERT(DECIMAL(12,2), (TOTAL)) END) FROM MBS..INTEGRA_FOLHA_SAP WHERE DATAREF = @dataref AND STATUS_GERACAO = 1 AND HISTORICO NOT LIKE '%LIQUIDO A PAGAR%%') AS NVARCHAR(MAX)) + N'</p>' +
			N'<p>Atenciosamente, <br><br> Equipe de Tecnologia</p>'; 

		SET @texto = N'FOLHA DE PAGAMENTO AUTOMATIZADA - PERIODO: ' + CAST(@dataref AS NVARCHAR(MAX)) 

		--Send mail
		EXEC msdb.dbo.sp_send_dbmail
			@recipients=N'rodrigo.matos@nutriex.com.br',
			--@copy_recipients=N'junior.nunes@eficienciacont.com.br',
			@body= @tableHTML,
			@body_format = 'HTML',
			@subject = @texto,
			@profile_name = 'NutriexReports'
	END;
	ELSE 
		BEGIN 
			--Send mail
			SET @texto = N'ERRO JDT1!!! FOLHA DE PAGAMENTO AUTOMATIZADA NAO REALIZADA - PERIODO: ' + CAST(@dataref AS NVARCHAR(MAX)) 
			EXEC msdb.dbo.sp_send_dbmail
				@recipients=N'rodrigo.matos@nutriex.com.br',
				--@copy_recipients=N'junior.nunes@eficienciacont.com.br;vanessa.soares@mw.far.br',
				@body= N'ETAPA 03/03 - NADA FOI GERADO PARA ESTA FOLHA! RODRIGO MATOS.',
				@body_format = 'HTML',
				@subject = @texto,
				@profile_name = 'NutriexReports'
		END;
ROLLBACK TRANSACTION