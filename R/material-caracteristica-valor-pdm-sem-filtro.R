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

check_com_filtro <- function(x) {
  valid <- is.logical(x) && length(x) == 1L && !is.na(x)

  if (!valid) {
    stop(
      "`com_filtro` deve ser um valor l\u00f3gico escalar n\u00e3o ausente.",
      call. = FALSE
    )
  }

  x
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

empty_item_caracteristica <- function() {
  tibble::tibble(
    codigoCaracteristica = character(),
    codigoValorCaracteristica = character(),
    nomeCaracteristica = character(),
    caracteristicaObrigatoria = logical(),
    statusCaracteristica = logical(),
    numeroCaracteristica = integer(),
    nomeValorCaracteristica = character(),
    siglaUnidadeMedida = character(),
    statusValorCaracteristica = logical(),
    tuplaCaracteristica = list()
  )
}

cast_tupla_caracteristica <- function(value) {
  if (is.null(value)) {
    return(character())
  }
  valid <- is.list(value) &&
    all(vapply(
      value,
      function(element) {
        is.null(element) ||
          (is.character(element) && length(element) == 1L)
      },
      logical(1)
    ))
  if (!valid) {
    cnbs_schema_error(
      "uma tabela aninhada",
      "o campo 'tuplaCaracteristica' n\u00e3o \u00e9 uma lista de textos"
    )
  }
  vapply(
    value,
    function(element) {
      if (is.null(element)) NA_character_ else element
    },
    character(1)
  )
}

cast_busca_item_caracteristica <- function(value) {
  if (is.null(value)) {
    return(empty_item_caracteristica())
  }
  cnbs_records_tibble(
    value,
    prototype = empty_item_caracteristica(),
    context = "uma tabela aninhada",
    transformers = list(
      tuplaCaracteristica = cast_tupla_caracteristica
    )
  )
}

#' Recuperar itens, características e valores por PDM
#'
#' Consulta itens, características e valores do catálogo de Materiais do CNBS.
#' O argumento `com_filtro` seleciona entre os endpoints
#' `materialCaracteristcaValorporPDM` e
#' `materialCaracteristicaValorPdmSemFiltro`. A resposta é preservada como
#' fornecida pela API, mantendo `buscaItemCaracteristica` como uma coluna-lista.
#'
#' @param codigo_pdm Número inteiro positivo correspondente ao código do PDM.
#' @param com_filtro Valor lógico escalar. Use `TRUE` para consultar
#'   `materialCaracteristcaValorporPDM` e `FALSE` para consultar
#'   `materialCaracteristicaValorPdmSemFiltro`.
#'
#' @return Um `tibble` com uma linha por item e as 12 colunas retornadas pela
#'   API. A coluna `buscaItemCaracteristica` contém as características e os
#'   valores associados a cada item. Uma consulta válida sem resultados
#'   retorna zero linhas e as mesmas 12 colunas.
#'
#' @examples
#' \dontrun{
#' get_material_caracteristica_valor_pdm(348, com_filtro = TRUE)
#' get_material_caracteristica_valor_pdm(348, com_filtro = FALSE)
#' }
#'
#' @export
get_material_caracteristica_valor_pdm <- function(codigo_pdm, com_filtro) { # nolint
  codigo_pdm <- check_codigo_pdm(codigo_pdm)
  com_filtro <- check_com_filtro(com_filtro)

  endpoint <- if (com_filtro) {
    "materialCaracteristcaValorporPDM"
  } else {
    "materialCaracteristicaValorPdmSemFiltro"
  }

  cnbs_request(endpoint) |>
    httr2::req_url_query(codigo_pdm = codigo_pdm) |>
    cnbs_perform() |>
    cnbs_response_tibble(
      empty = empty_busca_item(),
      transformers = list(
        buscaItemCaracteristica = cast_busca_item_caracteristica
      )
    )
}

#' Recuperar itens, características e valores por PDM sem filtro
#'
#' Função mantida por compatibilidade com a versão 0.1.0. Equivale a chamar
#' [get_material_caracteristica_valor_pdm()] com `com_filtro = FALSE`.
#'
#' @inheritParams get_material_caracteristica_valor_pdm
#'
#' @return Um `tibble` com o mesmo contrato documentado em
#'   [get_material_caracteristica_valor_pdm()].
#'
#' @examples
#' \dontrun{
#' get_material_caracteristica_valor_pdm_sem_filtro(348)
#' }
#'
#' @export
get_material_caracteristica_valor_pdm_sem_filtro <- function(codigo_pdm) { # nolint
  get_material_caracteristica_valor_pdm(codigo_pdm, com_filtro = FALSE)
}
