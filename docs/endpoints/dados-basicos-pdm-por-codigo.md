# Endpoint `dadosbasicospdmporcodigo`

## Contrato observado

- Método: `GET`.
- URL-base: `https://cnbs.estaleiro.serpro.gov.br/cnbs-api/material/v1`.
- Caminho: `/dadosbasicospdmporcodigo`.
- Operação no OpenAPI: `pesquisarDadosBasicosPdmPorCodigo`.
- Descrição: recuperação dos dados básicos e da hierarquia de um PDM pelo
  código.

| Parâmetro da API | Tipo | Obrigatório | Argumento no pacote |
| --- | --- | ---: | --- |
| `codigoPdm` | inteiro de 32 bits | sim | `codigo_pdm` |

O argumento deve ser um número inteiro positivo escalar. O endpoint não expõe
parâmetros opcionais nem paginação.

## Resposta

Uma resposta bem-sucedida possui status `200` e um objeto JSON, convertido em
um `tibble` de uma linha com os campos abaixo:

| Campo | Tipo observado |
| --- | --- |
| `codigoPdm` | inteiro |
| `nomePdm` | texto |
| `statusPdm` | lógico |
| `codigoConjunto` | inteiro |
| `nomeAcentuadoConjunto` | texto |
| `codigoClasse` | inteiro |
| `nomeClasse` | texto |
| `codigoGrupo` | inteiro |
| `nomeGrupo` | texto |

Em 28 de julho de 2026, o código `17708` retornou os dados do PDM "Dipirona
Sódica". O código inexistente `99999999` retornou status `204` sem corpo; nesse
caso, a função retorna um `tibble` com zero linhas e as mesmas nove colunas.

## Referência

- [Swagger da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
