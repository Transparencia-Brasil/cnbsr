dados_basicos_pdm <- function() {
  list(
    codigoPdm = 17708L,
    nomePdm = "Dipirona Sódica",
    statusPdm = TRUE,
    codigoConjunto = 163929L,
    nomeAcentuadoConjunto = "MEDICAMENTO",
    codigoClasse = 6505L,
    nomeClasse = "Drogas E Medicamentos",
    codigoGrupo = 65L,
    nomeGrupo = paste(
      "Equipamentos E Artigos Para Uso Médico, Dentário E Veterinário"
    )
  )
}

test_that("a URL e o código do PDM são construídos corretamente", {
  observed_url <- NULL
  httr2::local_mocked_responses(function(req) {
    observed_url <<- req$url
    httr2::response_json(body = dados_basicos_pdm())
  })

  get_dados_basicos_pdm_por_codigo(17708)

  expect_equal(
    observed_url,
    paste0(cnbs_base_url(), "/dadosbasicospdmporcodigo?codigoPdm=17708")
  )
})

test_that("a resposta preserva os dados básicos e a hierarquia", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(url = req$url, body = dados_basicos_pdm())
  })

  result <- get_dados_basicos_pdm_por_codigo(17708)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 1L)
  expect_identical(names(result), names(empty_pdm_parcial()))
  expect_identical(result$codigoPdm, 17708L)
  expect_identical(result$statusPdm, TRUE)
  expect_identical(result$nomePdm, "Dipirona Sódica")
})

test_that("uma resposta 204 mantém o esquema PdmParcial", {
  httr2::local_mocked_responses(function(req) {
    httr2::new_response(
      method = "GET",
      url = req$url,
      status_code = 204,
      headers = list(),
      body = raw()
    )
  })

  result <- get_dados_basicos_pdm_por_codigo(99999999)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0L)
  expect_identical(result, empty_pdm_parcial())
})

test_that("codigo_pdm é validado antes da requisição", {
  invalid_codes <- list(
    NULL, NA, 0, -1, 1.5, Inf, "17708", c(17708, 17709),
    .Machine$integer.max + 1
  )

  for (value in invalid_codes) {
    expect_error(
      get_dados_basicos_pdm_por_codigo(value),
      "`codigo_pdm` deve ser um número inteiro positivo escalar.",
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
    get_dados_basicos_pdm_por_codigo(17708),
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
    get_dados_basicos_pdm_por_codigo(17708),
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
    get_dados_basicos_pdm_por_codigo(17708),
    "estrutura incompatível com um objeto",
    fixed = TRUE
  )
})
