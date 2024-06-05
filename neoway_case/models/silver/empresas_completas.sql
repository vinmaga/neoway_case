{{ config(alias='empresas_completas') }}

SELECT
    CAST(a.cnpj AS STRING) AS cnpj
    ,CAST(a.dt_abertura AS STRING) AS dt_abertura
    ,CAST(a.empresa_matriz AS BOOL) AS empresa_matriz
    ,CAST(a.cd_cnae_principal AS INT64) AS cd_cnae_principal
    ,CAST(tb_cnae.de_cnae_principal AS STRING) AS cnae_principal
    ,CAST(tb_cnae.de_ramo_atividade AS STRING) AS ramo_atividade
    ,CAST(tb_cnae.de_setor AS STRING) AS setor
    ,CAST(a.endereco_cep AS STRING) AS endereco_cep
    ,CAST(tb_cep.endereco_municipio AS STRING) AS municipio
    ,CAST(tb_cep.endereco_uf AS STRING) AS uf
    ,CAST(tb_cep.endereco_regiao AS STRING) AS regiao
    ,CAST(tb_cep.endereco_mesorregiao AS STRING) AS mesorregiao
    ,CAST(a.situacao_cadastral AS STRING) AS situacao_cadastral
    ,CAST(b.nivel_atividade AS STRING) AS nivel_atividade
    ,CAST(c.empresa_porte AS STRING) AS porte
    ,CAST(d.saude_tributaria AS STRING) AS saude_tributaria
    ,CAST(e.optante_simples AS STRING) AS optante_simples
    ,CAST(e.optante_simei AS STRING) AS optante_simei
FROM
    {{ ref('empresas_geral') }} AS a
    JOIN {{ ref('dim_ceps') }} AS tb_cep ON CAST(a.endereco_cep AS STRING) = CAST(tb_cep.endereco_cep AS STRING)
    JOIN {{ ref('dim_cnaes') }} AS tb_cnae ON CAST(a.cd_cnae_principal AS INT64) = CAST(tb_cnae.cd_cnae_principal AS INT64)
    JOIN {{ ref('empresas_nivel_atividade') }} AS b ON CAST(a.cnpj AS STRING) = CAST(b.cnpj AS STRING)
    JOIN {{ ref('empresas_porte') }} AS c ON CAST(a.cnpj AS STRING) = CAST(c.cnpj AS STRING)
    JOIN {{ ref('empresas_saude_tributaria') }} AS d ON CAST(a.cnpj AS STRING) = CAST(d.cnpj AS STRING)
    JOIN {{ ref('empresas_simples') }} AS e ON CAST(a.cnpj AS STRING) = CAST(e.cnpj AS STRING)