# Endpoint `unidadeFornecimentoPorCodigoItemMaterial`

## Contrato observado

- Método: `GET`.
- URL-base: `https://cnbs.estaleiro.serpro.gov.br/cnbs-api/material/v1`.
- Caminho: `/unidadeFornecimentoPorCodigoItemMaterial`.
- Operação no OpenAPI: `pesquisarUnidadeFornecimentoPorCodigoItemMaterial`.
- Descrição: recuperação das unidades de fornecimento associadas a um item de
  material.

| Parâmetro da API | Tipo | Obrigatório | Argumento no pacote |
| --- | --- | ---: | --- |
| `codigo_item_material` | inteiro de 32 bits | sim | `codigo_item_material` |

O argumento deve ser um número inteiro positivo escalar. O endpoint não expõe
parâmetros opcionais nem paginação.

## Resposta

Uma resposta bem-sucedida possui status `200` e um array JSON, convertido em
um `tibble` com uma linha por unidade de fornecimento:

| Campo | Tipo no R |
| --- | --- |
| `siglaUnidadeFornecimento` | `character` |
| `nomeUnidadeFornecimento` | `character` |
| `capacidadeUnidadeMedida` | `double` |
| `siglaUnidadeMedida` | `character` |
| `nomeUnidadeMedida` | `character` |

Valores JSON `null` tornam-se `NA` do tipo correspondente. Um array vazio
retorna um `tibble` de zero linhas com as mesmas cinco colunas.

Em 30 de julho de 2026, o código `267203` retornou, entre outras, a unidade
`AM` (Ampola), com capacidade `2.0` e unidade de medida `ML` (Mililitro). O
código `99999999` retornou um array vazio.

## Referência

- [Swagger da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
