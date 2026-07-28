# Endpoint `materialCaracteristicaValorPdmSemFiltro`

## Contrato observado

- Método: `GET`.
- URL-base: `https://cnbs.estaleiro.serpro.gov.br/cnbs-api/material/v1`.
- Caminho: `/materialCaracteristicaValorPdmSemFiltro`.
- Operação no OpenAPI: `buscarItemCaracteristicaValorSemFiltro`.
- Descrição: recuperação de itens, características e valores sem filtro por
  código de PDM.

| Parâmetro da API | Tipo | Obrigatório | Argumento no pacote |
| --- | --- | ---: | --- |
| `codigo_pdm` | inteiro de 32 bits | sim | `codigo_pdm` |

O argumento deve ser um número inteiro positivo escalar. O endpoint não expõe
parâmetros opcionais nem paginação.

## Resposta

Uma resposta bem-sucedida possui status `200` e um array JSON. Cada item é
preservado como uma linha com os campos abaixo:

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

`buscaItemCaracteristica` é mantida como coluna-lista. Cada elemento contém
uma tabela com estes campos:

| Campo aninhado | Tipo observado |
| --- | --- |
| `codigoCaracteristica` | texto |
| `codigoValorCaracteristica` | texto |
| `nomeCaracteristica` | texto |
| `caracteristicaObrigatoria` | lógico |
| `statusCaracteristica` | lógico |
| `numeroCaracteristica` | inteiro |
| `nomeValorCaracteristica` | texto |
| `siglaUnidadeMedida` | texto |
| `statusValorCaracteristica` | lógico |
| `tuplaCaracteristica` | lista de textos |

Campos sem valor podem ser retornados como `null` pela API e são preservados
como valores ausentes no R. Em 28 de julho de 2026, o PDM `348` retornou dez
itens; o código inexistente `99999999` retornou `200` com `[]`. Nesse caso, a
função retorna um `tibble` com zero linhas e as mesmas 12 colunas.

## Referência

- [Swagger da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
