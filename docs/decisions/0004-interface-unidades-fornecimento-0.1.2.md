# 0004 — Interface de unidades de fornecimento na versão 0.1.2

## Status

Aceita em 30 de julho de 2026.

## Contexto

A versão 0.1.2 incorpora uma consulta tabular de unidades de fornecimento por
item e uma operação que responde apenas se uma combinação existe. A interface
anterior padronizou resultados como `tibble`, mas envolver um booleano em uma
tabela não acrescenta informação e torna o predicado menos idiomático em R.

## Decisão

A versão 0.1.2 adiciona as funções:

```r
get_unidade_fornecimento_por_codigo_item_material(codigo_item_material)

existe_unidade_fornecimento(
  codigo_item,
  sigla_unidade_fornecimento_pdm,
  capacidade_unidade_fornecimento = NULL,
  sigla_unidade_medida = NULL
)
```

A primeira retorna um `tibble` com esquema estável. A segunda retorna o lógico
escalar fornecido pelo endpoint. Respostas escalares da API podem, portanto,
ser expostas como escalares R quando essa representação preservar integralmente
o contrato remoto; respostas tabulares continuam seguindo a decisão 0002.

Códigos são inteiros positivos escalares de 32 bits. Textos obrigatórios são
escalares não vazios. A capacidade segue o tipo textual declarado no OpenAPI.
Parâmetros opcionais são omitidos quando `NULL`.

## Consequências

- O pacote passa a consultar nove endpoints `GET` de Materiais.
- O predicado pode ser usado diretamente em condições R.
- O conversor booleano rejeita valores ausentes ou de tipo incompatível.
- A exceção escalar não altera os contratos tabulares existentes.
