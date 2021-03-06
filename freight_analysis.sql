select 
	'SBOA7' BASE
	,COALESCE(e.empresa,o.bplname) EMPRESA, case when oprennova = 1 then 'RENNOVA' WHEN SUPERVISOR = 'LICITACAO' THEN 'LICITACAO' ELSE 'NUTRIEX' END OPERACAO
	,format(o.docdate,'yyyy/MM') PERIODO
	,e.transportadora TRANSPORTADORA
	,o.serial NFNUM
	,coalesce('GO >> ' + upper(e.cidade) + '_' + e.estado,'GO >> ' + o.address) TRECHO, case when o.comments like '%aereo%' then 'AEREO' ELSE 'RODOVIARIO' END MODAL
	,case when e.volume = 0 then 1 else e.volume end VOLUME
	,CAST(case when e.peso = 0 then coalesce(e.pesocubado,0) else coalesce(e.peso,0) end AS FLOAT) PESO
	,CAST(COALESCE(e.valorfretereal,e.valorfrete) AS FLOAT) VLRFRETE
	,CAST(o.max1099 AS FLOAT) VLRNF
from
	SBOA7..oinv o left join [DBMilenioWMS].[dbo].[ObtemRelatorioEmbarcador] e ON o.docentry = e.[IdNotaFiscal]
where 
	year(o.docdate) = 2020  and e.TipoFrete not like 'interno' and e.cidade is not null and (coalesce(e.valorfretereal,0) + coalesce(e.valorfrete,0)) > 0  and o.canceled = 'N' and e.dbnome = 'SBOA7'
 

UNION ALL

select 
	'SBODL' BASE
	,COALESCE(e.empresa,'DL Distribuidora') EMPRESA, case when oprennova = 1 then 'RENNOVA' WHEN SUPERVISOR = 'LICITACAO' THEN 'LICITACAO' ELSE 'NUTRIEX' END OPERACAO
	,format(o.docdate,'yyyy/MM') PERIODO
	,e.transportadora TRANSPORTADORA
	,o.serial NFNUM
	,coalesce('GO >> ' + upper(e.cidade) + '_' + e.estado,'GO >> ' + o.address) TRECHO, case when o.comments like '%aereo%' then 'AEREO' ELSE 'RODOVIARIO' END MODAL
	,case when e.volume = 0 then 1 else e.volume end VOLUME
	,CAST(case when e.peso = 0 then coalesce(e.pesocubado,0) else coalesce(e.peso,0) end AS FLOAT) PESO
	,CAST(COALESCE(e.valorfretereal,e.valorfrete) AS FLOAT) VLRFRETE
	,CAST(o.max1099 AS FLOAT) VLRNF
from
	SBODL..oinv o left join [DBMilenioWMS].[dbo].[ObtemRelatorioEmbarcador] e ON o.docentry = e.[IdNotaFiscal]
where 
	year(o.docdate) = 2020  and e.TipoFrete not like 'interno' and e.cidade is not null and (coalesce(e.valorfretereal,0) + coalesce(e.valorfrete,0)) > 0  and o.canceled = 'N' and e.dbnome = 'SBODL' 
 

UNION ALL

select 
	'SBOEquilibrium' BASE
	,COALESCE(e.empresa,o.bplname) EMPRESA, case when oprennova = 1 then 'RENNOVA' WHEN SUPERVISOR = 'LICITACAO' THEN 'LICITACAO' ELSE 'NUTRIEX' END OPERACAO
	,format(o.docdate,'yyyy/MM') PERIODO
	,e.transportadora TRANSPORTADORA
	,o.serial NFNUM
	,coalesce('GO >> ' + upper(e.cidade) + '_' + e.estado,'GO >> ' + o.address) TRECHO, case when o.comments like '%aereo%' then 'AEREO' ELSE 'RODOVIARIO' END MODAL
	,case when e.volume = 0 then 1 else e.volume end VOLUME
	,CAST(case when e.peso = 0 then coalesce(e.pesocubado,0) else coalesce(e.peso,0) end AS FLOAT) PESO
	,CAST(COALESCE(e.valorfretereal,e.valorfrete) AS FLOAT) VLRFRETE
	,CAST(o.max1099 AS FLOAT) VLRNF
from
	SBOEquilibrium..oinv o left join [DBMilenioWMS].[dbo].[ObtemRelatorioEmbarcador] e ON o.docentry = e.[IdNotaFiscal]
where 
	year(o.docdate) = 2020  and e.TipoFrete not like 'interno' and e.cidade is not null and (coalesce(e.valorfretereal,0) + coalesce(e.valorfrete,0)) > 0  and o.canceled = 'N' and e.dbnome = 'SBOEquilibrium' 
 

UNION ALL

