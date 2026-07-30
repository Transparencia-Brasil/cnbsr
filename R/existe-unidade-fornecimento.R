check_codigo_item <- function(x) {
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
        "`codigo_item` deve ser um n\u00famero inteiro positivo ",
        "escalar."
      ),
      call. = FALSE
    )
  }

  as.integer(x)
}

#' Verificar a existência de uma unidade de fornecimento
#'
#' Consulta o endpoint `existeunidadefornecimento` do catálogo de Materiais do
#' CNBS para verificar se uma combinação de item e unidade de fornecimento
#' existe.
#'
#' @param codigo_item Número inteiro positivo correspondente ao código do item.
#' @param sigla_unidade_fornecimento_pdm Texto não vazio com a sigla da unidade
#'   de fornecimento do PDM.
#' @param capacidade_unidade_fornecimento `NULL` ou texto não vazio com a
#'   capacidade da unidade de fornecimento. Quando `NULL`, o parâmetro é
#'   omitido.
#' @param sigla_unidade_medida `NULL` ou texto não vazio com a sigla da unidade
#'   de medida. Quando `NULL`, o parâmetro é omitido.
#'
#' @return Um valor lógico escalar: `TRUE` quando a unidade de fornecimento
#'   existe para o item e `FALSE` caso contrário.
#'
#' @examples
#' \dontrun{
#' existe_unidade_fornecimento(
#'   267203,
#'   "AM",
#'   capacidade_unidade_fornecimento = "2.0",
#'   sigla_unidade_medida = "ML"
#' )
#' }
#'
#' @export
existe_unidade_fornecimento <- function(
  codigo_item,
  sigla_unidade_fornecimento_pdm,
  capacidade_unidade_fornecimento = NULL, # nolint
  sigla_unidade_medida = NULL
) {
  codigo_item <- check_codigo_item(codigo_item)
  sigla_unidade_fornecimento_pdm <- check_required_text(
    sigla_unidade_fornecimento_pdm,
    "sigla_unidade_fornecimento_pdm"
  )
  capacidade_unidade_fornecimento <- check_optional_text( # nolint
    capacidade_unidade_fornecimento,
    "capacidade_unidade_fornecimento"
  )
  sigla_unidade_medida <- check_optional_text(
    sigla_unidade_medida,
    "sigla_unidade_medida"
  )

  req <- cnbs_request("existeunidadefornecimento") |>
    httr2::req_url_query(
      codigoItem = codigo_item,
      siglaUnidadeFornecimentoPDM = sigla_unidade_fornecimento_pdm
    )

  if (!is.null(capacidade_unidade_fornecimento)) {
    req <- httr2::req_url_query(
      req,
      capacidadeUnidadeFornecimento = capacidade_unidade_fornecimento
    )
  }
  if (!is.null(sigla_unidade_medida)) {
    req <- httr2::req_url_query(
      req,
      siglaUnidadeMedida = sigla_unidade_medida
    )
  }

  req |>
    cnbs_perform() |>
    cnbs_response_logical()
}
