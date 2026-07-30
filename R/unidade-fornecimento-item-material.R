empty_unidades_item <- function() {
  tibble::tibble(
    siglaUnidadeFornecimento = character(),
    nomeUnidadeFornecimento = character(),
    capacidadeUnidadeMedida = double(),
    siglaUnidadeMedida = character(),
    nomeUnidadeMedida = character()
  )
}

#' Recuperar unidades de fornecimento de um item de material
#'
#' Consulta o endpoint `unidadeFornecimentoPorCodigoItemMaterial` do catálogo
#' de Materiais do CNBS para recuperar as unidades de fornecimento associadas a
#' um item.
#'
#' @param codigo_item_material Número inteiro positivo correspondente ao código
#'   do item de material.
#'
#' @return Um `tibble` com uma linha por unidade de fornecimento e as colunas
#'   `siglaUnidadeFornecimento`, `nomeUnidadeFornecimento`,
#'   `capacidadeUnidadeMedida`, `siglaUnidadeMedida` e `nomeUnidadeMedida`. Uma
#'   consulta válida sem resultados retorna zero linhas e as mesmas colunas.
#'
#' @examples
#' \dontrun{
#' get_unidade_fornecimento_por_codigo_item_material(267203)
#' }
#'
#' @export
get_unidade_fornecimento_por_codigo_item_material <- function( # nolint
  codigo_item_material
) {
  codigo_item_material <- check_codigo_item_material(codigo_item_material)

  cnbs_request("unidadeFornecimentoPorCodigoItemMaterial") |>
    httr2::req_url_query(codigo_item_material = codigo_item_material) |>
    cnbs_perform() |>
    cnbs_response_tibble(
      empty = empty_unidades_item()
    )
}
