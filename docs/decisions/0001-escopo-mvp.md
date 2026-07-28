# 0001 — Escopo do MVP 0.1.0

## Status

Aceita em 27 de julho de 2026.

## Contexto

O `cnbsr` precisa de um escopo funcional estável antes do levantamento dos
endpoints e da definição de sua interface pública. A primeira versão funcional
será limitada ao catálogo de Materiais do CNBS.

## Decisão

O público prioritário é formado por pessoas que usam R em análise de compras
públicas, pesquisa, auditoria, transparência e integração de dados e precisam
consultar o CNBS de forma reprodutível.

O MVP atenderá aos seguintes casos de uso:

1. pesquisar materiais por termo textual;
2. consultar um material por código;
3. navegar pelos níveis hierárquicos necessários para localizar materiais; e
4. receber resultados tabulares prontos para uso no R.

Os resultados públicos serão retornados como `tibble`, com nomes e tipos de
colunas estáveis. Estruturas aninhadas poderão ser mantidas em colunas-lista
quando não houver uma representação tabular adequada.

A paginação será manual: a interface permitirá informar a página e o tamanho
da página, mas não percorrerá nem agregará automaticamente todas as páginas.

Uma consulta válida sem resultados retornará um `tibble` com zero linhas.
Falhas HTTP e respostas inválidas produzirão erros informativos. O pacote não
retornará silenciosamente resultados parciais como se estivessem completos.

A licença do pacote será MIT.

Ficam fora do MVP:

- o catálogo de Serviços;
- escrita ou alteração de dados no CNBS;
- interface gráfica ou aplicação Shiny;
- cache persistente ou banco de dados local;
- integração direta com PNCP ou outros sistemas; e
- garantia de compatibilidade com endpoints não documentados.

Os endpoints GET concretos serão selecionados na issue #1. A issue #7 só será
concluída depois que esse levantamento confirmar que os casos de uso aprovados
podem ser atendidos. A interface pública será definida na issue #2 após essa
confirmação.

O levantamento foi concluído em 28 de julho de 2026. A
[matriz de endpoints](../endpoints/matriz-material-0.1.0.md) seleciona seis
operações `GET`, confirma o atendimento dos casos de uso e registra os demais
endpoints como adiados ou excluídos. A interface resultante está formalizada na
[decisão 0002](0002-interface-publica-0.1.0.md).

## Consequências

- A implementação permanece restrita a Materiais.
- O cliente HTTP não terá um modo para obter automaticamente todas as páginas.
- A matriz de endpoints deverá distinguir explicitamente o que entra e o que
  fica fora da versão 0.1.0.
- Nomes de funções, argumentos e esquemas de colunas continuam pendentes até a
  conclusão do levantamento da API.
