check_codigo_item_material <- function(x) {
  valid <- is.numeric(x) &&
    length(x) == 1L &&
    !is.na(x) &&
    is.finite(x) &&
    x > 0 &&
    x == floor(x) &&
    x <= .Machine$integer.max

  if (!valid) {
    stop(
      paste0(
        "`codigo_item_material` deve ser um n\u00famero inteiro ",
        "positivo escalar."
      ),
      call. = FALSE
    )
  }

  as.integer(x)
}

empty_descricao_item <- function() {
  tibble::tibble(
    descricaoItem = character()
  )
}

#' Recuperar a descrição de um item de material por código
#'
#' Consulta o endpoint `dadosItemMaterialporCodigo` do catálogo de Materiais
#' do CNBS para recuperar a descrição completa de um item.
#'
#' @param codigo_item_material Número inteiro positivo correspondente ao código
#'   do item de material.
#'
#' @return Um `tibble` com uma linha e a coluna `descricaoItem`. Uma consulta
#'   válida sem resultado retorna zero linhas e a mesma coluna.
#'
#' @examples
#' \dontrun{
#' get_dados_item_material_por_codigo(267203)
#' }
#'
#' @export
get_dados_item_material_por_codigo <- function( # nolint
  codigo_item_material
) {
  codigo_item_material <- check_codigo_item_material(codigo_item_material)

  cnbs_request("dadosItemMaterialporCodigo") |>
    httr2::req_url_query(codigo_item_material = codigo_item_material) |>
    cnbs_perform() |>
    cnbs_response_object_tibble(
      empty = empty_descricao_item()
    )
}
