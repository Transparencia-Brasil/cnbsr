# cnbsr

O `cnbsr` é um pacote R em desenvolvimento para consultar o Catálogo Nacional
de Bens e Serviços (CNBS) por meio da API pública do Governo Federal.

## Escopo do MVP

Esta primeira etapa é limitada ao catálogo de **Materiais**. A estrutura de
desenvolvimento, testes e integração contínua já está preparada, mas as funções
de consulta e seus contratos públicos ainda não foram implementados.

## Estado do projeto

O projeto está em fase inicial. Antes da primeira versão, serão levantados os
endpoints de Materiais, definida a interface pública e implementados o cliente
HTTP e a transformação das respostas.

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

A licença ainda não foi escolhida. Consulte as decisões pendentes em
[`docs/decisions/README.md`](docs/decisions/README.md).

