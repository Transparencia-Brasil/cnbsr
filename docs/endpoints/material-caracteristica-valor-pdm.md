# Endpoint `materialCaracteristcaValorporPDM`

## Contrato observado

- Método: `GET`.
- URL-base: `https://cnbs.estaleiro.serpro.gov.br/cnbs-api/material/v1`.
- Caminho: `/materialCaracteristcaValorporPDM`.
- Operação no OpenAPI: `buscarItemCaracteristicaValor`.
- Descrição: recuperação de itens, características e valores por PDM.

| Parâmetro da API | Tipo | Obrigatório | Argumento no pacote |
| --- | --- | ---: | --- |
| `codigo_pdm` | inteiro de 32 bits | sim | `codigo_pdm` |

O argumento deve ser um número inteiro positivo escalar. O endpoint não expõe
parâmetros opcionais nem paginação. Ele é exposto por
`get_material_caracteristica_valor_por_pdm()` e também pode ser selecionado por
`get_material_caracteristica_valor_pdm(..., com_filtro = TRUE)`.

## Resposta

Uma resposta bem-sucedida possui status `200` e um array JSON com o esquema
`BuscaItem`. Cada item torna-se uma linha com 12 colunas:

| Campo | Tipo observado |
| --- | --- |
| `codigoPdm` | inteiro |
| `codigoItem` | inteiro |
| `nomePdm` | texto |
| `statusItem` | lógico |
| `itemSuspenso` | lógico |
| `itemSustentavel` | lógico |
| `itemExclusivoUasgCentral` | lógico |
| `codigoClasse` | inteiro |
| `codigoNcm` | texto |
| `nomeNcm` | texto |
| `aplicaMargemPreferencia` | lógico |
| `buscaItemCaracteristica` | lista |

Cada elemento de `buscaItemCaracteristica` é um `tibble` com códigos, nomes,
status e valores de características. `tuplaCaracteristica` permanece uma lista
de vetores de texto. Campos JSON `null` tornam-se valores ausentes tipados.

Uma consulta válida sem resultados retorna zero linhas com o mesmo esquema.
Falhas HTTP, JSON inválido e campos incompatíveis produzem erros informativos.

## Referência

- [Swagger da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
