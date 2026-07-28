cnbs_base_url <- function() {
  "https://cnbs.estaleiro.serpro.gov.br/cnbs-api/material/v1"
}

cnbs_request <- function(path) {
  httr2::request(cnbs_base_url()) |>
    httr2::req_url_path_append(path) |>
    httr2::req_timeout(30)
}

cnbs_perform <- function(req) {
  tryCatch(
    httr2::req_perform(req),
    error = function(cnd) {
      stop(
        sprintf(
          "Falha ao consultar a API do CNBS: %s",
          conditionMessage(cnd)
        ),
        call. = FALSE
      )
    }
  )
}

cnbs_response_tibble <- function(resp, empty = empty_codigo_pdm_classe()) {
  body_text <- tryCatch(
    httr2::resp_body_string(resp),
    error = function(cnd) {
      stop(
        sprintf(
          "N\u00e3o foi poss\u00edvel ler a resposta da API do CNBS: %s",
          conditionMessage(cnd)
        ),
        call. = FALSE
      )
    }
  )

  body <- tryCatch(
    httr2::resp_body_json(resp, simplifyVector = TRUE),
    error = function(cnd) {
      stop(
        sprintf(
          "A API do CNBS retornou uma resposta JSON inv\u00e1lida: %s",
          conditionMessage(cnd)
        ),
        call. = FALSE
      )
    }
  )

  if (identical(trimws(body_text), "[]")) {
    message("A consulta \u00e0 API do CNBS retornou zero resultados.")
    return(empty)
  }

  if (!is.data.frame(body)) {
    stop(
      "A API do CNBS retornou uma estrutura incompat\u00edvel com uma tabela.",
      call. = FALSE
    )
  }

  tibble::as_tibble(body, .name_repair = "minimal")
}
