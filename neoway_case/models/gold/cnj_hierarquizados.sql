WITH RECURSIVE Hierarquia AS (
    -- CTE inicial para capturar os itens raiz
    SELECT 
        cod_item AS codigo_cnj,
        nome AS nome_item,
        cod_item_pai,
        nome AS nome_item_raiz,
        nome AS caminho_hierarquia,
        1 AS nivel
    FROM {{ ref('codigos_cnj') }}
    WHERE cod_item_pai = 0
    
    UNION ALL
    
    -- CTE recursiva para capturar os itens filhos
    SELECT 
        c.cod_item AS codigo_cnj,
        c.nome AS nome_item,
        c.cod_item_pai,
        h.nome_item_raiz,
        CONCAT(h.caminho_hierarquia, ' > ', c.nome) AS caminho_hierarquia,
        h.nivel + 1 AS nivel
    FROM {{ ref('codigos_cnj') }} c
    INNER JOIN Hierarquia h ON c.cod_item_pai = h.codigo_cnj
)

SELECT 
    distinct
    e.codigo_cnj,
    COALESCE(h.nome_item, 'NAO IDENTIFICADO') AS nome_item,
    COALESCE(h.nome_item_raiz, 'NAO IDENTIFICADO') AS nome_item_raiz,
    COALESCE(h.caminho_hierarquia, 'NAO IDENTIFICADO') AS caminho_hierarquia,
    COALESCE(h.nivel, 0) AS nivel,
    SPLIT(COALESCE(h.caminho_hierarquia, 'NAO IDENTIFICADO'), ' > ')[SAFE_OFFSET(0)] AS nivel1,
    SPLIT(COALESCE(h.caminho_hierarquia, 'NAO IDENTIFICADO'), ' > ')[SAFE_OFFSET(1)] AS nivel2,
    SPLIT(COALESCE(h.caminho_hierarquia, 'NAO IDENTIFICADO'), ' > ')[SAFE_OFFSET(2)] AS nivel3,
    SPLIT(COALESCE(h.caminho_hierarquia, 'NAO IDENTIFICADO'), ' > ')[SAFE_OFFSET(3)] AS nivel4,
    SPLIT(COALESCE(h.caminho_hierarquia, 'NAO IDENTIFICADO'), ' > ')[SAFE_OFFSET(4)] AS nivel5,
    SPLIT(COALESCE(h.caminho_hierarquia, 'NAO IDENTIFICADO'), ' > ')[SAFE_OFFSET(5)] AS nivel6
FROM  
    {{ ref('empresas_judicializacao_assuntos_cnj') }} e
LEFT JOIN Hierarquia h ON e.codigo_cnj = h.codigo_cnj
