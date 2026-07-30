# Como contribuir

1. Mantenha cada alteração pequena e focada no escopo de Materiais.
2. Use nomes de funções e argumentos em inglês e documentação em português
   brasileiro.
3. Formate o código com `styler`, verifique-o com `lintr` e documente funções
   exportadas com `roxygen2`.
4. Inclua testes `testthat` que não dependam exclusivamente da API real.
5. Antes de enviar uma contribuição, execute os testes, atualize a documentação
   e rode `R CMD check`.
6. Nunca inclua tokens, credenciais, segredos ou dados sensíveis.
7. Ao incorporar um endpoint, documente seu contrato em `docs/endpoints/`,
   atualize o inventário do README, a documentação roxygen, os testes mockados,
   o `NEWS.md`, a versão do pacote e o progresso das issues relacionadas.

Abra uma issue antes de propor uma mudança que altere a interface pública ou o
escopo do pacote.

## Manual PDF

O manual do pacote requer uma distribuição LaTeX com `pdflatex`. Para manter o
ambiente local alinhado ao CI, instale TinyTeX uma vez:

```r
tinytex::install_tinytex()
tinytex::tlmgr_install("makeindex")
tinytex::is_tinytex()
Sys.which(c("pdflatex", "tlmgr"))
```

Se uma instalação existente não estiver registrada, execute
`tinytex::use_tinytex()` e reinicie a sessão. Verifique e gere o manual com:

```sh
pdflatex --version
R CMD Rd2pdf --no-preview . --output=cnbsr-manual.pdf
```

Se a compilação indicar um arquivo `.sty` ausente, localize e instale somente o
pacote TeX necessário com `tinytex::tlmgr_search()` e
`tinytex::tlmgr_install()`.
