material_pdm_rows <- function() {
  list(
    list(
      codigoPdm = 348L,
      codigoItem = 111L,
      nomePdm = "Cimetidina",
      statusItem = TRUE,
      itemSuspenso = FALSE,
      itemSustentavel = FALSE,
      itemExclusivoUasgCentral = FALSE,
      codigoClasse = 6505L,
      codigoNcm = "30039099",
      nomeNcm = "Outros medicamentos",
      aplicaMargemPreferencia = FALSE,
      buscaItemCaracteristica = list(
        list(
          codigoCaracteristica = "BR000001",
          codigoValorCaracteristica = "BR000010",
          nomeCaracteristica = "Forma farmac\u00eautica",
          caracteristicaObrigatoria = TRUE,
          statusCaracteristica = TRUE,
          numeroCaracteristica = 1L,
          nomeValorCaracteristica = "Comprimido",
          siglaUnidadeMedida = NA_character_,
          statusValorCaracteristica = TRUE,
          tuplaCaracteristica = list("BR000001", "BR000010")
        )
      )
    ),
    list(
      codigoPdm = 348L,
      codigoItem = 112L,
      nomePdm = "Cimetidina",
      statusItem = FALSE,
      itemSuspenso = TRUE,
      itemSustentavel = FALSE,
      itemExclusivoUasgCentral = FALSE,
      codigoClasse = 6505L,
      codigoNcm = NA_character_,
      nomeNcm = NA_character_,
      aplicaMargemPreferencia = FALSE,
      buscaItemCaracteristica = list(
        list(
          codigoCaracteristica = "BR000002",
          codigoValorCaracteristica = "BR000020",
          nomeCaracteristica = "Concentra\u00e7\u00e3o",
          caracteristicaObrigatoria = TRUE,
          statusCaracteristica = TRUE,
          numeroCaracteristica = 2L,
          nomeValorCaracteristica = "200 mg",
          siglaUnidadeMedida = "MG",
          statusValorCaracteristica = TRUE,
          tuplaCaracteristica = list("BR000002", "BR000020")
        )
      )
    )
  )
}

test_that("a URL e o c\u00f3digo do PDM s\u00e3o constru\u00eddos corretamente", {
  observed_urls <- character()
  httr2::local_mocked_responses(function(req) {
    observed_urls <<- c(observed_urls, req$url)
    httr2::response_json(body = material_pdm_rows())
  })

  get_material_caracteristica_valor_pdm(348, com_filtro = TRUE)
  get_material_caracteristica_valor_pdm(348, com_filtro = FALSE)

  expect_equal(
    observed_urls,
    c(
      paste0(
        cnbs_base_url(),
        "/materialCaracteristcaValorporPDM?codigo_pdm=348"
      ),
      paste0(
        cnbs_base_url(),
        "/materialCaracteristicaValorPdmSemFiltro?codigo_pdm=348"
      )
    )
  )
})

test_that("a função da versão 0.1.0 permanece compatível", {
  observed_url <- NULL
  httr2::local_mocked_responses(function(req) {
    observed_url <<- req$url
    httr2::response_json(body = material_pdm_rows())
  })

  result <- get_material_caracteristica_valor_pdm_sem_filtro(348)

  expect_equal(
    observed_url,
    paste0(
      cnbs_base_url(),
      "/materialCaracteristicaValorPdmSemFiltro?codigo_pdm=348"
    )
  )
  expect_s3_class(result, "tbl_df")
})

test_that("a função por PDM usa o endpoint com filtro", {
  observed_url <- NULL
  httr2::local_mocked_responses(function(req) {
    observed_url <<- req$url
    httr2::response_json(body = material_pdm_rows())
  })

  result <- get_material_caracteristica_valor_por_pdm(348)

  expect_equal(
    observed_url,
    paste0(
      cnbs_base_url(),
      "/materialCaracteristcaValorporPDM?codigo_pdm=348"
    )
  )
  expect_s3_class(result, "tbl_df")
})

test_that("a resposta preserva itens e a estrutura aninhada", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(
      url = req$url,
      body = material_pdm_rows()
    )
  })

  result <- get_material_caracteristica_valor_pdm(348, com_filtro = TRUE)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 2L)
  expect_identical(names(result), names(empty_busca_item()))
  expect_type(result$buscaItemCaracteristica, "list")
  expect_s3_class(result$buscaItemCaracteristica[[1]], "data.frame")
  expect_identical(
    names(result$buscaItemCaracteristica[[1]]),
    c(
      "codigoCaracteristica", "codigoValorCaracteristica",
      "nomeCaracteristica", "caracteristicaObrigatoria",
      "statusCaracteristica", "numeroCaracteristica",
      "nomeValorCaracteristica", "siglaUnidadeMedida",
      "statusValorCaracteristica", "tuplaCaracteristica"
    )
  )
  expect_identical(result$statusItem, c(TRUE, FALSE))
})

test_that("campos nulos s\u00e3o preservados como ausentes", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(
      url = req$url,
      body = material_pdm_rows()
    )
  })

  result <- get_material_caracteristica_valor_pdm(348, com_filtro = TRUE)

  expect_true(is.na(result$codigoNcm[[2]]))
  expect_true(is.na(
    result$buscaItemCaracteristica[[1]]$siglaUnidadeMedida[[1]]
  ))
})

test_that("uma resposta vazia mant\u00e9m o esquema BuscaItem", {
  httr2::local_mocked_responses(function(req) {
    httr2::response_json(url = req$url, body = list())
  })

  result <- get_material_caracteristica_valor_pdm(
    99999999,
    com_filtro = FALSE
  )

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0L)
  expect_identical(result, empty_busca_item())
})

test_that("codigo_pdm \u00e9 validado antes da requisi\u00e7\u00e3o", {
  invalid_codes <- list(NULL, NA, 0, -1, 1.5, Inf, "348", c(348, 349))

  for (value in invalid_codes) {
    expect_error(
      get_material_caracteristica_valor_pdm(value, com_filtro = TRUE),
      "`codigo_pdm` deve ser um n\u00famero inteiro positivo escalar.",
      fixed = TRUE
    )
  }
})

test_that("com_filtro é validado antes da requisição", {
  invalid_filters <- list(NULL, NA, 0, 1, "TRUE", logical(), c(TRUE, FALSE))

  for (value in invalid_filters) {
    expect_error(
      get_material_caracteristica_valor_pdm(348, com_filtro = value),
      "`com_filtro` deve ser um valor lógico escalar não ausente.",
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
    get_material_caracteristica_valor_pdm(348, com_filtro = TRUE),
    "Falha ao consultar a API do CNBS",
    fixed = TRUE
  )
})

test_that("conte\u00fado n\u00e3o JSON e estruturas incompat\u00edveis produzem erro", {
  httr2::local_mocked_responses(function(req) {
    httr2::new_response(
      method = "GET",
      url = req$url,
      status_code = 200,
      headers = list(`content-type` = "text/plain"),
      body = charToRaw("n\u00e3o \u00e9 JSON")
    )
  })
  expect_error(
    get_material_caracteristica_valor_pdm(348, com_filtro = TRUE),
    "resposta JSON inv\u00e1lida",
    fixed = TRUE
  )

  httr2::local_mocked_responses(function(req) {
    httr2::response_json(
      url = req$url,
      body = list(resultado = "inesperado")
    )
  })
  expect_error(
    get_material_caracteristica_valor_pdm(348, com_filtro = TRUE),
    "estrutura incompat\u00edvel com uma tabela",
    fixed = TRUE
  )
})
