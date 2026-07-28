# Consulta os itens, características e valores de um PDM.
itens <- cnbsr::get_material_caracteristica_valor_pdm_sem_filtro(
  codigo_pdm = 348
)

# Inspeciona o resultado tabular.
itens

# A coluna-lista contém uma tabela de características por item.
caracteristicas_primeiro_item <- itens$buscaItemCaracteristica[[1L]]
caracteristicas_primeiro_item

# Exibe somente o código e o nome dos itens retornados.
itens[, c("codigoItem", "nomePdm")]
