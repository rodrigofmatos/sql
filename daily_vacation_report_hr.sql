--RPA015
SET DATEFIRST  7, -- 1 = Monday, 7 = Sunday
    DATEFORMAT dmy, 
    LANGUAGE   PORTUGUESE;
    --LANGUAGE   US_ENGLISH;

DROP TABLE IF EXISTS mbs.[dbo].[rpa014]

USE FPW5
DROP TABLE IF EXISTS #func
DROP TABLE IF EXISTS #ferias
DROP TABLE IF EXISTS #usufruido
DROP TABLE IF EXISTS #dpfinal
DROP TABLE IF EXISTS #html

declare @body varchar(max);
declare @subj nvarchar(max) = '';
declare @mes int = FORMAT(GETDATE(),'MM');
declare @mesextenso nvarchar(max) = UPPER(LEFT(FORMAT(GETDATE(),'MMMM'), 1)) + lower(RIGHT(FORMAT(GETDATE(),'MMMM'), len(FORMAT(GETDATE(),'MMMM'))-1) ) 

(SELECT distinct format(F.FUCODEMP,'000') + FORMAT([FUCPF],'00000000000') keyid into #usufruido
FROM 
	[OCORFUNC] O INNER JOIN 
	[FUNCIONA] F ON F.FUCODEMP = O.OFCODEMP AND F.FUMATFUNC = O.OFMATFUNC
group by format(F.FUCODEMP,'000') + FORMAT([FUCPF],'00000000000'), [OFCODOCORR], [OFDTAUX], FUCODEMP
having 
	[OFCODOCORR] in (1001) AND 
	F.FUCODEMP NOT IN (1,11,13,16) AND 
	(30-sum(O.[OFNUMDIAFE]+O.[OFNUMDIAAX])) <= 0 AND
	YEAR(CONVERT(DATETIME,CONCAT(LEFT(CAST(CONVERT(INT,O.[OFDTAUX]) AS NVARCHAR(MAX)),4),'-',SUBSTRING(CAST(CONVERT(INT,O.[OFDTAUX]) AS NVARCHAR(MAX)),5,2),'-',RIGHT(CAST(CONVERT(INT,O.[OFDTAUX]) AS NVARCHAR(MAX)),2)))) >= 2019)


SELECT format(F.FUCODEMP,'000') + FORMAT([FUCPF],'00000000000') keyid,
	 E.[EMNOMEMP] EMPRESA
	,FORMAT([FUCPF],'000\.000\.000\-00') CPF
	,[FUNOMFUNC] + FORMAT([FUMATFUNC],' - 000') FUNCIONARIO
	,O.[OFNUMDIAFE] DIASFERIAS
	,O.[OFNUMDIAAX] FALTASINJ 
	,(30-O.[OFNUMDIAFE]-O.[OFNUMDIAAX]) SALDO
	,CONVERT(DATETIME,CONCAT(LEFT(CAST(CONVERT(INT,O.[OFDTAUX]) AS NVARCHAR(MAX)),4),'-',SUBSTRING(CAST(CONVERT(INT,O.[OFDTAUX]) AS NVARCHAR(MAX)),5,2),'-',RIGHT(CAST(CONVERT(INT,O.[OFDTAUX]) AS NVARCHAR(MAX)),2))) INIPERAQ
	,CONVERT(DATETIME,CONCAT(LEFT(CAST(CONVERT(INT,O.[OFDTAUX]) AS NVARCHAR(MAX)),4),'-',SUBSTRING(CAST(CONVERT(INT,O.[OFDTAUX]) AS NVARCHAR(MAX)),5,2),'-',RIGHT(CAST(CONVERT(INT,O.[OFDTAUX]) AS NVARCHAR(MAX)),2))) + (364*2) - 30 FIMPERAQ
	,CONVERT(DATETIME,CONCAT(LEFT(CAST(CONVERT(INT,O.[OFDTINIOCO]) AS NVARCHAR(MAX)),4),'-',SUBSTRING(CAST(CONVERT(INT,O.[OFDTINIOCO]) AS NVARCHAR(MAX)),5,2),'-',RIGHT(CAST(CONVERT(INT,O.[OFDTINIOCO]) AS NVARCHAR(MAX)),2))) DTINIFER
	,CONVERT(DATETIME,CONCAT(LEFT(CAST(CONVERT(INT,O.[OFDTFINOCO]) AS NVARCHAR(MAX)),4),'-',SUBSTRING(CAST(CONVERT(INT,O.[OFDTFINOCO]) AS NVARCHAR(MAX)),5,2),'-',RIGHT(CAST(CONVERT(INT,O.[OFDTFINOCO]) AS NVARCHAR(MAX)),2))) DTFIMFER
	,CONVERT(DATETIME,CONCAT(LEFT(CAST(CONVERT(INT,O.[OFDTHOMRES]) AS NVARCHAR(MAX)),4),'-',SUBSTRING(CAST(CONVERT(INT,O.[OFDTHOMRES]) AS NVARCHAR(MAX)),5,2),'-',RIGHT(CAST(CONVERT(INT,O.[OFDTHOMRES]) AS NVARCHAR(MAX)),2))) DTPGTO
	into #ferias
