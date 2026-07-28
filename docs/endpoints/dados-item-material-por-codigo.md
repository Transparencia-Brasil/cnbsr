# Endpoint `dadosItemMaterialporCodigo`

## Contrato observado

- Método: `GET`.
- URL-base: `https://cnbs.estaleiro.serpro.gov.br/cnbs-api/material/v1`.
- Caminho: `/dadosItemMaterialporCodigo`.
- Operação no OpenAPI: `recuperaDescricaoItem`.
- Descrição: recuperação da descrição completa de um item de material pelo
  código.

| Parâmetro da API | Tipo | Obrigatório | Argumento no pacote |
| --- | --- | ---: | --- |
| `codigo_item_material` | inteiro de 32 bits | sim | `codigo_item_material` |

O argumento deve ser um número inteiro positivo escalar. O endpoint não expõe
parâmetros opcionais nem paginação.

## Resposta

Uma resposta bem-sucedida possui status `200` e um objeto JSON, convertido em
um `tibble` de uma linha com o campo abaixo:

| Campo | Tipo observado |
| --- | --- |
| `descricaoItem` | texto |

Em 28 de julho de 2026, o código `267203` retornou a descrição
`267203 - Dipirona Sódica, Dosagem:500 MG`. O código inexistente `99999999`
retornou status `200` com `{"descricaoItem": null}`; nesse caso, a função
retorna um `tibble` com zero linhas e a coluna `descricaoItem` de tipo texto.

## Referência

- [Swagger da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
