# Endpoint `dadosItemMaterialporCodigoSiasgnet`

## Contrato observado

- Método: `GET`.
- URL-base: `https://cnbs.estaleiro.serpro.gov.br/cnbs-api/material/v1`.
- Caminho: `/dadosItemMaterialporCodigoSiasgnet`.
- Operação no OpenAPI: `recuperaDescricaoItemSiasgnet_1`.
- Descrição: recuperação do nome e dos indicadores de um item de material para
  uso no SIASGnet.

| Parâmetro da API | Tipo | Obrigatório | Argumento no pacote |
| --- | --- | ---: | --- |
| `codigoItemMaterial` | inteiro de 32 bits | sim | `codigo_item_material` |

O argumento deve ser um número inteiro positivo escalar. O endpoint não expõe
parâmetros opcionais nem paginação.

## Resposta

Uma resposta bem-sucedida possui status `200` e um objeto JSON, convertido em
um `tibble` de uma linha com os campos abaixo:

| Campo | Tipo observado |
| --- | --- |
| `nomeItem` | texto |
| `statusItem` | lógico |
| `statusNaoSisg` | lógico |
| `itemSustentavel` | lógico |
| `itemExclusivoUasgCentral` | lógico |
| `itemSuspenso` | lógico |

Em 28 de julho de 2026, o código `267203` retornou o item "Dipirona Sódica,
Dosagem:500 MG", ativo e com os demais indicadores falsos. O código inexistente
`99999999` retornou status `500`; a função preserva esse comportamento como um
erro HTTP informativo do pacote.

## Referência

- [Swagger da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
