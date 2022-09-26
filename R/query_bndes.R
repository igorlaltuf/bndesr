#' Queries the loans made through The Brazilian Development Bank (BNDES) since 2002.

# Function query_bndes

query_bndes <- function() {
  dir.temp <- tempdir()
  year.options <- "/naoautomaticas/naoautomaticas"
  links <- paste0("https://www.bndes.gov.br/arquivos/central-downloads/operacoes_financiamento", year.options, ".xlsx")

  # Download data from BNDES
  download_data <- function() {
    download.file(links,
                  paste(dir.temp, # fazer com que o nome do arquivo seja dinâmico
                        stringr::str_sub(links, start = -19),
                        sep = "/"),
                  mode = "wb") # download the file in binary mode
  }

  download_data()

  table <- readxl::read_excel(paste0(dir.temp,'/naoautomaticas.xlsx'),
                              sheet = 1,
                              skip = 4)

}

x <- query_bndes()


