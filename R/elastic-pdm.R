empty_elastic_pdm <- function() {
  tibble::tibble(
    codigoPDM = integer(),
    codigoPdm = integer(),
    codigoClasse = integer(),
    codigoGrupo = integer(),
    descricaoPDM = character(),
    nomePdm = character(),
    descricaoClasse = character(),
    nomeClasse = character(),
    descricaoGrupo = character(),
    statusPDM = logical(),
    statusClasse = logical(),
    statusGrupo = logical()
  )
}
