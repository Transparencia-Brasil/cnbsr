# {cnbsr} — Catálogo Nacional de Bens e Serviços com R

O `cnbsr` consulta o Catálogo Nacional de Bens e Serviços (CNBS) por meio
da API pública do Governo Federal. A versão 0.1.2 é limitada ao catálogo de
**Materiais** e oferece resultados estáveis prontos para uso no R.

## Instalação

Instale a versão publicada no GitHub com:

```r
install.packages("pak")
pak::pak("Transparencia-Brasil/cnbsr@v0.1.2")
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

### Consultar unidades de fornecimento

```r
unidades <- get_unidade_fornecimento_por_codigo_item_material(267203)

existe <- existe_unidade_fornecimento(
  267203,
  "AM",
  capacidade_unidade_fornecimento = "2.0",
  sigla_unidade_medida = "ML"
)

unidades
existe
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

As consultas tabulares válidas sem resultados retornam um `tibble` de zero
linhas com as mesmas colunas. Predicados booleanos retornam `TRUE` ou `FALSE`.
Falhas HTTP, JSON inválido e mudanças incompatíveis no contrato remoto produzem
erros informativos.

Consulte a [vignette de primeiros passos](vignettes/primeiros-passos.Rmd) para
um fluxo completo.

## Endpoints da versão 0.1.2

| Endpoint | Função | Contrato |
| --- | --- | --- |
| `GET /material/v1/palavra` | `get_busca_material_por_palavra()` | [Busca por palavra](docs/endpoints/busca-material-por-palavra.md) |
| `GET /material/v1/codigoPdmClasse` | `get_codigo_pdm_classe()` | [Busca por código de PDM ou classe](docs/endpoints/codigo-pdm-classe.md) |
| `GET /material/v1/dadosbasicospdmporcodigo` | `get_dados_basicos_pdm_por_codigo()` | [Dados básicos de PDM](docs/endpoints/dados-basicos-pdm-por-codigo.md) |
| `GET /material/v1/dadosItemMaterialporCodigo` | `get_dados_item_material_por_codigo()` | [Descrição do item](docs/endpoints/dados-item-material-por-codigo.md) |
| `GET /material/v1/dadosItemMaterialporCodigoSiasgnet` | `get_dados_item_material_por_codigo_siasgnet()` | [Indicadores do item](docs/endpoints/dados-item-material-por-codigo-siasgnet.md) |
| `GET /material/v1/materialCaracteristcaValorporPDM` | `get_material_caracteristica_valor_por_pdm()` | [Características por PDM](docs/endpoints/material-caracteristica-valor-pdm.md) |
| `GET /material/v1/materialCaracteristicaValorPdmSemFiltro` | `get_material_caracteristica_valor_pdm_sem_filtro()` | [Características por PDM](docs/endpoints/material-caracteristica-valor-pdm-sem-filtro.md) |
| `GET /material/v1/unidadeFornecimentoPorCodigoItemMaterial` | `get_unidade_fornecimento_por_codigo_item_material()` | [Unidades por item](docs/endpoints/unidade-fornecimento-por-codigo-item-material.md) |
| `GET /material/v1/existeunidadefornecimento` | `existe_unidade_fornecimento()` | [Existência de unidade](docs/endpoints/existe-unidade-fornecimento.md) |

A [matriz de Materiais](docs/endpoints/matriz-material-0.1.2.md) registra os
endpoints incluídos, adiados e excluídos.

## Limitações

- O pacote consulta somente o catálogo de Materiais.
- As chamadas dependem da disponibilidade e dos contratos da API pública.
- Endpoints adiados não fazem parte da interface estável da versão 0.1.2.

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

Para gerar o manual PDF localmente, instale uma vez a distribuição TinyTeX. O
pacote R `tinytex` e a distribuição LaTeX são componentes diferentes:

```r
tinytex::install_tinytex()
tinytex::tlmgr_install("makeindex")
tinytex::is_tinytex()
Sys.which(c("pdflatex", "tlmgr"))
```

Reinicie a sessão se os executáveis ainda não aparecerem no `PATH`. Para
registrar uma instalação já existente, use `tinytex::use_tinytex()`. Depois,
gere os mesmos artefatos básicos do CI:

```sh
R CMD build .
R CMD Rd2pdf --no-preview . --output=cnbsr-manual.pdf
```

Consulte também [Como contribuir](CONTRIBUTING.md).

## Referências

- [R Packages](https://r-pkgs.org/)
- [Documentação da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
- [Interface pública do CNBS](https://catalogo.compras.gov.br/cnbs-web/busca)

## Licença

O `cnbsr` é disponibilizado sob a licença MIT.