select 
	'SBOGDSMARCAS' BASE
	,COALESCE(e.empresa,o.bplname) EMPRESA, case when oprennova = 1 then 'RENNOVA' WHEN SUPERVISOR = 'LICITACAO' THEN 'LICITACAO' ELSE 'NUTRIEX' END OPERACAO
	,format(o.docdate,'yyyy/MM') PERIODO
	,e.transportadora TRANSPORTADORA
	,o.serial NFNUM
	,coalesce('GO >> ' + upper(e.cidade) + '_' + e.estado,'GO >> ' + o.address) TRECHO, case when o.comments like '%aereo%' then 'AEREO' ELSE 'RODOVIARIO' END MODAL
	,case when e.volume = 0 then 1 else e.volume end VOLUME
	,CAST(case when e.peso = 0 then coalesce(e.pesocubado,0) else coalesce(e.peso,0) end AS FLOAT) PESO
	,CAST(COALESCE(e.valorfretereal,e.valorfrete) AS FLOAT) VLRFRETE
	,CAST(o.max1099 AS FLOAT) VLRNF
from
	SBOGDSMARCAS..oinv o left join [DBMilenioWMS].[dbo].[ObtemRelatorioEmbarcador] e ON o.docentry = e.[IdNotaFiscal]
where 
	year(o.docdate) = 2020  and e.TipoFrete not like 'interno' and e.cidade is not null and (coalesce(e.valorfretereal,0) + coalesce(e.valorfrete,0)) > 0  and o.canceled = 'N' and e.dbnome = 'SBOGDSMARCAS' 
 

UNION ALL

select 
	'SBOMW' BASE
	,COALESCE(e.empresa,o.bplname) EMPRESA, case when oprennova = 1 then 'RENNOVA' WHEN SUPERVISOR = 'LICITACAO' THEN 'LICITACAO' ELSE 'NUTRIEX' END OPERACAO
	,format(o.docdate,'yyyy/MM') PERIODO
	,e.transportadora TRANSPORTADORA
	,o.serial NFNUM
	,coalesce('GO >> ' + upper(e.cidade) + '_' + e.estado,'GO >> ' + o.address) TRECHO, case when o.comments like '%aereo%' then 'AEREO' ELSE 'RODOVIARIO' END MODAL
	,case when e.volume = 0 then 1 else e.volume end VOLUME
	,CAST(case when e.peso = 0 then coalesce(e.pesocubado,0) else coalesce(e.peso,0) end AS FLOAT) PESO
	,CAST(COALESCE(e.valorfretereal,e.valorfrete) AS FLOAT) VLRFRETE
	,CAST(o.max1099 AS FLOAT) VLRNF
from
	SBOMW..oinv o left join [DBMilenioWMS].[dbo].[ObtemRelatorioEmbarcador] e ON o.docentry = e.[IdNotaFiscal]
where 
	year(o.docdate) = 2020  and e.TipoFrete not like 'interno' and e.cidade is not null and (coalesce(e.valorfretereal,0) + coalesce(e.valorfrete,0)) > 0  and o.canceled = 'N' and e.dbnome = 'SBOMW' 
 

UNION ALL

select 
	'SBONutGynMatriz' BASE
	,COALESCE(e.empresa,o.bplname) EMPRESA, case when oprennova = 1 then 'RENNOVA' WHEN SUPERVISOR = 'LICITACAO' THEN 'LICITACAO' ELSE 'NUTRIEX' END OPERACAO
	,format(o.docdate,'yyyy/MM') PERIODO
	,e.transportadora TRANSPORTADORA
	,o.serial NFNUM
	,coalesce('GO >> ' + upper(e.cidade) + '_' + e.estado,'GO >> ' + o.address) TRECHO, case when o.comments like '%aereo%' then 'AEREO' ELSE 'RODOVIARIO' END MODAL
	,case when e.volume = 0 then 1 else e.volume end VOLUME
	,CAST(case when e.peso = 0 then coalesce(e.pesocubado,0) else coalesce(e.peso,0) end AS FLOAT) PESO
	,CAST(COALESCE(e.valorfretereal,e.valorfrete) AS FLOAT) VLRFRETE
	,CAST(o.max1099 AS FLOAT) VLRNF
from
	SBONutGynMatriz..oinv o left join [DBMilenioWMS].[dbo].[ObtemRelatorioEmbarcador] e ON o.docentry = e.[IdNotaFiscal]
where 
	year(o.docdate) = 2020  and e.TipoFrete not like 'interno' and e.cidade is not null and (coalesce(e.valorfretereal,0) + coalesce(e.valorfrete,0)) > 0  and o.canceled = 'N' and e.dbnome = 'SBONutGynMatriz' 
 

UNION ALL

