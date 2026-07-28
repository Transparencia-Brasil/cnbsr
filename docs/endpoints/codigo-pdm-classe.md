# Endpoint `codigoPdmClasse`

## Contrato observado

- Método: `GET`.
- URL-base: `https://cnbs.estaleiro.serpro.gov.br/cnbs-api/material/v1`.
- Caminho: `/codigoPdmClasse`.
- Operação no OpenAPI: `searchPdmPorCodigo`.
- Descrição: recuperação de dados de PDM por código de PDM ou de classe.

| Parâmetro da API | Tipo | Obrigatório | Argumento no pacote |
| --- | --- | ---: | --- |
| `codigoPdmClasse` | inteiro de 32 bits | sim | `codigo_pdm_classe` |
| `buscaClasse` | lógico | não | `busca_classe` |
| `buscaPdm` | lógico | não | `busca_pdm` |

Os dois parâmetros opcionais são omitidos quando o argumento correspondente é
`NULL`. A função não restringe suas combinações: os valores informados são
encaminhados à API.

## Resposta

Uma resposta bem-sucedida possui status `200` e um array JSON. Cada item pode
conter os campos abaixo, preservados sem renomeação pelo pacote:

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

Em 27 de julho de 2026, a consulta sem flags para o código `6505` retornou
1.888 registros. Um código inexistente retornou `200` com `[]`. A ausência de
`codigoPdmClasse` ou um valor não inteiro retornou `400`. O endpoint não expõe
parâmetros de paginação e a função não implementa paginação local.

## Referência

- [Swagger da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
