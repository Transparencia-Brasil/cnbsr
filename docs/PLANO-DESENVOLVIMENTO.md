# Plano de desenvolvimento do MVP

Este documento organiza o desenvolvimento da primeira versão funcional do
`cnbsr`. O escopo inicial está restrito ao catálogo de **Materiais** do
Catálogo Nacional de Bens e Serviços (CNBS).

## Estado atual dos endpoints

| Endpoint incorporado | Função pública | Versão |
| --- | --- | --- |
| `GET /material/v1/codigoPdmClasse` | `get_codigo_pdm_classe()` | `0.0.0.9000` |
| `GET /material/v1/palavra` | `get_busca_material_por_palavra()` | `0.0.0.9001` |
| `GET /material/v1/materialCaracteristicaValorPdmSemFiltro` | `get_material_caracteristica_valor_pdm_sem_filtro()` | `0.0.0.9002` |
| `GET /material/v1/dadosbasicospdmporcodigo` | `get_dados_basicos_pdm_por_codigo()` | `0.0.0.9003` |
| `GET /material/v1/dadosItemMaterialporCodigo` | `get_dados_item_material_por_codigo()` | `0.0.0.9004` |
| `GET /material/v1/dadosItemMaterialporCodigoSiasgnet` | `get_dados_item_material_por_codigo_siasgnet()` | `0.0.0.9005` |
| `GET /material/v1/materialCaracteristcaValorporPDM` | `get_material_caracteristica_valor_por_pdm()` | `0.1.1` |
| `GET /material/v1/unidadeFornecimentoPorCodigoItemMaterial` | `get_unidade_fornecimento_por_codigo_item_material()` | `0.1.2` |
| `GET /material/v1/existeunidadefornecimento` | `existe_unidade_fornecimento()` | `0.1.2` |

Os nove endpoints selecionados estão implementados. A
[matriz da versão 0.1.2](endpoints/matriz-material-0.1.2.md) registra os 32
endpoints de Materiais observados no OpenAPI e distingue os incluídos, adiados e
excluídos.

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
| 7 | Incorporar o sétimo endpoint | [#14](https://github.com/rdurl0/cnbsr/issues/14) | Interface compatível e pacote pronto para 0.1.1 |
| 8 | Completar os endpoints `GET` de Materiais | [#17](https://github.com/rdurl0/cnbsr/issues/17) | Lotes 0.1.x acompanhados e pacote pronto para 0.2.0 |

As macroatividades 1 a 7 produziram as versões 0.1.0 e 0.1.1. A macroatividade
8 acompanha a versão 0.1.2 e os lotes futuros até que todos os 32 endpoints
`GET` de Materiais estejam disponíveis na versão 0.2.0.

## Estados sugeridos

- **Backlog:** atividade ainda não iniciada.
- **Em andamento:** existe trabalho ativo e responsável definido.
- **Em revisão:** entregáveis produzidos, aguardando validação.
- **Concluído:** todos os critérios de aceite da issue foram atendidos.

Caso seja criado um GitHub Project, essas quatro categorias podem ser usadas
como colunas do quadro.

## Regras de trabalho

1. Manter o escopo aprovado nas decisões 0001 e 0002.
2. Não incorporar novos endpoints sem atualizar a matriz e aprovar a interface.
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
