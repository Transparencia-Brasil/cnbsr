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
`tibble` para resultados tabulares. Use nomes de funções e argumentos em inglês.
Como exceção, wrappers públicos que correspondam diretamente a endpoints podem
usar o nome original do endpoint e de seus parâmetros em `snake_case`, para
manter a rastreabilidade com a API. Escreva a documentação voltada ao usuário em
português brasileiro.

## Implementação e qualidade

- Escreva funções pequenas, com responsabilidades bem delimitadas, e mantenha
  as dependências mínimas.
- Documente todas as funções exportadas com `roxygen2`.
- Escreva testes com `testthat`, usando mocks, fixtures ou respostas gravadas
  quando apropriado. Os testes não podem depender exclusivamente da
  disponibilidade da API real.
- Para cada novo endpoint, documente o contrato em `docs/endpoints/`, atualize
  o inventário do README, a documentação roxygen, os testes mockados, o
  `NEWS.md`, a versão do pacote e o progresso das issues relacionadas.
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
- Pergunte antes de qualquer alteração se quer que a mudança seja feita em uma branch existente ou em uma nova branch (sugira um nome intuitivo).
- Não faça merge, crie releases, exclua branches ou altere configurações de
  segurança sem autorização explícita.

### Commits semânticos

As guidelines recomendam o uso de tais convenções na mensagem de commit por:

- Geração automática do changelog
- Navegação facilitada no histórico do Git
- O padrão de mensagem do commit semântico proposto é:

```text
<tipo>(<escopo>): <assunto>

<corpo>

<rodapé>
```

Sendo `<tipo>` dos seguintes valores:

- **`feat`**: quando se trata de uma nova funcionalidade (do inglês, feature)
- **`fix`**: quando se trata de uma correção de bug
- **`docs`**: quando se faz uma alteração na documentação
- **`style`**: quando se trata de formatação de código
- **`refactor`**: quando se trata de refatoração de código em produção
- **`test`**: quando se adiciona ou refatora testes, sem impacto em código em produção
- **`chore`**: quando se adiciona ou edita tasks do Grunt, ou Webpack, também sem impacto em produção

O `<escopo>` é opcional, **principalmente se a alteração for global**, mas bons exemplos seriam `init`, `runner`, `watcher`, `config`, `web-server`, `proxy`, etc.

Para o `<corpo>` da mensagem de commit recomenda-se:

1. Use a forma imperativa no presente dos verbos. Prefira "change" à "changed" ou "changes"
2. Inclua os motivos das mudanças no código em comparação ao comportamento anterior
