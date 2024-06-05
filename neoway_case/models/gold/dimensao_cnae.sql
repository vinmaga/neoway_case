{{ config(alias='dimensao_cnae') }}

SELECT
    cd_cnae_principal
    ,de_cnae_principal
    ,de_ramo_atividade
    ,de_setor
    ,CONCAT(cd_cnae_principal, ' - ', de_cnae_principal) AS cnae_principal
FROM
    {{ ref('dim_cnaes') }}