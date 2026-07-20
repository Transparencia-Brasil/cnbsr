# Plano de desenvolvimento do MVP

Este documento organiza o desenvolvimento da primeira versão funcional do
`cnbsr`. O escopo inicial está restrito ao catálogo de **Materiais** do
Catálogo Nacional de Bens e Serviços (CNBS).

## Fluxo de acompanhamento

O andamento será gerenciado pelas issues do GitHub. Cada macroatividade deve
permanecer aberta enquanto houver critérios de aceite pendentes. Mudanças de
arquitetura, interface pública, dependências ou escopo devem ser registradas em
`docs/decisions/`.

| Ordem | Macroatividade | Issue | Resultado esperado |
|---:|---|---|---|
| 1 | Definir o escopo do MVP | [#7](https://github.com/rdurl0/cnbsr/issues/7) | Casos de uso, limites e critérios de aceite aprovados |
| 2 | Mapear a API de Materiais | [#1](https://github.com/rdurl0/cnbsr/issues/1) | Matriz de endpoints, parâmetros e respostas |
| 3 | Definir a interface pública | [#2](https://github.com/rdurl0/cnbsr/issues/2) | Funções, argumentos e retornos especificados |
| 4 | Implementar o cliente HTTP | [#3](https://github.com/rdurl0/cnbsr/issues/3) | Requisições e tratamento de erros funcionando |
| 5 | Padronizar as respostas | [#4](https://github.com/rdurl0/cnbsr/issues/4) | Dados retornados como estruturas estáveis no R |
| 6 | Testar, documentar e preparar a versão | [#5](https://github.com/rdurl0/cnbsr/issues/5) | Pacote verificado e pronto para 0.1.0 |

## Estados sugeridos

- **Backlog:** atividade ainda não iniciada.
- **Em andamento:** existe trabalho ativo e responsável definido.
- **Em revisão:** entregáveis produzidos, aguardando validação.
- **Concluído:** todos os critérios de aceite da issue foram atendidos.

Caso seja criado um GitHub Project, essas quatro categorias podem ser usadas
como colunas do quadro.

## Regras de trabalho

1. Iniciar pela issue #7.
2. Não implementar funções públicas antes de concluir o levantamento da API e
   aprovar a interface.
3. Relacionar commits e pull requests à issue correspondente.
4. Atualizar checklists conforme cada entrega for validada.
5. Registrar decisões duradouras em `docs/decisions/`.
6. Manter o MVP restrito a Materiais, salvo decisão explícita em contrário.

## Definição de pronto do MVP

O MVP estará concluído quando:

- os casos de uso e endpoints selecionados estiverem documentados;
- as funções públicas definidas estiverem implementadas;
- as consultas retornarem estruturas consistentes no R;
- erros, resultados vazios e paginação tiverem comportamento documentado;
- testes automatizados e documentação estiverem atualizados; e
- `R CMD check` for executado sem problemas não justificados.
