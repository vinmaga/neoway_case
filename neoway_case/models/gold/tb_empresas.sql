{{ config(alias='tb_empresas') }}

SELECT
    a.cnpj
    ,a.dt_abertura
    ,CASE 
        WHEN a.empresa_matriz THEN 'SIM'
        ELSE 'NAO'
    END AS empresa_matriz
    ,a.cd_cnae_principal
    ,a.endereco_cep AS cep
    ,COALESCE(b.nivel_atividade, 'NAO INFORMADO') AS nivel_atividade
    ,COALESCE(c.empresa_porte, 'NAO INFORMADO') AS porte
    ,COALESCE(d.saude_tributaria, 'NAO INFORMADO') AS saude_tributaria
    ,COALESCE(e.optante_simples, 'NAO INFORMADO') AS optante_simples
    ,COALESCE(e.optante_simei, 'NAO INFORMADO') AS optante_simei
    ,COALESCE(f.contagem_processos, 0) AS contagem_processos
    ,COALESCE(f.contagem_processos_sem_decisao, 0) AS contagem_processos_sem_decisao
    ,COALESCE(h.partes_envolvidas_por_cnpj, 0) AS total_partes_envolvidas_por_cnpj
    ,COALESCE(g.assuntos_distintos_por_cnpj, 0) AS assuntos_distintos_por_cnpj
    ,COALESCE(f.processos_ufs_distintas, 0) AS processos_ufs_distintas
    ,COALESCE(f.soma_valor_causas, 0) AS soma_valor_causas
    ,COALESCE(f.media_valor_causas, 0) AS media_valor_causas
    ,COALESCE(f.soma_valor_predito, 0) AS soma_valor_predito
    ,COALESCE(f.media_valor_predito, 0) AS media_valor_predito
    ,COALESCE(f.data_primeira_decisao, null) AS data_primeira_decisao
    ,COALESCE(f.data_ultima_decisao, null) AS data_ultima_decisao
    ,COALESCE(f.media_dias_decisao_encerramento, 0) AS media_dias_decisao_encerramento

FROM
    {{ ref('empresas_geral') }} AS a
    LEFT JOIN {{ ref('empresas_nivel_atividade') }} AS b ON a.cnpj = b.cnpj
    LEFT JOIN {{ ref('empresas_porte') }} AS c ON a.cnpj = c.cnpj
    LEFT JOIN {{ ref('empresas_saude_tributaria') }} AS d ON a.cnpj = d.cnpj
    LEFT JOIN {{ ref('empresas_simples') }} AS e ON a.cnpj = e.cnpj
    LEFT JOIN {{ ref('empresas_judicializadas') }} AS f ON a.cnpj = f.cnpj
    LEFT JOIN {{ ref('assuntos_cnj_por_cnpj') }} AS g ON a.cnpj = g.cnpj
    LEFT JOIN {{ ref('partes_envolvidas_por_cnpj') }} AS h ON a.cnpj = h.cnpj