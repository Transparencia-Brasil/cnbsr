check_required_text <- function(x, arg) {
  valid <- is.character(x) &&
    length(x) == 1L &&
    !is.na(x) &&
    nzchar(trimws(x))

  if (!valid) {
    stop(
      sprintf("`%s` deve ser um texto n\u00e3o vazio escalar.", arg),
      call. = FALSE
    )
  }

  x
}

check_optional_text <- function(x, arg) {
  if (is.null(x)) {
    return(NULL)
  }

  check_required_text(x, arg)
}

#' Buscar materiais por palavra
#'
#' Consulta o endpoint `palavra` do catálogo de Materiais do CNBS. A resposta
#' é preservada como fornecida pela API, sem renomear, filtrar, ordenar ou
#' normalizar campos.
#'
#' @param palavra Texto não vazio usado na busca por materiais.
#' @param apenas_ativos `NULL` ou texto não vazio. Quando diferente de `NULL`,
#'   é enviado literalmente como o parâmetro `apenasAtivos`, sem interpretação
#'   pelo pacote.
#'
#' @return Um `tibble` com todos os registros e campos retornados pela API. Uma
#'   consulta válida sem resultados retorna zero linhas e as mesmas 12 colunas.
#'
#' @examples
#' \dontrun{
#' get_busca_material_por_palavra("caneta")
#' get_busca_material_por_palavra("caneta", apenas_ativos = "true")
#' }
#'
#' @export
get_busca_material_por_palavra <- function(palavra, apenas_ativos = NULL) {
  palavra <- check_required_text(palavra, "palavra")
  apenas_ativos <- check_optional_text(apenas_ativos, "apenas_ativos")

  req <- cnbs_request("palavra") |>
    httr2::req_url_query(palavra = palavra)

  if (!is.null(apenas_ativos)) {
    req <- httr2::req_url_query(req, apenasAtivos = apenas_ativos)
  }

  req |>
    cnbs_perform() |>
    cnbs_response_tibble(
      empty = empty_elastic_pdm()
    )
}
