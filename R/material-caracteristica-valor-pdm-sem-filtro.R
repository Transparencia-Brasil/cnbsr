check_codigo_pdm <- function(x) {
  valid <- is.numeric(x) &&
    length(x) == 1L &&
    !is.na(x) &&
    is.finite(x) &&
    x > 0 &&
    x == floor(x) &&
    x <= .Machine$integer.max

  if (!valid) {
    stop(
      "`codigo_pdm` deve ser um n\u00famero inteiro positivo escalar.",
      call. = FALSE
    )
  }

  as.integer(x)
}

empty_busca_item <- function() {
  tibble::tibble(
    codigoPdm = integer(),
    codigoItem = integer(),
    nomePdm = character(),
    statusItem = logical(),
    itemSuspenso = logical(),
    itemSustentavel = logical(),
    itemExclusivoUasgCentral = logical(),
    codigoClasse = integer(),
    codigoNcm = character(),
    nomeNcm = character(),
    aplicaMargemPreferencia = logical(),
    buscaItemCaracteristica = list()
  )
}

#' Recuperar itens, características e valores por PDM
#'
#' Consulta o endpoint `materialCaracteristicaValorPdmSemFiltro` do catálogo
#' de Materiais do CNBS. A resposta é preservada como fornecida pela API,
#' mantendo `buscaItemCaracteristica` como uma coluna-lista.
#'
#' @param codigo_pdm Número inteiro positivo correspondente ao código do PDM.
#'
#' @return Um `tibble` com uma linha por item e as 12 colunas retornadas pela
#'   API. A coluna `buscaItemCaracteristica` contém as características e os
#'   valores associados a cada item. Uma consulta válida sem resultados
#'   retorna zero linhas e as mesmas 12 colunas.
#'
#' @examples
#' \dontrun{
#' get_material_caracteristica_valor_pdm_sem_filtro(348)
#' }
#'
#' @export
get_material_caracteristica_valor_pdm_sem_filtro <- function(codigo_pdm) { # nolint
  codigo_pdm <- check_codigo_pdm(codigo_pdm)

  cnbs_request("materialCaracteristicaValorPdmSemFiltro") |>
    httr2::req_url_query(codigo_pdm = codigo_pdm) |>
    cnbs_perform() |>
    cnbs_response_tibble(
      empty = empty_busca_item()
    )
}
