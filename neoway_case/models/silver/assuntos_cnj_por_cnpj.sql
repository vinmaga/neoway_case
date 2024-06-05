SELECT 
    distinct 
    a.cnpj
    ,count(distinct b.codigo_cnj) as assuntos_distintos_por_cnpj
FROM 
    {{ ref('empresas_judicializacao_geral') }} as a
    LEFT JOIN {{ ref('empresas_judicializacao_assuntos_cnj') }} b on a.cd_processo = b.cd_processo
group by 
    a.cnpj

