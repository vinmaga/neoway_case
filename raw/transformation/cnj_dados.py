import requests
import pandas as pd

def cnj_dados():
    """
    Realiza uma solicitação GET ao endpoint especificado e retorna um DataFrame
    com as colunas selecionadas: 'cod_item', 'cod_item_pai', 'nome', 'situacao'.
    
    Retorna:
        pd.DataFrame: DataFrame contendo as colunas selecionadas.
    """
    base_url='https://gateway.cloud.pje.jus.br/tpu' 
    endpoint='/api/v1/publico/download/assuntos'
    url = base_url + endpoint
    response = requests.get(url)
    data = response.json()

    # Selecionando colunas específicas para o DataFrame
    selected_columns = ['cod_item', 'cod_item_pai', 'nome', 'situacao']
    
    # Criando o DataFrame
    df = pd.DataFrame(data)[selected_columns]
    
    # Preenchendo valores NaN em 'cod_item_pai' com 0 e convertendo para inteiro
    df.cod_item_pai = df.cod_item_pai.fillna(0).astype(int)
    
    return df


def encontrar_maior_cod_item_pai(df, cod_item):
    """
    Encontra o maior 'cod_item_pai' no DataFrame para um 'cod_item' dado.
    
    Args:
        df (pd.DataFrame): DataFrame contendo 'cod_item' e 'cod_item_pai'.
        cod_item (int): O código do item cujo maior 'cod_item_pai' deve ser encontrado.
    
    Retorna:
        int: O maior 'cod_item_pai' encontrado para o 'cod_item' dado. Se o 'cod_item' não tiver pai, retorna o próprio 'cod_item'.
    """
    current_cod_item_pai = df.loc[df['cod_item'] == cod_item, 'cod_item_pai'].values[0]
    if current_cod_item_pai == 0:
        return cod_item
    while current_cod_item_pai != 0:
        next_cod_item_pai = df.loc[df['cod_item'] == current_cod_item_pai, 'cod_item_pai']
        if next_cod_item_pai.empty or next_cod_item_pai.values[0] == 0:
            break
        current_cod_item_pai = next_cod_item_pai.values[0]
    return current_cod_item_pai