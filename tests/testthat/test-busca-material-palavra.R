busca_material_palavra_rows <- function() {
  list(
    list(
      codigoPDM = 4416L,
      codigoPdm = 4416L,
      codigoClasse = 7520L,
      codigoGrupo = 75L,
      descricaoPDM = "Caneta permanente",
      nomePdm = "Caneta permanente",
      descricaoClasse = "Acessórios e dispositivos para escritório",
      nomeClasse = "Acessórios e dispositivos para escritório",
      descricaoGrupo = "Utensílios de escritório e material de expediente",
      statusPDM = TRUE,
      statusClasse = TRUE,
      statusGrupo = TRUE
    ),
    list(
      codigoPDM = 10412L,
      codigoPdm = 10412L,
      codigoClasse = 7510L,
      codigoGrupo = 75L,
      descricaoPDM = "Caneta esferográfica",
      nomePdm = "Caneta esferográfica",
      descricaoClasse = "Artigos para escritório",
      nomeClasse = "Artigos para escritório",
      descricaoGrupo = "Utensílios de escritório e material de expediente",
      statusPDM = FALSE,
      statusClasse = TRUE,
      statusGrupo = TRUE
    )
  )
}

test_that("a URL e o parâmetro obrigatório são construídos corretamente", {
  observed_url <- NULL
  httr2::local_mocked_responses(function(req) {
    observed_url <<- req$url
    httr2::response_json(body = busca_material_palavra_rows())
  })

  get_busca_material_por_palavra("caneta")

  expect_equal(
    observed_url,
    paste0(cnbs_base_url(), "/palavra?palavra=caneta")
  )
})

test_that("texto e parâmetro opcional são codificados e encaminhados", {
  observed_url <- NULL
  httr2::local_mocked_responses(function(req) {
    observed_url <<- req$url
    httr2::response_json(body = busca_material_palavra_rows())
  })

  get_busca_material_por_palavra(
    "café com açúcar",
    apenas_ativos = "somente ativos"
  )

  expect_match(observed_url, "palavra=caf%C3%A9%20com%20a%C3%A7%C3%BAcar")
  expect_match(observed_url, "apenasAtivos=somente%20ativos")
})

test_that("apenas_ativos é omitido ou encaminhado literalmente", {
  observed_urls <- character()
  httr2::local_mocked_responses(function(req) {
    observed_urls <<- c(observed_urls, req$url)
    httr2::response_json(body = busca_material_palavra_rows())
  })

  get_busca_material_por_palavra("caneta")
  get_busca_material_por_palavra("caneta", apenas_ativos = "FALSE")

  expect_false(grepl("apenasAtivos", observed_urls[[1]]))
  expect_match(observed_urls[[2]], "apenasAtivos=FALSE")
})

test_that("a resposta preserva registros e as 12 colunas da API", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(url = req$url, body = busca_material_palavra_rows())
  })

  result <- get_busca_material_por_palavra("caneta")

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

test_that("uma resposta vazia mantém o esquema ElasticPdm", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(url = req$url, body = list())
  })

  result <- get_busca_material_por_palavra("termo inexistente")

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0L)
  expect_identical(result, empty_elastic_pdm())
})

test_that("os argumentos são validados antes da requisição", {
  invalid_terms <- list(
    NULL, NA_character_, "", "   ", 1, character(), c("caneta", "lápis")
  )
  for (value in invalid_terms) {
    expect_error(
      get_busca_material_por_palavra(value),
      "`palavra` deve ser um texto não vazio escalar.",
      fixed = TRUE
    )
  }

  invalid_filters <- list(
    NA_character_, "", "   ", TRUE, character(), c("true", "false")
  )
  for (value in invalid_filters) {
    expect_error(
      get_busca_material_por_palavra("caneta", apenas_ativos = value),
      "`apenas_ativos` deve ser um texto não vazio escalar.",
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
    get_busca_material_por_palavra("caneta"),
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
    get_busca_material_por_palavra("caneta"),
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
    get_busca_material_por_palavra("caneta"),
    "estrutura incompatível com uma tabela",
    fixed = TRUE
  )
})
