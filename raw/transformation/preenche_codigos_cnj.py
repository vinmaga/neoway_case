import pandas as pd

def mapear_cod_item(titulo, dicionario_itens):
    """
    Mapeia o título para o cod_item correspondente usando o dicionario_itens.
    
    Args:
        titulo (str): O título a ser mapeado.
        dicionario_itens (dict): Dicionário que mapeia títulos para cod_item.
    
    Retorna:
        int: O cod_item mapeado ou None se não encontrado.
    """
    return dicionario_itens.get(titulo, None)



def preencher_codigos(df, df_assuntos_cnj, situacao=None):
    """
    Preenche o 'codigo_cnj' em df_assuntos_cnj com base nos mapeamentos únicos de título de df.
    
    Args:
        df_cnj (pd.DataFrame): DataFrame com 'nome', 'cod_item' e 'situacao'.
        df_assuntos_cnj (pd.DataFrame): DataFrame com 'titulo' e 'codigo_cnj'.
        situacao (str, opcional): Situação para filtrar ('A' para ativo, 'I' para inativo, None para sem filtro).
        
    Retorna:
        pd.DataFrame: df_assuntos_cnj atualizado com 'codigo_cnj' preenchido.
    """
    if situacao:
        df_filtered = df[df.situacao == situacao]
    else:
        df_filtered = df

    df_unicos = df_filtered.groupby('nome').aggregate({'cod_item': 'count'}).reset_index()
    df_unicos = df_unicos[df_unicos.cod_item == 1]
    df_unicos = df_unicos[['nome']].merge(df_filtered[['nome', 'cod_item']], on='nome', how='left')

    item_dict = dict(zip(df_unicos['nome'], df_unicos['cod_item']))
    mask = (df_assuntos_cnj['codigo_cnj'] == 0) & (df_assuntos_cnj['titulo'].isin(item_dict.keys()))
    df_assuntos_cnj.loc[mask, 'codigo_cnj'] = df_assuntos_cnj.loc[mask, 'titulo'].map(lambda titulo: mapear_cod_item(titulo, item_dict))

    return df_assuntos_cnj





def preencher_codigos_hierarquicos(df, df_assuntos_cnj, situacao=None):
    """
    Preenche o 'codigo_cnj' em df_assuntos_cnj com base nos mapeamentos hierárquicos únicos de df_cnj.
    
    Args:
        df (pd.DataFrame): DataFrame com 'nome', 'maior_cod_item_pai' e 'situacao'.
        df_assuntos_cnj (pd.DataFrame): DataFrame com 'titulo' e 'codigo_cnj'.
        situacao (str, opcional): Situação para filtrar ('A' para ativo, 'I' para inativo, None para sem filtro).
        
    Retorna:
        pd.DataFrame: df_assuntos_cnj atualizado com 'codigo_cnj' preenchido.
    """
    if situacao:
        df_filtered = df[df.situacao == situacao]
    else:
        df_filtered = df

    # Aplicar lógica hierárquica
    df_maior = df_filtered[['nome', 'maior_cod_item_pai']].drop_duplicates()
    df_unicos = df_maior.groupby('nome').aggregate({'maior_cod_item_pai': 'nunique'}).reset_index()
    df_unicos = df_unicos[df_unicos.maior_cod_item_pai == 1]
    df_unicos = df_unicos[['nome']].merge(df_filtered[['nome', 'maior_cod_item_pai']], on='nome', how='left')
    df_unicos = df_unicos.drop_duplicates()
    df_unicos = df_unicos.dropna(subset=['maior_cod_item_pai'])
    
    item_dict = dict(zip(df_unicos['nome'], df_unicos['maior_cod_item_pai']))
    mask = (df_assuntos_cnj['codigo_cnj'] == 0) & (df_assuntos_cnj['titulo'].isin(item_dict.keys()))
    df_assuntos_cnj.loc[mask, 'codigo_cnj'] = df_assuntos_cnj.loc[mask, 'titulo'].map(lambda titulo: mapear_cod_item(titulo, item_dict))

    return df_assuntos_cnj