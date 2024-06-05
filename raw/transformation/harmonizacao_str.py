import re
from unidecode import unidecode

def limpar_assunto(titulo):
    """
    Limpa o título aplicando as seguintes transformações:
    1. Remove a parte após um hífen.
    2. Remove a parte após uma vírgula.
    3. Remove a parte após dois pontos duplos (::).
    4. Remove " (DIREITO CIVIL)" no final do título.

    Args:
        titulo (str): O título a ser limpo.

    Retorna:
        str: O título limpo.
    """
    # Remove a parte após um hífen
    titulo = re.split(r'\s*-\s*', titulo)[0]
    # Remove a parte após uma vírgula
    titulo = re.split(r'\s*,\s*', titulo)[0]
    # Remove a parte após dois pontos duplos (::)
    titulo = re.split(r'\s*::\s*', titulo)[0]
    # Remove " (DIREITO CIVIL)" no final do título
    titulo = re.sub(r'\s*\(DIREITO CIVIL\)$', '', titulo)
    
    return titulo



def remover_acentos_e_maiusculo(texto):
    '''
    Função para remover acentos e converter para maiúsculas
    '''
    return unidecode(texto.strip()).upper()



def limpar_nome_municipio(nome):
    """
    Limpa e formata o nome do município com base nas seguintes regras:
    1. Se o nome contém a palavra "vara", extrai o nome do município após "vara do trabalho de" ou "vara de".
    2. Se não contém "vara" ou não corresponde ao padrão, retorna o nome original formatado.

    Args:
        nome (str): O nome a ser limpo e formatado.

    Retorna:
        str: O nome do município limpo e formatado.
    """
    # Verifica se o nome contém a palavra "vara"
    if 'vara' in nome.lower():
        padrao = re.compile(r'.*?(?:vara do trabalho d[aeo]|vara d[aeo])\s*(.*)', re.IGNORECASE)
        resultado = padrao.search(nome)
        if resultado:
            return unidecode(resultado.group(1).strip().title())
    # Se não contiver "vara" ou não corresponder ao padrão, retorna o nome original formatado
    return unidecode(nome.strip().title())


def identificar_capital(mun):
    '''
    Identifica a capital de um estado brasileiro com base no padrão "tjUF".
    
    Args:
        mun (str): O nome da coluna a ser analisada procurando pelo padrão.
    
    Retorna:
        str: O nome da capital do estado correspondente ou uma mensagem de erro se o estado não for encontrado.
    '''
    if mun.lower().startswith("tj"):
        uf = mun[2:].lower()  # Extrai o código do estado (sem "tj")
        capitais = {
          "ac": "Rio Branco",
          "al": "Maceio",
          "ap": "Macapa",
          "am": "Manaus",
          "ba": "Salvador",
          "ce": "Fortaleza",
          "df": "Brasilia",
          "es": "Vitória",
          "go": "Goiania",
          "ma": "São Luis",
          "mt": "Cuiaba",
          "ms": "Campo Grande",
          "mg": "Belo Horizonte",
          "pa": "Belem",
          "pb": "João Pessoa",
          "pr": "Curitiba",
          "pe": "Recife",
          "pi": "Teresina",
          "rj": "Rio de Janeiro",
          "rn": "Natal",
          "ro": "Porto Velho",
          "rr": "Boa Vista",
          "sc": "Florianopolis",
          "se": "Aracaju",
          "sp": "Sao Paulo",
          "to": "Palmas",
        }
        return capitais.get(uf, f"**Estado não encontrado: {mun}**")
    else:
        return mun


def identificar_cidade(nome):
    '''
    Identifica se o nome corresponde a uma das cidades específicas (Florianopolis, Sao Paulo, Porto Alegre) que precisam de harmonização.
    Se corresponder, retorna o nome da cidade harmonizado. Caso contrário, retorna o nome original.
    
    Args:
        nome (str): O nome a ser analisado.
    
    Retorna:
        str: O nome da cidade identificada ou o nome original se não corresponder.
    '''
    regex = r"^(Florianopolis|Sao Paulo|Porto Alegre)\s*(.*)$"  
    match = re.match(regex, nome, re.IGNORECASE)  
    if match:
        return match.group(1) 
    else:
        return nome