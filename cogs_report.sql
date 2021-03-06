select
'EQL' AS BASE,
t0.transnum AS TRANSACAO, 
T0.BASE_REF AS SAPNUM,
CASE
	WHEN t0.transtype = '13' THEN 'NF SAIDA'
	WHEN t0.transtype = '14' THEN 'DEVOL. NF SAIDA'
	WHEN t0.transtype = '18' THEN 'NF COMPRA'
	WHEN t0.transtype = '19' THEN 'DEVOL. NF COMPRA'
	WHEN t0.transtype = '30' THEN 'LANÇAMENTO CONT. MANUAL'
	ELSE CAST(t0.transtype AS nvarchar)
END AS TIPO,
CAST(t0.docdate AS DATE) AS DATA,
FORMAT(t0.docdate,'yyyy/MM') AS PERIODO,
t0.ItemCode AS ITEMCOD,
t0.dscription AS ITEMNOME, 
CAST(t0.inqty AS FLOAT) AS QTDEENT, 
CAST(t0.outqty AS FLOAT) AS QTDESAI, 
CAST(t0.price AS FLOAT) AS VLRVENDA, 
CAST(t0.calcprice AS FLOAT) AS VLRCUSTO, 
CAST(t0.CogsVal AS FLOAT) AS CogsVal, 
CAST(t0.transvalue AS FLOAT) AS VARIACAO, 
T0.COSTACT AS CONTACOD,
T1.ACCTNAME AS CONTADESC,
t0.warehouse AS DEPOSITO,
(CASE WHEN T0.JRNLMEMO LIKE '%CANCELA%' THEN 'S' ELSE 'N' END) AS CANCELADA
from 
SBOEQUILIBRIUM..oinm t0 INNER JOIN SBOEQUILIBRIUM..OACT t1 ON T1.ACCTCODE = T0.COSTACT
WHERE YEAR(T0.DOCDATE) = 2020 AND (T0.TRANSTYPE = 13 OR T0.TRANSTYPE = 14 OR T0.TRANSTYPE = 30) AND t0.warehouse LIKE 'IN%' AND (MONTH(T0.DOCDATE) >= 4 AND MONTH(T0.DOCDATE) <=6)

UNION

select
'VDM' AS BASE,
t0.transnum AS TRANSACAO, 
T0.BASE_REF AS SAPNUM,
CASE
	WHEN t0.transtype = '13' THEN 'NF SAIDA'
	WHEN t0.transtype = '14' THEN 'DEVOL. NF SAIDA'
	WHEN t0.transtype = '18' THEN 'NF COMPRA'
	WHEN t0.transtype = '19' THEN 'DEVOL. NF COMPRA'
	WHEN t0.transtype = '30' THEN 'LANÇAMENTO CONT. MANUAL'
	ELSE CAST(t0.transtype AS nvarchar)
END AS TIPO,
CAST(t0.docdate AS DATE) AS DATA,
FORMAT(t0.docdate,'yyyy/MM') AS PERIODO,
t0.ItemCode AS ITEMCOD,
t0.dscription AS ITEMNOME, 
CAST(t0.inqty AS FLOAT) AS QTDEENT, 
CAST(t0.outqty AS FLOAT) AS QTDESAI, 
CAST(t0.price AS FLOAT) AS VLRVENDA, 
CAST(t0.calcprice AS FLOAT) AS VLRCUSTO, 
CAST(t0.CogsVal AS FLOAT) AS CogsVal, 
CAST(t0.transvalue AS FLOAT) AS VARIACAO, 
T0.COSTACT AS CONTACOD,
T1.ACCTNAME AS CONTADESC,
t0.warehouse AS DEPOSITO,
(CASE WHEN T0.JRNLMEMO LIKE '%CANCELA%' THEN 'S' ELSE 'N' END) AS CANCELADA
from 
SBOVIDAFARMA..oinm t0 INNER JOIN SBOVIDAFARMA..OACT t1 ON T1.ACCTCODE = T0.COSTACT
WHERE YEAR(T0.DOCDATE) = 2020 AND (T0.TRANSTYPE = 13 OR T0.TRANSTYPE = 14 OR T0.TRANSTYPE = 30) AND (MONTH(T0.DOCDATE) >= 4 AND MONTH(T0.DOCDATE) <=6)

UNION


select
'LAB' AS BASE,
t0.transnum AS TRANSACAO, 
T0.BASE_REF AS SAPNUM,
CASE
	WHEN t0.transtype = '13' THEN 'NF SAIDA'
	WHEN t0.transtype = '14' THEN 'DEVOL. NF SAIDA'
	WHEN t0.transtype = '18' THEN 'NF COMPRA'
	WHEN t0.transtype = '19' THEN 'DEVOL. NF COMPRA'
	WHEN t0.transtype = '30' THEN 'LANÇAMENTO CONT. MANUAL'
	ELSE CAST(t0.transtype AS nvarchar)
END AS TIPO,
CAST(t0.docdate AS DATE) AS DATA,
FORMAT(t0.docdate,'yyyy/MM') AS PERIODO,
t0.ItemCode AS ITEMCOD,
t0.dscription AS ITEMNOME, 
CAST(t0.inqty AS FLOAT) AS QTDEENT, 
CAST(t0.outqty AS FLOAT) AS QTDESAI, 
CAST(t0.price AS FLOAT) AS VLRVENDA, 
CAST(t0.calcprice AS FLOAT) AS VLRCUSTO, 
CAST(t0.CogsVal AS FLOAT) AS CogsVal, 
CAST(t0.transvalue AS FLOAT) AS VARIACAO, 
T0.COSTACT AS CONTACOD,
T1.ACCTNAME AS CONTADESC,
t0.warehouse AS DEPOSITO,
(CASE WHEN T0.JRNLMEMO LIKE '%CANCELA%' THEN 'S' ELSE 'N' END) AS CANCELADA
from 
SboInnovaLab..oinm t0 INNER JOIN SboInnovaLab..OACT t1 ON T1.ACCTCODE = T0.COSTACT
WHERE YEAR(T0.DOCDATE) = 2020 AND (T0.TRANSTYPE = 13 OR T0.TRANSTYPE = 14 OR T0.TRANSTYPE = 30) AND (MONTH(T0.DOCDATE) >= 4 AND MONTH(T0.DOCDATE) <=6)
