# Endpoint `palavra`

## Contrato observado

- Método: `GET`.
- URL-base: `https://cnbs.estaleiro.serpro.gov.br/cnbs-api/material/v1`.
- Caminho: `/palavra`.
- Operação no OpenAPI: `searchAdvanced_1`.
- Descrição: recuperação de dados de Material por palavra.

| Parâmetro da API | Tipo | Obrigatório | Argumento no pacote |
| --- | --- | ---: | --- |
| `palavra` | texto | sim | `palavra` |
| `apenasAtivos` | texto | não | `apenas_ativos` |

`palavra` deve ser um texto escalar não vazio. `apenasAtivos` é declarado como
texto no OpenAPI e é omitido quando `apenas_ativos = NULL`. Quando informado, o
valor é encaminhado literalmente à API; o pacote não interpreta nem converte
seu conteúdo.

## Resposta

Uma resposta bem-sucedida possui status `200` e um array JSON no esquema
`ElasticPdm`. Cada item pode conter os campos abaixo, preservados sem
renomeação pelo pacote:

| Campo | Tipo observado |
| --- | --- |
| `codigoPDM` | inteiro |
| `codigoPdm` | inteiro |
| `codigoClasse` | inteiro |
| `codigoGrupo` | inteiro |
| `descricaoPDM` | texto |
| `nomePdm` | texto |
| `descricaoClasse` | texto |
| `nomeClasse` | texto |
| `descricaoGrupo` | texto |
| `statusPDM` | lógico |
| `statusClasse` | lógico |
| `statusGrupo` | lógico |

Uma consulta válida sem resultados retorna um `tibble` com zero linhas e essas
12 colunas. Falhas HTTP, conteúdo não JSON e respostas incompatíveis com uma
tabela produzem erros informativos.

O endpoint não expõe parâmetros de paginação. A função retorna todos os
registros fornecidos pela API e não implementa paginação ou agregação local.

Em 28 de julho de 2026, a consulta com `palavra = "caneta"` retornou `200`, 144
registros e 12 campos. Consultas exploratórias com diferentes textos em
`apenasAtivos` não permitiram determinar uma enumeração oficial nem um efeito
estável para o parâmetro; por isso, o pacote o preserva como texto.

## Referência

- [Swagger da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
