SELECT 
    distinct 
    a.cd_processo
    ,COUNT(CASE WHEN polo = 'ativo' THEN 1 END) AS contagem_partes_ativo
    ,COUNT(CASE WHEN polo = 'passivo' THEN 1 END) AS contagem_partes_passivo
FROM 
    {{ ref('empresas_judicializacao_partes') }} as a
group by 
    a.cd_processo
