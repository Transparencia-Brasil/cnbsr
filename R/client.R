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

cnbs_response_tibble <- function(resp, empty) {
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

cnbs_response_object_tibble <- function(resp, empty) {
  if (httr2::resp_status(resp) == 204L) {
    message("A consulta \u00e0 API do CNBS retornou zero resultados.")
    return(empty)
  }

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

  if (!nzchar(trimws(body_text))) {
    message("A consulta \u00e0 API do CNBS retornou zero resultados.")
    return(empty)
  }

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

  valid_object <- is.list(body) &&
    !is.data.frame(body) &&
    !is.null(names(body)) &&
    setequal(names(body), names(empty))

  if (!valid_object) {
    stop(
      paste0(
        "A API do CNBS retornou uma estrutura incompat\u00edvel ",
        "com um objeto."
      ),
      call. = FALSE
    )
  }

  if (all(vapply(body, is.null, logical(1)))) {
    message("A consulta \u00e0 API do CNBS retornou zero resultados.")
    return(empty)
  }

  values <- lapply(names(empty), function(name) {
    value <- body[[name]]
    prototype <- empty[[name]]

    if (is.null(value)) {
      return(prototype[NA_integer_])
    }
    if (length(value) != 1L || is.list(value)) {
      stop(
        paste0(
          "A API do CNBS retornou uma estrutura incompat\u00edvel ",
          "com um objeto."
        ),
        call. = FALSE
      )
    }

    switch(
      typeof(prototype),
      integer = as.integer(value),
      double = as.double(value),
      logical = as.logical(value),
      character = as.character(value),
      value
    )
  })
  names(values) <- names(empty)

  tibble::as_tibble(values, .name_repair = "minimal")
}
