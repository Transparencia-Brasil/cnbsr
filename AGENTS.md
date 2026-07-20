# Instruções para agentes de IA

## Objetivo e escopo

O `cnbsr` é um pacote R para consultar o Catálogo Nacional de Bens e Serviços
(CNBS). O MVP é limitado ao catálogo de **Materiais**; não amplie esse escopo
sem autorização explícita.

Referências obrigatórias:

- <https://r-pkgs.org/>;
- <https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/>;
- <https://catalogo.compras.gov.br/cnbs-web/busca>.

Siga as boas práticas descritas em *R Packages*. Prefira `httr2` para HTTP e
`tibble` para resultados tabulares. Use nomes de funções e argumentos em inglês
e escreva a documentação voltada ao usuário em português brasileiro.

## Implementação e qualidade

- Escreva funções pequenas, com responsabilidades bem delimitadas, e mantenha
  as dependências mínimas.
- Documente todas as funções exportadas com `roxygen2`.
- Escreva testes com `testthat`, usando mocks, fixtures ou respostas gravadas
  quando apropriado. Os testes não podem depender exclusivamente da
  disponibilidade da API real.
- Antes de considerar uma tarefa concluída, execute os testes, atualize a
  documentação e rode `R CMD check`.
- Informe todos os warnings, notes, erros e verificações que não puderem ser
  executadas.
- Nunca registre tokens, credenciais, segredos ou conteúdo sensível em código,
  exemplos, fixtures, logs, `.Renviron` ou commits.
- Preserve as mudanças do usuário e não altere arquivos sem relação com a
  tarefa.

## Git e GitHub

- Faça commits pequenos e descritivos.
- Não faça merge, crie releases, exclua branches ou altere configurações de
  segurança sem autorização explícita.

