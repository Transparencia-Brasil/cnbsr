codigo_pdm_classe_rows <- function() {
  list(
    list(
      codigoPDM = 348L,
      codigoPdm = 348L,
      codigoClasse = 6505L,
      codigoGrupo = 65L,
      descricaoPDM = "Cimetidina",
      nomePdm = "Cimetidina",
      descricaoClasse = "Drogas E Medicamentos",
      nomeClasse = "Drogas E Medicamentos",
      descricaoGrupo = "Equipamentos Médicos",
      statusPDM = TRUE,
      statusClasse = TRUE,
      statusGrupo = TRUE
    ),
    list(
      codigoPDM = 357L,
      codigoPdm = 357L,
      codigoClasse = 6505L,
      codigoGrupo = 65L,
      descricaoPDM = "Penicilina G Benzatina",
      nomePdm = "Penicilina G Benzatina",
      descricaoClasse = "Drogas E Medicamentos",
      nomeClasse = "Drogas E Medicamentos",
      descricaoGrupo = "Equipamentos Médicos",
      statusPDM = FALSE,
      statusClasse = TRUE,
      statusGrupo = TRUE
    )
  )
}

test_that("a URL-base e o caminho do endpoint são construídos corretamente", {
  observed_url <- NULL
  httr2::local_mocked_responses(function(req) {
    observed_url <<- req$url
    httr2::response_json(body = codigo_pdm_classe_rows())
  })

  get_codigo_pdm_classe(6505)

  expect_equal(
    observed_url,
    paste0(cnbs_base_url(), "/codigoPdmClasse?codigoPdmClasse=6505")
  )
})

test_that("os flags são omitidos ou encaminhados sem reinterpretação", {
  observed_urls <- character()
  httr2::local_mocked_responses(function(req) {
    observed_urls <<- c(observed_urls, req$url)
    httr2::response_json(body = codigo_pdm_classe_rows())
  })

  get_codigo_pdm_classe(6505)
  get_codigo_pdm_classe(6505, busca_classe = FALSE, busca_pdm = TRUE)
  get_codigo_pdm_classe(6505, busca_classe = TRUE, busca_pdm = FALSE)

  expect_false(grepl("buscaClasse|buscaPdm", observed_urls[[1]]))
  expect_match(observed_urls[[2]], "buscaClasse=FALSE")
  expect_match(observed_urls[[2]], "buscaPdm=TRUE")
  expect_match(observed_urls[[3]], "buscaClasse=TRUE")
  expect_match(observed_urls[[3]], "buscaPdm=FALSE")
})

test_that("a resposta preserva registros e as 12 colunas da API", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(url = req$url, body = codigo_pdm_classe_rows())
  })

  result <- get_codigo_pdm_classe(6505)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 2L)
  expect_identical(
    names(result),
    c(
      "codigoPDM", "codigoPdm", "codigoClasse", "codigoGrupo",
      "descricaoPDM", "nomePdm", "descricaoClasse", "nomeClasse",
      "descricaoGrupo", "statusPDM", "statusClasse", "statusGrupo"
    )
  )
  expect_identical(result$statusPDM, c(TRUE, FALSE))
})

test_that("uma resposta vazia mantém o esquema estável", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(url = req$url, body = list())
  })

  result <- get_codigo_pdm_classe(99999999)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0L)
  expect_identical(result, empty_codigo_pdm_classe())
})

test_that("os argumentos são validados antes da requisição", {
  invalid_codes <- list(NULL, NA, 0, -1, 1.5, Inf, "6505", c(6505, 6506))
  for (value in invalid_codes) {
    expect_error(
      get_codigo_pdm_classe(value),
      "número inteiro positivo escalar",
      fixed = TRUE
    )
  }

  invalid_flags <- list(NA, 1, "true", c(TRUE, FALSE))
  for (value in invalid_flags) {
    expect_error(
      get_codigo_pdm_classe(6505, busca_classe = value),
      "`busca_classe` deve ser `NULL`, `TRUE` ou `FALSE`.",
      fixed = TRUE
    )
    expect_error(
      get_codigo_pdm_classe(6505, busca_pdm = value),
      "`busca_pdm` deve ser `NULL`, `TRUE` ou `FALSE`.",
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
    get_codigo_pdm_classe(6505),
    "Falha ao consultar a API do CNBS",
    fixed = TRUE
  )
})

test_that("conteúdo não JSON e estruturas incompatíveis produzem erro", {
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
    get_codigo_pdm_classe(6505),
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
    get_codigo_pdm_classe(6505),
    "estrutura incompatível com uma tabela",
    fixed = TRUE
  )
})
