empty_item_material_siasgnet <- function() {
  tibble::tibble(
    nomeItem = character(),
    statusItem = logical(),
    statusNaoSisg = logical(),
    itemSustentavel = logical(),
    itemExclusivoUasgCentral = logical(),
    itemSuspenso = logical()
  )
}

#' Recuperar dados de um item de material para o SIASGnet
#'
#' Consulta o endpoint `dadosItemMaterialporCodigoSiasgnet` do catálogo de
#' Materiais do CNBS para recuperar o nome e os indicadores de um item.
#'
#' @param codigo_item_material Número inteiro positivo correspondente ao código
#'   do item de material.
#'
#' @return Um `tibble` com uma linha e as seis colunas retornadas pela API.
#'   Falhas HTTP, inclusive as produzidas por códigos inexistentes, geram um
#'   erro informativo.
#'
#' @examples
#' \dontrun{
#' get_dados_item_material_por_codigo_siasgnet(267203)
#' }
#'
#' @export
get_dados_item_material_por_codigo_siasgnet <- function( # nolint
  codigo_item_material
) {
  codigo_item_material <- check_codigo_item_material(codigo_item_material)

  cnbs_request("dadosItemMaterialporCodigoSiasgnet") |>
    httr2::req_url_query(codigoItemMaterial = codigo_item_material) |>
    cnbs_perform() |>
    cnbs_response_object_tibble(
      empty = empty_item_material_siasgnet()
    )
}
