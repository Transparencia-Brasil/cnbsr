# cnbsr 0.0.0.9005

- Adiciona `get_dados_item_material_por_codigo_siasgnet()` para recuperar o
  nome e os indicadores de um item de material para o SIASGnet.
- Mantém falhas HTTP do endpoint como erros informativos, inclusive o status
  `500` observado para códigos inexistentes.

# cnbsr 0.0.0.9004

- Adiciona `get_dados_item_material_por_codigo()` para recuperar a descrição
  completa de um item de material pelo código.
- Interpreta a resposta `{"descricaoItem": null}` como resultado vazio e
  preserva o esquema `DescricaoItem`.

# cnbsr 0.0.0.9003

- Adiciona `get_dados_basicos_pdm_por_codigo()` para recuperar dados básicos e
  a hierarquia de um PDM pelo código.
- Converte respostas de objeto único em `tibble` e mantém o esquema
  `PdmParcial` em respostas `204` sem conteúdo.

# cnbsr 0.0.0.9002

- Adiciona `get_material_caracteristica_valor_pdm_sem_filtro()` para recuperar
  itens, características e valores associados a um código de PDM.
- Preserva as características de cada item na coluna-lista
  `buscaItemCaracteristica` e define um esquema estável para respostas vazias.

# cnbsr 0.0.0.9001

- Adiciona `get_busca_material_por_palavra()` para consultar materiais pelo
  endpoint `GET /material/v1/palavra`.
- Compartilha o esquema vazio `ElasticPdm` entre as consultas por palavra e por
  código de PDM ou de classe.
- Documenta os endpoints disponíveis e formaliza as etapas obrigatórias para a
  incorporação de novos endpoints.
