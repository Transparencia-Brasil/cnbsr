elastic_schema_record <- function() {
  list(
    codigoPDM = 4416,
    codigoPdm = 4416,
    codigoClasse = 7520,
    codigoGrupo = 75,
    descricaoPDM = "Caneta permanente",
    nomePdm = "Caneta permanente",
    descricaoClasse = "Acess\u00f3rios para escrit\u00f3rio",
    nomeClasse = "Acess\u00f3rios para escrit\u00f3rio",
    descricaoGrupo = "Material de expediente",
    statusPDM = TRUE,
    statusClasse = TRUE,
    statusGrupo = TRUE
  )
}

nested_characteristic_record <- function() {
  list(
    codigoCaracteristica = "BR000001",
    codigoValorCaracteristica = "BR000010",
    nomeCaracteristica = "Forma farmac\u00eautica",
    caracteristicaObrigatoria = TRUE,
    statusCaracteristica = TRUE,
    numeroCaracteristica = 1,
    nomeValorCaracteristica = "Comprimido",
    siglaUnidadeMedida = NULL,
    statusValorCaracteristica = TRUE,
    tuplaCaracteristica = list("BR000001", "BR000010")
  )
}

busca_item_schema_record <- function() {
  list(
    codigoPdm = 348,
    codigoItem = 111,
    nomePdm = "Cimetidina",
    statusItem = TRUE,
    itemSuspenso = FALSE,
    itemSustentavel = FALSE,
    itemExclusivoUasgCentral = FALSE,
    codigoClasse = 6505,
    codigoNcm = NULL,
    nomeNcm = NULL,
    aplicaMargemPreferencia = FALSE,
    buscaItemCaracteristica = list(nested_characteristic_record())
  )
}

test_that("campos s\u00e3o reordenados e inteiros JSON s\u00e3o tipados", {
  row <- rev(elastic_schema_record())

  result <- cnbs_records_tibble(
    list(row),
    prototype = empty_elastic_pdm()
  )

  expect_identical(names(result), names(empty_elastic_pdm()))
  expect_type(result$codigoPDM, "integer")
  expect_identical(result$codigoPDM, 4416L)
})

test_that("campos ausentes e extras s\u00e3o identificados", {
  missing <- elastic_schema_record()
  missing$nomePdm <- NULL
  extra <- elastic_schema_record()
  extra$campoNovo <- "inesperado"

  expect_error(
    cnbs_records_tibble(list(missing), empty_elastic_pdm()),
    "campos ausentes: nomePdm",
    fixed = TRUE
  )
  expect_error(
    cnbs_records_tibble(list(extra), empty_elastic_pdm()),
    "campos extras: campoNovo",
    fixed = TRUE
  )
})

test_that("convers\u00f5es num\u00e9ricas com perda s\u00e3o rejeitadas", {
  fractional <- elastic_schema_record()
  fractional$codigoPDM <- 4416.5
  oversized <- elastic_schema_record()
  oversized$codigoPDM <- .Machine$integer.max + 1

  expect_error(
    cnbs_records_tibble(list(fractional), empty_elastic_pdm()),
    "n\u00e3o pode ser convertido para integer",
    fixed = TRUE
  )
  expect_error(
    cnbs_records_tibble(list(oversized), empty_elastic_pdm()),
    "n\u00e3o pode ser convertido para integer",
    fixed = TRUE
  )
})

test_that("valores nulos tornam-se aus\u00eancias tipadas", {
  row <- elastic_schema_record()
  row["codigoPDM"] <- list(NULL)
  row["descricaoPDM"] <- list(NULL)
  row["statusPDM"] <- list(NULL)

  result <- cnbs_records_tibble(
    list(row),
    prototype = empty_elastic_pdm()
  )

  expect_type(result$codigoPDM, "integer")
  expect_type(result$descricaoPDM, "character")
  expect_type(result$statusPDM, "logical")
  expect_true(is.na(result$codigoPDM))
  expect_true(is.na(result$descricaoPDM))
  expect_true(is.na(result$statusPDM))
})

test_that("objetos usam o mesmo contrato estrito", {
  body <- rev(list(
    codigoPdm = 17708,
    nomePdm = "Dipirona S\u00f3dica",
    statusPdm = TRUE,
    codigoConjunto = 123,
    nomeAcentuadoConjunto = "Medicamentos",
    codigoClasse = 6505,
    nomeClasse = "Drogas e medicamentos",
    codigoGrupo = 65,
    nomeGrupo = "Equipamentos e artigos m\u00e9dicos"
  ))
  response <- httr2::response_json(body = body)

  result <- cnbs_response_object_tibble(response, empty_pdm_parcial())

  expect_identical(names(result), names(empty_pdm_parcial()))
  expect_type(result$codigoPdm, "integer")
  expect_identical(result$codigoPdm, 17708L)
})

test_that("tabelas aninhadas t\u00eam esquema e tupla est\u00e1veis", {
  result <- cnbs_records_tibble(
    list(busca_item_schema_record()),
    prototype = empty_busca_item(),
    transformers = list(
      buscaItemCaracteristica = cast_busca_item_caracteristica
    )
  )
  nested <- result$buscaItemCaracteristica[[1]]

  expect_s3_class(nested, "tbl_df")
  expect_identical(names(nested), names(empty_item_caracteristica()))
  expect_type(nested$numeroCaracteristica, "integer")
  expect_true(is.na(nested$siglaUnidadeMedida))
  expect_identical(
    nested$tuplaCaracteristica[[1]],
    c("BR000001", "BR000010")
  )
})

test_that("diverg\u00eancias aninhadas e tuplas inv\u00e1lidas produzem erro", {
  missing_nested <- busca_item_schema_record()
  missing_nested$buscaItemCaracteristica[[1]]$nomeCaracteristica <- NULL
  invalid_tuple <- busca_item_schema_record()
  invalid_tuple$buscaItemCaracteristica[[1]]$tuplaCaracteristica <- list(1)

  expect_error(
    cnbs_records_tibble(
      list(missing_nested),
      prototype = empty_busca_item(),
      transformers = list(
        buscaItemCaracteristica = cast_busca_item_caracteristica
      )
    ),
    "campos ausentes: nomeCaracteristica",
    fixed = TRUE
  )
  expect_error(
    cnbs_records_tibble(
      list(invalid_tuple),
      prototype = empty_busca_item(),
      transformers = list(
        buscaItemCaracteristica = cast_busca_item_caracteristica
      )
    ),
    "n\u00e3o \u00e9 uma lista de textos",
    fixed = TRUE
  )
})
