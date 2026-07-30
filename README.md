# {cnbsr} — Catálogo Nacional de Bens e Serviços com R

O `cnbsr` consulta o Catálogo Nacional de Bens e Serviços (CNBS) por meio
da API pública do Governo Federal. A versão 0.1.1 é limitada ao catálogo de
**Materiais** e oferece resultados tabulares prontos para análise no R.

## Instalação

Instale a versão publicada no GitHub com:

```r
install.packages("pak")
pak::pak("rdurl0/cnbsr@v0.1.1")
```

Para contribuir com o projeto, clone o repositório, abra `cnbsr.Rproj` e
restaure o ambiente:

```r
install.packages("renv")
renv::restore()
devtools::load_all()
devtools::test()
```

## Uso

### Pesquisar materiais por texto

```r
library(cnbsr)

materiais <- get_busca_material_por_palavra("caneta")
materiais
```

### Consultar um item por código

```r
descricao <- get_dados_item_material_por_codigo(267203)
indicadores <- get_dados_item_material_por_codigo_siasgnet(267203)

descricao
indicadores
```

### Navegar pela hierarquia e pelas características

```r
pdms <- get_codigo_pdm_classe(6505, busca_classe = TRUE)
hierarquia <- get_dados_basicos_pdm_por_codigo(17708)
itens <- get_material_caracteristica_valor_por_pdm(348)
itens_sem_filtro <- get_material_caracteristica_valor_pdm_sem_filtro(348)

hierarquia
itens[, c("codigoItem", "nomePdm")]
itens$buscaItemCaracteristica[[1]]
```

As consultas válidas sem resultados retornam um `tibble` de zero linhas
com as mesmas colunas. Falhas HTTP, JSON inválido e mudanças incompatíveis no
contrato remoto produzem erros informativos.

Consulte a [vignette de primeiros passos](vignettes/primeiros-passos.Rmd) para
um fluxo completo.

## Endpoints da versão 0.1.1

| Endpoint | Função | Contrato |
| --- | --- | --- |
| `GET /material/v1/palavra` | `get_busca_material_por_palavra()` | [Busca por palavra](docs/endpoints/busca-material-por-palavra.md) |
| `GET /material/v1/codigoPdmClasse` | `get_codigo_pdm_classe()` | [Busca por código de PDM ou classe](docs/endpoints/codigo-pdm-classe.md) |
| `GET /material/v1/dadosbasicospdmporcodigo` | `get_dados_basicos_pdm_por_codigo()` | [Dados básicos de PDM](docs/endpoints/dados-basicos-pdm-por-codigo.md) |
| `GET /material/v1/dadosItemMaterialporCodigo` | `get_dados_item_material_por_codigo()` | [Descrição do item](docs/endpoints/dados-item-material-por-codigo.md) |
| `GET /material/v1/dadosItemMaterialporCodigoSiasgnet` | `get_dados_item_material_por_codigo_siasgnet()` | [Indicadores do item](docs/endpoints/dados-item-material-por-codigo-siasgnet.md) |
| `GET /material/v1/materialCaracteristcaValorporPDM` | `get_material_caracteristica_valor_por_pdm()` | [Características por PDM](docs/endpoints/material-caracteristica-valor-pdm.md) |
| `GET /material/v1/materialCaracteristicaValorPdmSemFiltro` | `get_material_caracteristica_valor_pdm_sem_filtro()` | [Características por PDM](docs/endpoints/material-caracteristica-valor-pdm-sem-filtro.md) |

A [matriz de Materiais](docs/endpoints/matriz-material-0.1.1.md) registra os
endpoints incluídos, adiados e excluídos.

## Limitações

- O pacote consulta somente o catálogo de Materiais.
- Não há escrita, cache persistente, banco local ou interface gráfica.
- Os endpoints selecionados não expõem paginação no OpenAPI atual.
- As chamadas dependem da disponibilidade e dos contratos da API pública.
- Endpoints adiados não fazem parte da interface estável da versão 0.1.1.

## Desenvolvimento

Antes de enviar uma alteração:

```r
devtools::document()
devtools::test()

devtools::load_all(quiet = TRUE)
lints <- lintr::lint_package()
print(lints)

rcmdcheck::rcmdcheck(args = "--as-cran")
```

Consulte também [Como contribuir](CONTRIBUTING.md).

## Referências

- [R Packages](https://r-pkgs.org/)
- [Documentação da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
- [Interface pública do CNBS](https://catalogo.compras.gov.br/cnbs-web/busca)

## Licença

O `cnbsr` é disponibilizado sob a licença MIT.
