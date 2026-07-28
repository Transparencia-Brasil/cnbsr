empty_pdm_parcial <- function() {
  tibble::tibble(
    codigoPdm = integer(),
    nomePdm = character(),
    statusPdm = logical(),
    codigoConjunto = integer(),
    nomeAcentuadoConjunto = character(),
    codigoClasse = integer(),
    nomeClasse = character(),
    codigoGrupo = integer(),
    nomeGrupo = character()
  )
}

#' Recuperar dados básicos de PDM por código
#'
#' Consulta o endpoint `dadosbasicospdmporcodigo` do catálogo de Materiais do
#' CNBS para recuperar os dados básicos e a hierarquia de um PDM.
#'
#' @param codigo_pdm Número inteiro positivo correspondente ao código do PDM.
#'
#' @return Um `tibble` com uma linha e as nove colunas retornadas pela API.
#'   Uma consulta válida sem resultado retorna zero linhas e as mesmas nove
#'   colunas.
#'
#' @examples
#' \dontrun{
#' get_dados_basicos_pdm_por_codigo(17708)
#' }
#'
#' @export
get_dados_basicos_pdm_por_codigo <- function(codigo_pdm) { # nolint
  codigo_pdm <- check_codigo_pdm(codigo_pdm)

  cnbs_request("dadosbasicospdmporcodigo") |>
    httr2::req_url_query(codigoPdm = codigo_pdm) |>
    cnbs_perform() |>
    cnbs_response_object_tibble(
      empty = empty_pdm_parcial()
    )
}
