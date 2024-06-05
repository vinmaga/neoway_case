SELECT
    a.cd_processo
    ,a.cnpj
    ,a.area
    ,CASE 
        WHEN grau_processo = '1' THEN '1º Grau'
        WHEN grau_processo = '2' THEN '2º Grau'
    END AS grau_processo_harmonizado
    ,CASE 
        WHEN julgamento IN ('Sem decisão', 'Não identificado') THEN 'Sem decisão ou Não identificado'
        WHEN julgamento IN ('Procedência', 'Provimento', 'Provimento em Parte', 'Procedência em Parte', 'Procedência em parte do pedido e procedência em parte do pedido contraposto') THEN 'Procedência total ou parcial'
        WHEN julgamento IN ('Improcedência', 'Improcedência do pedido e procedência do pedido contraposto', 'Improcedência do pedido e improcedência do pedido contraposto') THEN 'Improcedência'
        WHEN julgamento IN ('Extinto sem resolução de mérito', 'Recurso prejudicado', 'Negação de seguimento') THEN 'Resolução Sem Mérito'
        WHEN julgamento = 'Acordo homologado' THEN 'Acordo'
        WHEN julgamento = 'Desistência' THEN 'Desistência'
        ELSE 'Outros'
    END AS julgamento_harmonizado
    ,CASE 
        WHEN tribunal LIKE 'TJ%' THEN 'Tribunal de Justiça (TJ)'
        WHEN tribunal LIKE 'TRT%' THEN 'Tribunal Regional do Trabalho (TRT)'
        WHEN tribunal LIKE 'TRF%' THEN 'Tribunal Regional Federal (TRF)'
        WHEN tribunal LIKE 'JF%' THEN 'Justiça Federal (JF)'
        ELSE 'Outros'
    END AS tribunal_harmonizado
    ,a.citacao_tipo
    ,a.juiz
    ,round(a.valor_causa,1) valor_causa
    ,round(a.valor_predicao_condenacao,1) valor_predicao_condenacao
    ,a.contagem_partes
    ,a.contagem_assuntos_cnj
    ,a.dt_data_decisao
    ,a.dt_data_encerramento
    ,DATE_DIFF(a.dt_data_encerramento, a.dt_data_decisao, DAY) dias_decisao_encerramento
    ,uf
    ,municipio
    ,b.contagem_partes_ativo
    ,b.contagem_partes_passivo
    ,ROUND(CAST(a.valor_causa AS FLOAT64) / NULLIF(CAST(b.contagem_partes_ativo AS FLOAT64), 0), 1) AS valor_causa_por_partes
    ,ROUND(CAST(a.valor_predicao_condenacao AS FLOAT64) / NULLIF(CAST(b.contagem_partes_ativo AS FLOAT64), 0), 1) AS valor_predito_por_partes
FROM
    {{ ref('empresas_judicializacao_geral') }} a
    LEFT join {{ ref('polos_por_processo') }} b on a.cd_processo = b.cd_processo