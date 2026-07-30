# cnbsr 0.1.2

## Funcionalidades

- Adiciona `get_unidade_fornecimento_por_codigo_item_material()` para recuperar
  as unidades de fornecimento associadas a um item de material.
- Adiciona `existe_unidade_fornecimento()` para verificar uma combinação de
  item, unidade de fornecimento, capacidade e unidade de medida.
- Eleva de sete para nove os endpoints `GET` de Materiais disponíveis.

## Robustez

- Valida códigos, textos obrigatórios e parâmetros opcionais antes da
  requisição.
- Converte respostas tabulares vazias preservando o esquema e rejeita respostas
  booleanas ausentes ou incompatíveis.

## Documentação e qualidade

- Atualiza o inventário para os 32 endpoints `GET` observados no módulo de
  Materiais e registra o roadmap até a versão 0.2.0.
- Documenta a instalação local do TinyTeX e a geração do manual PDF.

# cnbsr 0.1.1

## Funcionalidades

- Adiciona `get_material_caracteristica_valor_pdm()` para selecionar a consulta
  de itens, características e valores por PDM com ou sem filtro.
- Adiciona `get_material_caracteristica_valor_por_pdm()` como atalho explícito
  para a consulta por PDM com filtro.
- Incorpora o endpoint `materialCaracteristcaValorporPDM`, elevando de seis
  para sete os endpoints de Materiais disponíveis no pacote.
- Mantém `get_material_caracteristica_valor_pdm_sem_filtro()` compatível com a
  interface pública da versão 0.1.0.

## Robustez

- Valida `com_filtro` antes de realizar a requisição e produz erro informativo
  para valores que não sejam lógicos escalares não ausentes.

# cnbsr 0.1.0

## Funcionalidades

- Adiciona seis funções para consultar o catálogo de Materiais por palavra,
  código de PDM ou classe, código de item e características associadas a PDMs.
- Retorna `tibble` com nomes, ordem e tipos de colunas estáveis.
- Preserva características de itens em coluna-lista com esquema aninhado
  documentado.

## Robustez

- Valida argumentos antes de realizar requisições.
- Converte respostas vazias em tabelas de zero linhas com esquema preservado.
- Produz erros informativos para falhas HTTP, JSON inválido e mudanças
  incompatíveis nos contratos da API.
- Rejeita campos ausentes, extras e conversões de tipo com perda.

## Documentação e qualidade

- Documenta o escopo, a matriz de endpoints e a interface pública do MVP.
- Adiciona contratos por endpoint, exemplos e uma vignette de primeiros passos.
- Mantém testes HTTP mockados e integração contínua para lint, cobertura, build,
  manual PDF e `R CMD check --as-cran`.
