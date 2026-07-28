item_material_siasgnet <- function() {
  list(
    nomeItem = "Dipirona Sódica, Dosagem:500 MG",
    statusItem = TRUE,
    statusNaoSisg = FALSE,
    itemSustentavel = FALSE,
    itemExclusivoUasgCentral = FALSE,
    itemSuspenso = FALSE
  )
}

test_that("a URL e o código do item SIASGnet são construídos corretamente", {
  observed_url <- NULL
  httr2::local_mocked_responses(function(req) {
    observed_url <<- req$url
    httr2::response_json(body = item_material_siasgnet())
  })

  get_dados_item_material_por_codigo_siasgnet(267203)

  expect_equal(
    observed_url,
    paste0(
      cnbs_base_url(),
      "/dadosItemMaterialporCodigoSiasgnet?codigoItemMaterial=267203"
    )
  )
})

test_that("a resposta preserva o nome e os indicadores do item", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(url = req$url, body = item_material_siasgnet())
  })

  result <- get_dados_item_material_por_codigo_siasgnet(267203)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 1L)
  expect_identical(names(result), names(empty_item_material_siasgnet()))
  expect_identical(result$nomeItem, "Dipirona Sódica, Dosagem:500 MG")
  expect_identical(result$statusItem, TRUE)
  expect_identical(result$statusNaoSisg, FALSE)
  expect_identical(result$itemSustentavel, FALSE)
  expect_identical(result$itemExclusivoUasgCentral, FALSE)
  expect_identical(result$itemSuspenso, FALSE)
})

test_that("codigo_item_material é validado antes da requisição", {
  invalid_codes <- list(
    NULL, NA, 0, -1, 1.5, Inf, "267203", c(267203, 267204),
    .Machine$integer.max + 1
  )

  for (value in invalid_codes) {
    expect_error(
      get_dados_item_material_por_codigo_siasgnet(value),
      paste0(
        "`codigo_item_material` deve ser um número inteiro ",
        "positivo escalar."
      ),
      fixed = TRUE
    )
  }
})

test_that("código inexistente produz um erro HTTP informativo", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(
      status_code = 500,
      url = req$url,
      body = list(
        status = 500L,
        error = "Internal Server Error"
      )
    )
  })

  expect_error(
    get_dados_item_material_por_codigo_siasgnet(99999999),
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
    get_dados_item_material_por_codigo_siasgnet(267203),
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
    get_dados_item_material_por_codigo_siasgnet(267203),
    "estrutura incompatível com um objeto",
    fixed = TRUE
  )
})
