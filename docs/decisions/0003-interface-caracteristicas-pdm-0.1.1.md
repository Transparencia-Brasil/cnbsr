# 0003 — Interface de características por PDM na versão 0.1.1

## Status

Aceita em 29 de julho de 2026.

## Contexto

A versão 0.1.0 expôs o endpoint sem filtro por meio de
`get_material_caracteristica_valor_pdm_sem_filtro()`. O endpoint
`materialCaracteristcaValorporPDM`, que possui o mesmo esquema de resposta,
permite ampliar essa consulta sem duplicar a transformação dos dados.

## Decisão

A versão 0.1.1 adiciona a função:

```r
get_material_caracteristica_valor_pdm(codigo_pdm, com_filtro)
```

`codigo_pdm` continua sendo um inteiro positivo escalar de 32 bits.
`com_filtro` é um lógico escalar não ausente e seleciona o endpoint:

- `TRUE`: `materialCaracteristcaValorporPDM`;
- `FALSE`: `materialCaracteristicaValorPdmSemFiltro`.

`get_material_caracteristica_valor_pdm_sem_filtro()` permanece exportada e
equivale à nova função com `com_filtro = FALSE`. As duas consultas retornam o
mesmo contrato `tibble` com a coluna-lista `buscaItemCaracteristica`.

`get_material_caracteristica_valor_por_pdm()` também é exportada e equivale à
função geral com `com_filtro = TRUE`.

## Consequências

- O pacote passa a consultar sete endpoints de Materiais.
- Código escrito para a versão 0.1.0 permanece funcional.
- O usuário escolhe explicitamente se deseja a consulta com filtro.
- Mudanças de esquema em qualquer dos endpoints continuam produzindo erro.
