-- {{ config(materialized='table') }}

with recursive hierarchy as (
  select 
    cod_item,
    cod_item_pai,
    nome,
    situacao,
    cast(cod_item as string) as hierarquia,
    1 as nivel
  from {{ ref('codigos_cnj') }}
  where cod_item_pai = 0
  union all
  select 
    child.cod_item,
    child.cod_item_pai,
    child.nome,
    child.situacao,
    concat(parent.hierarquia, ' > ', cast(child.cod_item as string)) as hierarquia,
    parent.nivel + 1 as nivel
  from {{ ref('codigos_cnj') }} child
  join hierarchy parent on parent.cod_item = child.cod_item_pai
)
select 
  cod_item,
  cod_item_pai,
  nome,
  situacao,
  hierarquia,
  nivel
from hierarchy


