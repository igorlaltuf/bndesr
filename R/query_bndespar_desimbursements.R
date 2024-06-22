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
    year <- c(2006:(as.numeric(format(Sys.Date(), "%Y"))))
  }

  ano <- NULL

  link <- "https://www.bndes.gov.br/arquivos/central-downloads/operacoes_renda_variavel/desembolsos-renda-variavel.csv"

  # Download data
    if (RCurl::url.exists(link == F)) { # network is down = message (not an error anymore)
      message("No internet connection or data source broken.")
      return(NULL)
    } else { # network is up = proceed to download
      message("Please wait for the download to complete.")

      suppressWarnings({

      tryCatch({
        df <- readr::read_csv2(link, locale = readr::locale(encoding = "latin1"),
                               show_col_types = FALSE,
                               skip = 4) |>
          janitor::clean_names() |>
          dplyr::filter(ano %in% year)

        colnames(df) <- c("ano", "razao_social", "sigla", "cnpj", "aberta_fechada",
                          "tipo_de_ativo", "valor_desembolsado", "objetivo_predominante",
                          "descricao_resumida_da_operacao", "setor")


        df$valor_desembolsado <- as.numeric(gsub("\\.", "", gsub(",", ".", df$valor_desembolsado))) / 100

        },
      # em caso de erro, interrompe a função e mostra msg de erro

      error = function(e) {
        message("Error downloading file. Try again later.", e$message)
        stop("Error downloading file.")  }
      )
      })

      message("Completed data query.")

      return(df)
    }
}

