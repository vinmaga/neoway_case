SELECT 
    distinct 
    a.cnpj
    ,count(distinct b.nome_normalizado_neoway) as partes_envolvidas_por_cnpj
FROM 
    {{ ref('empresas_judicializacao_geral') }} as a
    LEFT JOIN {{ ref('empresas_judicializacao_partes') }} b on a.cd_processo = b.cd_processo
group by 
    a.cnpj
