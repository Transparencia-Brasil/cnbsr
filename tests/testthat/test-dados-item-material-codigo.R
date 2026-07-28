descricao_item_material <- function() {
  list(
    descricaoItem = "267203 - Dipirona Sódica, Dosagem:500 MG"
  )
}

test_that("a URL e o código do item são construídos corretamente", {
  observed_url <- NULL
  httr2::local_mocked_responses(function(req) {
    observed_url <<- req$url
    httr2::response_json(body = descricao_item_material())
  })

  get_dados_item_material_por_codigo(267203)

  expect_equal(
    observed_url,
    paste0(
      cnbs_base_url(),
      "/dadosItemMaterialporCodigo?codigo_item_material=267203"
    )
  )
})

test_that("a resposta preserva a descrição completa do item", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(url = req$url, body = descricao_item_material())
  })

  result <- get_dados_item_material_por_codigo(267203)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 1L)
  expect_identical(names(result), names(empty_descricao_item()))
  expect_identical(
    result$descricaoItem,
    "267203 - Dipirona Sódica, Dosagem:500 MG"
  )
})

test_that("uma descrição nula mantém o esquema DescricaoItem", {
  httr2::local_mocked_responses(function(req) {
    httr2::new_response(
      method = "GET",
      url = req$url,
      status_code = 200,
      headers = list(`content-type` = "application/json"),
      body = charToRaw('{"descricaoItem":null}')
    )
  })

  result <- get_dados_item_material_por_codigo(99999999)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0L)
  expect_identical(result, empty_descricao_item())
})

test_that("codigo_item_material é validado antes da requisição", {
  invalid_codes <- list(
    NULL, NA, 0, -1, 1.5, Inf, "267203", c(267203, 267204),
    .Machine$integer.max + 1
  )

  for (value in invalid_codes) {
    expect_error(
      get_dados_item_material_por_codigo(value),
      paste0(
        "`codigo_item_material` deve ser um número inteiro ",
        "positivo escalar."
      ),
      fixed = TRUE
    )
  }
})

test_that("erros HTTP recebem uma mensagem do pacote", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(
      status_code = 500,
      url = req$url,
      body = list(error = "falha")
    )
  })

  expect_error(
    get_dados_item_material_por_codigo(267203),
    "Falha ao consultar a API do CNBS",
    fixed = TRUE
  )
})

test_that("JSON inválido e estruturas incompatíveis produzem erro", {
  httr2::local_mocked_responses(function(req) {
    httr2::new_response(
      method = "GET",
      url = req$url,
      status_code = 200,
      headers = list(`content-type` = "text/plain"),
      body = charToRaw("não é JSON")
    )
  })
  expect_error(
    get_dados_item_material_por_codigo(267203),
    "resposta JSON inválida",
    fixed = TRUE
  )

  httr2::local_mocked_responses(function(req) {
    httr2::response_json(
      url = req$url,
      body = list(resultado = "inesperado")
    )
  })
  expect_error(
    get_dados_item_material_por_codigo(267203),
    "estrutura incompatível com um objeto",
    fixed = TRUE
  )
})
