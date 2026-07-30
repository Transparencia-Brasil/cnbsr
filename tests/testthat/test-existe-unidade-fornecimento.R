mock_boolean_response <- function(value, env = parent.frame()) {
  httr2::local_mocked_responses(function(req) {
    httr2::new_response(
      method = "GET",
      url = req$url,
      status_code = 200,
      headers = list(`content-type` = "application/json"),
      body = charToRaw(value)
    )
  }, env = env)
}

test_that("todos os parâmetros da consulta de existência são enviados", {
  observed_url <- NULL
  httr2::local_mocked_responses(function(req) {
    observed_url <<- req$url
    httr2::new_response(
      method = "GET",
      url = req$url,
      status_code = 200,
      headers = list(`content-type` = "application/json"),
      body = charToRaw("true")
    )
  })

  result <- existe_unidade_fornecimento(
    267203,
    "AM",
    capacidade_unidade_fornecimento = "2.0",
    sigla_unidade_medida = "ML"
  )

  expect_equal(
    observed_url,
    paste0(
      cnbs_base_url(),
      "/existeunidadefornecimento?codigoItem=267203&",
      "siglaUnidadeFornecimentoPDM=AM&",
      "capacidadeUnidadeFornecimento=2.0&siglaUnidadeMedida=ML"
    )
  )
  expect_identical(result, TRUE)
})

test_that("parâmetros opcionais nulos são omitidos", {
  observed_url <- NULL
  httr2::local_mocked_responses(function(req) {
    observed_url <<- req$url
    httr2::new_response(
      method = "GET",
      url = req$url,
      status_code = 200,
      headers = list(`content-type` = "application/json"),
      body = charToRaw("false")
    )
  })

  result <- existe_unidade_fornecimento(267203, "AM")

  expect_equal(
    observed_url,
    paste0(
      cnbs_base_url(),
      "/existeunidadefornecimento?codigoItem=267203&",
      "siglaUnidadeFornecimentoPDM=AM"
    )
  )
  expect_identical(result, FALSE)
})

test_that("a resposta é um lógico escalar estrito", {
  mock_boolean_response("true")
  expect_identical(existe_unidade_fornecimento(267203, "AM"), TRUE)

  mock_boolean_response("false")
  expect_identical(existe_unidade_fornecimento(267203, "AM"), FALSE)

  for (value in c("null", '"true"', "1", "[]", "{}")) {
    mock_boolean_response(value)
    expect_error(
      existe_unidade_fornecimento(267203, "AM"),
      "estrutura incompatível com um valor lógico",
      fixed = TRUE
    )
  }
})

test_that("resposta booleana vazia ou inválida produz erro", {
  mock_boolean_response(" ")
  expect_error(
    existe_unidade_fornecimento(267203, "AM"),
    "a resposta está vazia",
    fixed = TRUE
  )

  mock_boolean_response("não é JSON")
  expect_error(
    existe_unidade_fornecimento(267203, "AM"),
    "resposta JSON inválida",
    fixed = TRUE
  )
})

test_that("argumentos da consulta de existência são validados", {
  invalid_codes <- list(
    NULL, NA, 0, -1, 1.5, Inf, "267203", c(267203, 267204),
    .Machine$integer.max + 1
  )
  for (value in invalid_codes) {
    expect_error(
      existe_unidade_fornecimento(value, "AM"),
      "`codigo_item` deve ser um número inteiro positivo escalar.",
      fixed = TRUE
    )
  }

  invalid_text <- list(NULL, NA_character_, "", "   ", 1, character(), c("A", "B"))
  for (value in invalid_text) {
    expect_error(
      existe_unidade_fornecimento(267203, value),
      "`sigla_unidade_fornecimento_pdm` deve ser um texto não vazio escalar.",
      fixed = TRUE
    )
  }

  invalid_optional <- list(NA_character_, "", "   ", 2, character(), c("2", "3"))
  for (value in invalid_optional) {
    expect_error(
      existe_unidade_fornecimento(
        267203,
        "AM",
        capacidade_unidade_fornecimento = value
      ),
      "`capacidade_unidade_fornecimento` deve ser um texto não vazio escalar.",
      fixed = TRUE
    )
    expect_error(
      existe_unidade_fornecimento(
        267203,
        "AM",
        sigla_unidade_medida = value
      ),
      "`sigla_unidade_medida` deve ser um texto não vazio escalar.",
      fixed = TRUE
    )
  }
})

test_that("falha HTTP recebe mensagem do pacote", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(
      status_code = 500,
      url = req$url,
      body = list(error = "falha")
    )
  })

  expect_error(
    existe_unidade_fornecimento(267203, "AM"),
    "Falha ao consultar a API do CNBS",
    fixed = TRUE
  )
})