FROM 
	[OCORFUNC] O INNER JOIN 
	[EMPRESAS] E ON E.EMCODEMP = O.OFCODEMP INNER JOIN
	[FUNCIONA] F ON F.FUCODEMP = O.OFCODEMP AND F.FUMATFUNC = O.OFMATFUNC LEFT JOIN
	[CENCUSTO] C ON C.CCCODEMP = O.OFCODEMP AND F.FUMATFUNC = O.OFMATFUNC AND F.FUCENTRCUS = C.CCCODIGO
where 
	[OFCODOCORR] in (1001) AND 
	[OFCODEMP] NOT IN (1,11,13,16) AND 
	not format(F.FUCODEMP,'000') + FORMAT([FUCPF],'00000000000') in (select distinct keyid from #usufruido) AND
	YEAR(CONVERT(DATETIME,CONCAT(LEFT(CAST(CONVERT(INT,O.[OFDTAUX]) AS NVARCHAR(MAX)),4),'-',SUBSTRING(CAST(CONVERT(INT,O.[OFDTAUX]) AS NVARCHAR(MAX)),5,2),'-',RIGHT(CAST(CONVERT(INT,O.[OFDTAUX]) AS NVARCHAR(MAX)),2)))) >= 2019



SELECT format(F.FUCODEMP,'000') + FORMAT([FUCPF],'00000000000') keyid,
	(SELECT left(EMNOMEMP,11) FROM EMPRESAS WHERE EMCODEMP = F.FUCODEMP) + FORMAT([FUCODEMP],' (00)') EMPRESA
	,FORMAT([FUCPF],'000\.000\.000\-00') CPF
	,[FUNOMFUNC] + FORMAT([FUMATFUNC],' (000)') FUNCIONARIO
	,(SELECT CCDESCRIC FROM CENCUSTO C WHERE C.CCCODEMP = F.FUCODEMP AND C.CCCODIGO = F.FUCENTRCUS) CENTRO_CUSTO
	,(SELECT STDESCSITU FROM FPW5..SITUACAO WHERE STCODSITU = F.[FUCODSITU]) SITUACAO
	,format(CONVERT(DATETIME,CONCAT(LEFT(CAST(CONVERT(INT,F.[FUDTADMIS]) AS NVARCHAR(MAX)),4),'-',SUBSTRING(CAST(CONVERT(INT,F.[FUDTADMIS]) AS NVARCHAR(MAX)),5,2),'-',RIGHT(CAST(CONVERT(INT,F.[FUDTADMIS]) AS NVARCHAR(MAX)),2))),'dd/MM/yyyy') DTADMISSAO
	,format(CONVERT(DATETIME,CONCAT(LEFT(CAST(CONVERT(INT,F.[FUDTINIPAQ]) AS NVARCHAR(MAX)),4),'-',SUBSTRING(CAST(CONVERT(INT,F.[FUDTINIPAQ]) AS NVARCHAR(MAX)),5,2),'-',RIGHT(CAST(CONVERT(INT,F.[FUDTINIPAQ]) AS NVARCHAR(MAX)),2))),'dd/MM/yyyy') INIPERAQ
	,DATEDIFF(DAY,CONVERT(DATETIME,CONCAT(LEFT(CAST(CONVERT(INT,F.[FUDTADMIS]) AS NVARCHAR(MAX)),4),'-',SUBSTRING(CAST(CONVERT(INT,F.[FUDTADMIS]) AS NVARCHAR(MAX)),5,2),'-',RIGHT(CAST(CONVERT(INT,F.[FUDTADMIS]) AS NVARCHAR(MAX)),2))),GETDATE()-1) ATIVO
	,F.[FUDTINIPAQ] chaveordenacao
into #func
FROM 
	[FPW5].[dbo].[FUNCIONA] F
where DATEDIFF(DAY,CONVERT(DATETIME,CONCAT(LEFT(CAST(CONVERT(INT,F.[FUDTADMIS]) AS NVARCHAR(MAX)),4),'-',SUBSTRING(CAST(CONVERT(INT,F.[FUDTADMIS]) AS NVARCHAR(MAX)),5,2),'-',RIGHT(CAST(CONVERT(INT,F.[FUDTADMIS]) AS NVARCHAR(MAX)),2))),GETDATE()-1) > 364 AND
	[FUCODEMP] NOT IN (1,13) AND 
	[FUINDADMISSAO] = 1 AND 
	(SELECT CONCAT(FORMAT(FUCPF,'00000000000'), FORMAT(MAX(FUDTINISIT),'00000000'),FORMAT(MAX(FUDTADMIS),'00000000')) FROM FPW5..FUNCIONA WHERE FUCPF = F.FUCPF GROUP BY FUCPF) = CONCAT(FORMAT(FUCPF,'00000000000'),FORMAT((FUDTINISIT),'00000000'),FORMAT((FUDTADMIS),'00000000')) AND
	[FUCODSITU] IN (SELECT STCODSITU FROM FPW5..SITUACAO WHERE NOT (STDESCSITU LIKE '%transf%' OR STDESCSITU LIKE '%RESC%' OR STDESCSITU LIKE '%TERM%'  OR STDESCSITU LIKE '%SUSP%' OR STDESCSITU LIKE '%ESTAG%'))
	ORDER BY DATEDIFF(DAY,CONVERT(DATETIME,CONCAT(LEFT(CAST(CONVERT(INT,F.[FUDTADMIS]) AS NVARCHAR(MAX)),4),'-',SUBSTRING(CAST(CONVERT(INT,F.[FUDTADMIS]) AS NVARCHAR(MAX)),5,2),'-',RIGHT(CAST(CONVERT(INT,F.[FUDTADMIS]) AS NVARCHAR(MAX)),2))),GETDATE()) DESC


select 
	fu.EMPRESA,
	FU.CPF,
	FU.FUNCIONARIO,
	FU.CENTRO_CUSTO,
	FU.SITUACAO,
	COALESCE(FE.SALDO,30) SALDO,
	FU.DTADMISSAO,
	FU.INIPERAQ, 
	FORMAT(convert(datetime,concat(right(FU.INIPERAQ,4),'-',substring(FU.INIPERAQ,4,2),'-',left(FU.INIPERAQ,2))) + 364,'dd/MM/yyyy') FIMPERAQ ,
	format(convert(datetime,concat(right(FU.INIPERAQ,4),'-',substring(FU.INIPERAQ,4,2),'-',left(FU.INIPERAQ,2))) + (364 * 2) - 30,'dd/MM/yyyy') DTLIMITE, 
	format(coalesce(FE.DTINIFER,''),'dd/MM/yyyy') DTINIFER,
	format(coalesce(FE.DTFIMFER,''),'dd/MM/yyyy') DTFIMFER,
	format(coalesce(FE.DTPGTO,''),'dd/MM/yyyy') DTPGTO, 
	fu.chaveordenacao
into #dpfinal
from #func fu left join #ferias fe on fe.keyid = fu.keyid
WHERE not fu.keyid in (select distinct keyid from #usufruido) and convert(datetime,concat(right(FU.INIPERAQ,4),'-',substring(FU.INIPERAQ,4,2),'-',left(FU.INIPERAQ,2))) <= GETDATE()-(364 + 1)

select 
	concat('id',ROW_NUMBER() OVER (ORDER BY chaveordenacao) % 2) ID,
	EMPRESA,
	CPF,
	FUNCIONARIO,
	left(CENTRO_CUSTO,15) CENTRO_CUSTO,
	left(SITUACAO,10) SITUACAO,
	SALDO,
	DTADMISSAO,
	iif(INIPERAQ = '01/01/1900','',INIPERAQ) INIPERAQ, 
	iif(FIMPERAQ = '01/01/1900','',FIMPERAQ) FIMPERAQ, 
	iif(DTLIMITE = '01/01/1900','',DTLIMITE) DTLIMITE, 
	iif(DTINIFER = '01/01/1900','',DTINIFER) DTINIFER, 
	iif(DTFIMFER = '01/01/1900','',DTFIMFER) DTFIMFER, 
	iif(DTPGTO = '01/01/1900','',DTPGTO) DTPGTO, 
	chaveordenacao
into #html
from
	#dpfinal
order by
	chaveordenacao

--select * from #html order by chaveordenacao

--========= FORMATACAO HTML PARA ENVIO POR E-MAIL =========

SET @body = N'<!DOCTYPE html><html><head>

<style>

	#id0 { background-color: rgb(255, 255, 255); }
	#id1 { background-color: rgb(255, 222, 255); }
table {
  border-collapse: separate;
  border-spacing: 0;
  color: #4a4a4d;
  font: 14px/1.4 "Helvetica Neue", Helvetica, Arial, sans-serif;
}
th,
td {
  padding: 10px 15px;
  vertical-align: middle;
}
caption {
  background: #395870;
  background: linear-gradient(#49708f, #293f50);
  color: #fff;
  font-size: 20px;
  font-weight: bold;
  text-transform: uppercase;
}

thead {
  background: #395870;
  background: linear-gradient(#49708f, #293f50);
  color: #fff;
  font-size: 11px;
  text-transform: uppercase;
}
th:first-child {
  border-top-left-radius: 5px;
  text-align: left;
}
th:last-child {
  border-top-right-radius: 5px;
}
tbody tr:nth-child(even) {
  background: #f0f0f2;
}
td {
  border-bottom: 1px solid #cecfd5;
  border-right: 1px solid #cecfd5;
}
td:first-child {
  border-left: 111px solid #cecfd5;
}

tfoot {
  text-align: right;
}
tfoot tr:last-child {
  background: #f0f0f2;
  color: #395870;
  font-weight: bold;
}
tfoot tr:last-child td:first-child {
  border-bottom-left-radius: 5px;
}
tfoot tr:last-child td:last-child {
  border-bottom-right-radius: 5px;
}
  
</style>

<title>PROGRAMACAO DE FERIAS DP</title>
</head><body>

<table align="center" cellpadding="5" cols="12" frame="vsides" rules="rows" width="90%" style="font-family:Arial, Helvetica, sans-serif;font-size:60%">
		<caption>PROGRAMACAO DE FERIAS DP ' + CONCAT('- ',(@mesextenso),'/',YEAR(GETDATE())) + '</caption>
		<thead>
			<tr> 
			<th>EMPRESA</th>
			<th>FUNCIONARIO</th>
			<th>CENTRO_CUSTO</th>
			<th>SALDO</th>
			<th>DTADMISSAO</th>
			<th>INIPERAQ</th>
			<th>FIMPERAQ</th>
			<th>DTLIMITE</th>
			<th>DTINIFE</th>
			<th>DTFIMFE</th>
			<th>DTPGT</th>
			<th>#ID</th>
			</tr>
		</thead>
		<tbody>' + (
    
			SELECT	
				[@id] = [ID],
				td = [EMPRESA], '',[td/@align]='left',
				td = [FUNCIONARIO], '',[td/@align]='left',
				td = [CENTRO_CUSTO], '',[td/@align]='center',
				td = [SALDO], '',[td/@align]='center',
				td = [DTADMISSAO], '',[td/@align]='center',
				td = [INIPERAQ], '',[td/@align]='center',
				td = [FIMPERAQ], '',[td/@align]='center',
				td = [DTLIMITE], '',[td/@align]='center',
				td = [DTINIFER], '',[td/@align]='center',
				td = [DTFIMFER], '',[td/@align]='center',
				td = [DTPGTO], '',[td/@align]='center',
				td = ROW_NUMBER() OVER (ORDER BY chaveordenacao)
            FROM #html
			ORDER BY chaveordenacao
			FOR XML PATH('tr') )
			+ '</tbody>'


SET @body = @body + '</table><p align="center" style="font-family:Arial, Helvetica, sans-serif;font-size:60%;font-weight:bold">@copyright 2020    |    EQUIPE TECNOLOGIA    |    GERADO EM ' + FORMAT(SYSDATETIME(),'dd.MM.yyyy hh:mm') + '</p></body></html>';
SET @subj = N'PROGRAMACAO DE FERIAS DP ' + CONCAT('EM ',(@mesextenso),'/',YEAR(GETDATE()));

EXEC msdb.dbo.sp_send_dbmail
    	@recipients=N'rodrigo.matos@nutriex.com.br',
	@copy_recipients=N'janila.torres@nutriex.com.br;camila.vaz@nutriex.com.br',
	--@blind_copy_recipients=N'junior.nunes@eficienciacont.com.br',
	@body = @body,
	@body_format = 'HTML',
	@subject = @subj,
	@profile_name = 'NutriexReports';