select 
	'SBONutriexInd' BASE
	,COALESCE(e.empresa,'Nutriex  Cosmética') EMPRESA, case when oprennova = 1 then 'RENNOVA' WHEN SUPERVISOR = 'LICITACAO' THEN 'LICITACAO' ELSE 'NUTRIEX' END OPERACAO
	,format(o.docdate,'yyyy/MM') PERIODO
	,e.transportadora TRANSPORTADORA
	,o.serial NFNUM
	,coalesce('GO >> ' + upper(e.cidade) + '_' + e.estado,'GO >> ' + o.address) TRECHO, case when o.comments like '%aereo%' then 'AEREO' ELSE 'RODOVIARIO' END MODAL
	,case when e.volume = 0 then 1 else e.volume end VOLUME
	,CAST(case when e.peso = 0 then coalesce(e.pesocubado,0) else coalesce(e.peso,0) end AS FLOAT) PESO
	,CAST(COALESCE(e.valorfretereal,e.valorfrete) AS FLOAT) VLRFRETE
	,CAST(o.max1099 AS FLOAT) VLRNF
from
	SBONutriexInd..oinv o left join [DBMilenioWMS].[dbo].[ObtemRelatorioEmbarcador] e ON o.docentry = e.[IdNotaFiscal]
where 
	year(o.docdate) = 2020  and e.TipoFrete not like 'interno' and e.cidade is not null and (coalesce(e.valorfretereal,0) + coalesce(e.valorfrete,0)) > 0  and o.canceled = 'N' and e.dbnome = 'SBONutriexInd' 
 

UNION ALL

select 
	'SBOVidafarma' BASE
	,COALESCE(e.empresa,o.bplname) EMPRESA, case when oprennova = 1 then 'RENNOVA' WHEN SUPERVISOR = 'LICITACAO' THEN 'LICITACAO' ELSE 'NUTRIEX' END OPERACAO
	,format(o.docdate,'yyyy/MM') PERIODO
	,e.transportadora TRANSPORTADORA
	,o.serial NFNUM
	,coalesce('GO >> ' + upper(e.cidade) + '_' + e.estado,'GO >> ' + o.address) TRECHO, case when o.comments like '%aereo%' then 'AEREO' ELSE 'RODOVIARIO' END MODAL
	,case when e.volume = 0 then 1 else e.volume end VOLUME
	,CAST(case when e.peso = 0 then coalesce(e.pesocubado,0) else coalesce(e.peso,0) end AS FLOAT) PESO
	,CAST(COALESCE(e.valorfretereal,e.valorfrete) AS FLOAT) VLRFRETE
	,CAST(o.max1099 AS FLOAT) VLRNF
from
	SBOVidafarma..oinv o left join [DBMilenioWMS].[dbo].[ObtemRelatorioEmbarcador] e ON o.docentry = e.[IdNotaFiscal]
where 
	year(o.docdate) = 2020  and e.TipoFrete not like 'interno' and e.cidade is not null and (coalesce(e.valorfretereal,0) + coalesce(e.valorfrete,0)) > 0  and o.canceled = 'N' and e.dbnome = 'SBOVidafarma' 
 

UNION ALL

select 
	'SboInnovaLab' BASE
	,COALESCE(e.empresa,'Innovapharma  Lab.e Manipulação Ltda') EMPRESA, case when oprennova = 1 then 'RENNOVA' WHEN SUPERVISOR = 'LICITACAO' THEN 'LICITACAO' ELSE 'NUTRIEX' END OPERACAO
	,format(o.docdate,'yyyy/MM') PERIODO
	,e.transportadora TRANSPORTADORA
	,o.serial NFNUM
	,coalesce('GO >> ' + upper(e.cidade) + '_' + e.estado,'GO >> ' + o.address) TRECHO, case when o.comments like '%aereo%' then 'AEREO' ELSE 'RODOVIARIO' END MODAL
	,case when e.volume = 0 then 1 else e.volume end VOLUME
	,CAST(case when e.peso = 0 then coalesce(e.pesocubado,0) else coalesce(e.peso,0) end AS FLOAT) PESO
	,CAST(COALESCE(e.valorfretereal,e.valorfrete) AS FLOAT) VLRFRETE
	,CAST(o.max1099 AS FLOAT) VLRNF
from
	SboInnovaLab..oinv o left join [DBMilenioWMS].[dbo].[ObtemRelatorioEmbarcador] e ON o.docentry = e.[IdNotaFiscal]
where 
	year(o.docdate) = 2020  and e.TipoFrete not like 'interno' and e.cidade is not null and (coalesce(e.valorfretereal,0) + coalesce(e.valorfrete,0)) > 0  and o.canceled = 'N' and e.dbnome = 'SboInnovaLab'