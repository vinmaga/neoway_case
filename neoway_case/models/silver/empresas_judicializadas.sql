{{ config(alias='empresas_judicializadas') }}

SELECT DISTINCT 
    cnpj
    ,count(distinct a.cd_processo) contagem_processos
    ,COUNT(DISTINCT CASE WHEN a.dt_data_decisao IS NULL THEN a.cd_processo ELSE NULL END) AS contagem_processos_sem_decisao
    -- ,count(DISTINCT b.nome_normalizado_neoway) total_partes_envolvidas
    -- ,count(distinct c.codigo_cnj) total_assuntos_cnj
    ,count(distinct uf) processos_ufs_distintas
    ,round(sum(valor_causa), 1) soma_valor_causas
    ,round(avg(valor_causa), 1) media_valor_causas
    ,round(sum(valor_predicao_condenacao), 1) soma_valor_predito
    ,round(avg(valor_predicao_condenacao), 1) media_valor_predito
    ,min(dt_data_decisao) data_primeira_decisao
    ,max(dt_data_decisao) data_ultima_decisao
    ,CAST(AVG(DATE_DIFF(a.dt_data_encerramento, a.dt_data_decisao, DAY)) as int) AS media_dias_decisao_encerramento

FROM
    {{ ref('empresas_judicializacao_geral') }} a
    -- LEFT JOIN {{ ref('empresas_judicializacao_partes') }} b on a.cd_processo = b.cd_processo
    -- LEFT JOIN {{ ref('empresas_judicializacao_assuntos_cnj') }} c on a.cd_processo = c.cd_processo

GROUP BY 
    cnpj

ORDER BY 
    soma_valor_predito desc
