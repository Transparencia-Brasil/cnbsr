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

cnbs_schema_error <- function(context, detail) {
  stop(
    sprintf(
      paste0(
        "A API do CNBS retornou uma estrutura incompat\u00edvel ",
        "com %s: %s."
      ),
      context,
      detail
    ),
    call. = FALSE
  )
}

cnbs_validate_fields <- function(value, prototype, context) {
  actual <- names(value)
  expected <- names(prototype)

  if (is.null(actual) || anyDuplicated(actual)) {
    cnbs_schema_error(
      context,
      "os campos n\u00e3o possuem nomes \u00fanicos"
    )
  }

  missing <- setdiff(expected, actual)
  extra <- setdiff(actual, expected)
  if (length(missing) || length(extra)) {
    details <- character()
    if (length(missing)) {
      details <- c(
        details,
        sprintf("campos ausentes: %s", paste(missing, collapse = ", "))
      )
    }
    if (length(extra)) {
      details <- c(
        details,
        sprintf("campos extras: %s", paste(extra, collapse = ", "))
      )
    }
    cnbs_schema_error(context, paste(details, collapse = "; "))
  }
}

cnbs_cast_scalar <- function(value, prototype, field, context) {
  if (is.null(value)) {
    return(prototype[NA_integer_])
  }
  if (length(value) != 1L || is.list(value)) {
    cnbs_schema_error(
      context,
      sprintf("o campo '%s' n\u00e3o \u00e9 escalar", field)
    )
  }

  target <- typeof(prototype)
  valid <- switch(
    target,
    integer = is.numeric(value) &&
      (is.na(value) || (
        is.finite(value) &&
          value == floor(value) &&
          value >= -.Machine$integer.max - 1 &&
          value <= .Machine$integer.max
      )),
    double = is.numeric(value),
    logical = is.logical(value),
    character = is.character(value),
    FALSE
  )
  if (!valid) {
    cnbs_schema_error(
      context,
      sprintf(
        "o campo '%s' n\u00e3o pode ser convertido para %s",
        field,
        target
      )
    )
  }

  switch(
    target,
    integer = as.integer(value),
    double = as.double(value),
    logical = as.logical(value),
    character = as.character(value)
  )
}

cnbs_cast_record <- function(
  value,
  prototype,
  context,
  transformers = list()
) {
  if (!is.list(value) || is.data.frame(value)) {
    cnbs_schema_error(context, "um registro n\u00e3o \u00e9 um objeto JSON")
  }
  cnbs_validate_fields(value, prototype, context)

  result <- lapply(names(prototype), function(field) {
    if (field %in% names(transformers)) {
      return(transformers[[field]](value[[field]]))
    }
    cnbs_cast_scalar(value[[field]], prototype[[field]], field, context)
  })
  names(result) <- names(prototype)
  result
}

cnbs_records_tibble <- function(
  records,
  prototype,
  context = "uma tabela",
  transformers = list()
) {
  if (!is.list(records) || !is.null(names(records))) {
    cnbs_schema_error(context, "a resposta n\u00e3o \u00e9 um array JSON")
  }
  if (!length(records)) {
    return(prototype)
  }

  cast <- lapply(
    records,
    cnbs_cast_record,
    prototype = prototype,
    context = context,
    transformers = transformers
  )
  columns <- lapply(names(prototype), function(field) {
    values <- lapply(cast, function(record) record[[field]])
    if (is.list(prototype[[field]])) {
      return(values)
    }
    vapply(values, identity, prototype[[field]][NA_integer_])
  })
  names(columns) <- names(prototype)
  tibble::as_tibble(columns, .name_repair = "minimal")
}

cnbs_response_tibble <- function(resp, empty, transformers = list()) {
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
    httr2::resp_body_json(resp, simplifyVector = FALSE),
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

  cnbs_records_tibble(
    body,
    prototype = empty,
    transformers = transformers
  )
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
    httr2::resp_body_json(resp, simplifyVector = FALSE),
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

  if (!is.list(body) || is.null(names(body))) {
    cnbs_schema_error("um objeto", "a resposta n\u00e3o \u00e9 um objeto JSON")
  }
  if (all(vapply(body, is.null, logical(1)))) {
    cnbs_validate_fields(body, empty, "um objeto")
    message("A consulta \u00e0 API do CNBS retornou zero resultados.")
    return(empty)
  }

  values <- cnbs_cast_record(
    body,
    prototype = empty,
    context = "um objeto"
  )
  columns <- lapply(names(empty), function(field) values[[field]])
  names(columns) <- names(empty)
  tibble::as_tibble(columns, .name_repair = "minimal")
}

cnbs_response_logical <- function(resp) {
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
    cnbs_schema_error(
      "um valor l\u00f3gico",
      "a resposta est\u00e1 vazia"
    )
  }

  body <- tryCatch(
    httr2::resp_body_json(resp, simplifyVector = FALSE),
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

  if (!is.logical(body) || length(body) != 1L || is.na(body)) {
    cnbs_schema_error(
      "um valor l\u00f3gico",
      paste0(
        "a resposta n\u00e3o \u00e9 um booleano JSON escalar ",
        "n\u00e3o ausente"
      )
    )
  }

  body
}
