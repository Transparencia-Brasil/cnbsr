# cnbsr 0.0.0.9002

- Adiciona um snippet de uso para consultar itens, características e valores
  por PDM e explorar a coluna-lista retornada pela API.
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
