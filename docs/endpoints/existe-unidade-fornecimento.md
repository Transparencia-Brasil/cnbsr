# Endpoint `existeunidadefornecimento`

## Contrato observado

- Método: `GET`.
- URL-base: `https://cnbs.estaleiro.serpro.gov.br/cnbs-api/material/v1`.
- Caminho: `/existeunidadefornecimento`.
- Operação no OpenAPI: `existeUnidadeFornecimento`.
- Descrição: verificação da existência de uma combinação de item e unidade de
  fornecimento.

| Parâmetro da API | Tipo | Obrigatório | Argumento no pacote |
| --- | --- | ---: | --- |
| `codigoItem` | inteiro de 32 bits | sim | `codigo_item` |
| `siglaUnidadeFornecimentoPDM` | texto | sim | `sigla_unidade_fornecimento_pdm` |
| `capacidadeUnidadeFornecimento` | texto | não | `capacidade_unidade_fornecimento` |
| `siglaUnidadeMedida` | texto | não | `sigla_unidade_medida` |

Textos informados devem ser escalares não vazios. Parâmetros opcionais iguais
a `NULL` são omitidos da requisição. O endpoint não expõe paginação.

## Resposta

Uma resposta bem-sucedida possui status `200` e um booleano JSON. A função
retorna um lógico escalar `TRUE` ou `FALSE`. Valores nulos, textuais, numéricos,
arrays ou objetos são rejeitados como incompatíveis com o contrato.

Em 30 de julho de 2026, a combinação do item `267203`, unidade de fornecimento
`AM`, capacidade `"2.0"` e unidade de medida `ML` retornou `true`. A unidade
inexistente `XYZ` retornou `false`.

## Referência

- [Swagger da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
