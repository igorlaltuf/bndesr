#' Queries BNDESPar portfolio data
#'
#' Downloads data from the portfolio since 2006 and return it in the form of a dataframe.
#'
#' @importFrom utils download.file unzip
#'
#' @param year selects the years which data will be downloaded. integer.
#'
#' @return a dataframe with the data
#'
#' @examples
#' df <- query_bndespar_portifolio()
#'
#' @export
query_bndespar_portifolio <- function(year = 'all') {

  if ("all" %in% year) {
    year <- c(2006:2022)
  }

  ano <- total_percent <- on_percent <- pn_percent <- NULL

  link <- "https://www.bndes.gov.br/arquivos/central-downloads/operacoes_renda_variavel/carteira-renda-variavel.csv"

  if (RCurl::url.exists(link == F)) { # network is down = message (not an error anymore)
    message("No internet connection or data source broken.")
    return(NULL)
  } else { # network is up = proceed to download
    message("Please wait for the download to complete.")

    suppressWarnings({

    df <- readr::read_csv2(link, show_col_types = FALSE, skip = 4) |>
      janitor::clean_names() |>
      dplyr::mutate(total_percent = round(readr::parse_number(total_percent, locale = readr::locale(decimal_mark = ",")), 1),
                    on_percent = round(readr::parse_number(on_percent, locale = readr::locale(decimal_mark = ",")), 1),
                    pn_percent = round(readr::parse_number(pn_percent, locale = readr::locale(decimal_mark = ",")), 1)) |>
      dplyr::filter(ano %in% year)

    })

    message("Completed data query.")

    return(df)
  }
}
