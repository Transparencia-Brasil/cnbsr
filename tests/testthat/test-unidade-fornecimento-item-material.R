unidades_item_json <- function() {
  paste0(
    '[{"siglaUnidadeFornecimento":"AM",',
    '"nomeUnidadeFornecimento":"Ampola",',
    '"capacidadeUnidadeMedida":2,',
    '"siglaUnidadeMedida":"ML",',
    '"nomeUnidadeMedida":"Mililitro"},',
    '{"siglaUnidadeFornecimento":"COMPR",',
    '"nomeUnidadeFornecimento":"Comprimido",',
    '"capacidadeUnidadeMedida":0,',
    '"siglaUnidadeMedida":null,',
    '"nomeUnidadeMedida":null}]'
  )
}

response_unidades_fornecimento <- function(req) {
  httr2::new_response(
    method = "GET",
    url = req$url,
    status_code = 200,
    headers = list(`content-type` = "application/json"),
    body = charToRaw(unidades_item_json())
  )
}

test_that("a URL da consulta de unidades é construída corretamente", {
  observed_url <- NULL
  httr2::local_mocked_responses(function(req) {
    observed_url <<- req$url
    response_unidades_fornecimento(req)
  })

  get_unidade_fornecimento_por_codigo_item_material(267203)

  expect_equal(
    observed_url,
    paste0(
      cnbs_base_url(),
      "/unidadeFornecimentoPorCodigoItemMaterial?",
      "codigo_item_material=267203"
    )
  )
})

test_that("unidades de fornecimento preservam nomes, ordem e tipos", {
  httr2::local_mocked_responses(function(req) {
    response_unidades_fornecimento(req)
  })

  result <- get_unidade_fornecimento_por_codigo_item_material(267203)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 2L)
  expect_identical(
    names(result),
    names(empty_unidades_item())
  )
  expect_type(result$capacidadeUnidadeMedida, "double")
  expect_identical(result$siglaUnidadeMedida, c("ML", NA_character_))
  expect_identical(result$nomeUnidadeMedida, c("Mililitro", NA_character_))
})

test_that("array vazio mantém o esquema de unidades de fornecimento", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(url = req$url, body = list())
  })

  expect_message(
    result <- get_unidade_fornecimento_por_codigo_item_material(99999999),
    "zero resultados",
    fixed = TRUE
  )
  expect_identical(result, empty_unidades_item())
})

test_that("código do item é validado antes da consulta de unidades", {
  invalid_codes <- list(
    NULL, NA, 0, -1, 1.5, Inf, "267203", c(267203, 267204),
    .Machine$integer.max + 1
  )

  for (value in invalid_codes) {
    expect_error(
      get_unidade_fornecimento_por_codigo_item_material(value),
      "`codigo_item_material` deve ser um número inteiro positivo escalar.",
      fixed = TRUE
    )
  }
})

test_that("estrutura incompatível de unidade de fornecimento produz erro", {
  invalid_bodies <- list(
    list(list(
      siglaUnidadeFornecimento = "AM",
      nomeUnidadeFornecimento = "Ampola",
      capacidadeUnidadeMedida = "2",
      siglaUnidadeMedida = "ML",
      nomeUnidadeMedida = "Mililitro"
    )),
    list(list(
      siglaUnidadeFornecimento = "AM",
      nomeUnidadeFornecimento = "Ampola",
      capacidadeUnidadeMedida = 2,
      siglaUnidadeMedida = "ML"
    )),
    list(list(
      siglaUnidadeFornecimento = "AM",
      nomeUnidadeFornecimento = "Ampola",
      capacidadeUnidadeMedida = 2,
      siglaUnidadeMedida = "ML",
      nomeUnidadeMedida = "Mililitro",
      extra = TRUE
    ))
  )

  for (body in invalid_bodies) {
    httr2::local_mocked_responses(function(req) {
      httr2::response_json(url = req$url, body = body)
    })
    expect_error(
      get_unidade_fornecimento_por_codigo_item_material(267203),
      "estrutura incompatível",
      fixed = TRUE
    )
  }
})

test_that("falha HTTP e JSON inválido produzem erros informativos", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(status_code = 500, url = req$url, body = list())
  })
  expect_error(
    get_unidade_fornecimento_por_codigo_item_material(267203),
    "Falha ao consultar a API do CNBS",
    fixed = TRUE
  )

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
    get_unidade_fornecimento_por_codigo_item_material(267203),
    "resposta JSON inválida",
    fixed = TRUE
  )
})
