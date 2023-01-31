#' Queries BNDESPar desimbursements data
#'
#' Downloads data from BNDESPar desimbursements since 2007 and return it in the form of a dataframe.
#'
#' @importFrom utils download.file unzip
#'
#' @param year selects the years which data will be downloaded. integer.
#'
#' @return a dataframe with the data
#'
#' @examples
#' df <- query_bndespar_desimbursements()
#'
#' @export
query_bndespar_desimbursements <- function(year = 'all') {

  if ("all" %in% year) {
    year <- c(2006:2022)
  }

  ano <- NULL

  link <- "https://www.bndes.gov.br/arquivos/central-downloads/operacoes_renda_variavel/desembolsos-renda-variavel.csv"

  message('Please wait for the download to complete.')

  df <- readr::read_csv2(link, locale = readr::locale(encoding = "latin1"), show_col_types = FALSE,
                         skip = 4) |>
    janitor::clean_names() |>
    dplyr::filter(ano %in% year)

  message("Completed data query.")

  return(df)

}
