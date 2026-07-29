check_codigo_pdm_classe <- function(x) {
  valid <- is.numeric(x) &&
    length(x) == 1L &&
    !is.na(x) &&
    is.finite(x) &&
    x > 0 &&
    x == floor(x) &&
    x <= .Machine$integer.max

  if (!valid) {
    stop(
      "`codigo_pdm_classe` deve ser um n\u00famero inteiro positivo escalar.",
      call. = FALSE
    )
  }

  as.integer(x)
}

check_optional_flag <- function(x, arg) {
  if (is.null(x)) {
    return(NULL)
  }

  if (!is.logical(x) || length(x) != 1L || is.na(x)) {
    stop(
      sprintf("`%s` deve ser `NULL`, `TRUE` ou `FALSE`.", arg),
      call. = FALSE
    )
  }

  x
}

#' Recuperar PDMs por código de PDM ou de classe
#'
#' Consulta o endpoint `codigoPdmClasse` do catálogo de Materiais do CNBS. O
#' retorno segue o esquema público `ElasticPdm`, com nomes, ordem e tipos
#' estáveis.
#'
#' @param codigo_pdm_classe Número inteiro positivo correspondente a um código
#'   de PDM ou de classe.
#' @param busca_classe `NULL`, `TRUE` ou `FALSE`. Quando diferente de `NULL`, é
#'   enviado como o parâmetro `buscaClasse`.
#' @param busca_pdm `NULL`, `TRUE` ou `FALSE`. Quando diferente de `NULL`, é
#'   enviado como o parâmetro `buscaPdm`.
#'
#' @return Um `tibble` com todos os registros e campos retornados pela API. Uma
#'   consulta válida sem resultados retorna zero linhas e as mesmas 12 colunas.
#'
#' @examples
#' \dontrun{
#' get_codigo_pdm_classe(6505)
#' get_codigo_pdm_classe(6505, busca_classe = TRUE)
#' }
#'
#' @export
get_codigo_pdm_classe <- function(
  codigo_pdm_classe,
  busca_classe = NULL,
  busca_pdm = NULL
) {
  codigo_pdm_classe <- check_codigo_pdm_classe(codigo_pdm_classe)
  busca_classe <- check_optional_flag(busca_classe, "busca_classe")
  busca_pdm <- check_optional_flag(busca_pdm, "busca_pdm")

  req <- cnbs_request("codigoPdmClasse") |>
    httr2::req_url_query(codigoPdmClasse = codigo_pdm_classe)

  if (!is.null(busca_classe)) {
    req <- httr2::req_url_query(req, buscaClasse = busca_classe)
  }
  if (!is.null(busca_pdm)) {
    req <- httr2::req_url_query(req, buscaPdm = busca_pdm)
  }

  req |>
    cnbs_perform() |>
    cnbs_response_tibble(
      empty = empty_elastic_pdm()
    )
}
