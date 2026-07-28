# `{cnbsr}` - Catálogo Nacional de Bens e Serviços com `R`

O `cnbsr` é um pacote R em desenvolvimento para consultar o Catálogo Nacional
de Bens e Serviços (CNBS) por meio da API pública do Governo Federal.

## Escopo do MVP

Esta primeira etapa é limitada ao catálogo de **Materiais**. O MVP permitirá
pesquisar materiais por texto, consultar um material por código e navegar pela
hierarquia do catálogo. Os resultados serão retornados como `tibble` e a
paginação será controlada por página e tamanho, sem obtenção automática de
todas as páginas.

A estrutura de desenvolvimento, testes e integração contínua está preparada.
As funções incorporadas possuem contratos públicos documentados, e as decisões
aprovadas estão registradas em
[`docs/decisions/0001-escopo-mvp.md`](docs/decisions/0001-escopo-mvp.md).

## Estado do projeto

O projeto está em fase inicial. Já estão disponíveis consultas de materiais por
palavra, de PDMs por código de PDM ou de classe, de dados básicos de PDM, da
descrição de itens e de itens, características e valores por código de PDM. Os
demais endpoints de Materiais e a interface pública restante ainda serão
definidos e implementados.

```r
get_busca_material_por_palavra("caneta")
get_codigo_pdm_classe(6505)
get_dados_basicos_pdm_por_codigo(17708)
get_dados_item_material_por_codigo(267203)
get_material_caracteristica_valor_pdm_sem_filtro(348)
```

## Endpoints disponíveis

| Endpoint | Função | Contrato |
| --- | --- | --- |
| `GET /material/v1/palavra` | `get_busca_material_por_palavra()` | [Busca por palavra](docs/endpoints/busca-material-por-palavra.md) |
| `GET /material/v1/codigoPdmClasse` | `get_codigo_pdm_classe()` | [Busca por código de PDM ou classe](docs/endpoints/codigo-pdm-classe.md) |
| `GET /material/v1/dadosbasicospdmporcodigo` | `get_dados_basicos_pdm_por_codigo()` | [Dados básicos de PDM por código](docs/endpoints/dados-basicos-pdm-por-codigo.md) |
| `GET /material/v1/dadosItemMaterialporCodigo` | `get_dados_item_material_por_codigo()` | [Descrição de item por código](docs/endpoints/dados-item-material-por-codigo.md) |
| `GET /material/v1/materialCaracteristicaValorPdmSemFiltro` | `get_material_caracteristica_valor_pdm_sem_filtro()` | [Itens, características e valores por PDM](docs/endpoints/material-caracteristica-valor-pdm-sem-filtro.md) |

Cada endpoint incorporado corresponde a uma nova versão de desenvolvimento do
pacote e deve ser acompanhado por contrato, documentação, testes e atualização
das issues relacionadas.

## Instalação para desenvolvimento

Clone o repositório, abra `cnbsr.Rproj` no RStudio e restaure o ambiente:

```r
install.packages("renv")
renv::restore()
devtools::load_all()
devtools::test()
```

O uso de `devtools` é opcional. As verificações completas também podem ser
executadas com `R CMD check`.

## Referências

- [R Packages](https://r-pkgs.org/)
- [Documentação da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
- [Interface pública do CNBS](https://catalogo.compras.gov.br/cnbs-web/busca)

## Licença

O `cnbsr` é disponibilizado sob a licença MIT.
