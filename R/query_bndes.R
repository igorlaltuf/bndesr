#' Queries the loans made through The Brazilian Development Bank (BNDES) since 2002.
options(scipen = 999)

# Function query_bndes

query_bndes <- function() {
  dir.temp <- tempdir()
  year.options <- c("/naoautomaticas/naoautomaticas",
                    "/automaticas/operacoes_indiretas_automaticas_2017-01-01_ate_2022-04-30",
                    "/automaticas/operacoes_indiretas_automaticas_2015-01-01_ate_2016-12-31",
                    "/automaticas/operacoes_indiretas_automaticas_2014-01-01_ate_2014-12-31",
                    "/automaticas/operacoes_indiretas_automaticas_2013-01-01_ate_2013-12-31",
                    "/automaticas/operacoes_indiretas_automaticas_2012-01-01_ate_2012-12-31",
                    "/automaticas/operacoes_indiretas_automaticas_2011-01-01_ate_2011-12-31",
                    "/automaticas/operacoes_indiretas_automaticas_2009-01-01_ate_2010-12-31",
                    "/automaticas/operacoes_indiretas_automaticas_2002-01-01_ate_2008-12-31"
                    )


  links <- paste0("https://www.bndes.gov.br/arquivos/central-downloads/operacoes_financiamento", year.options, ".xlsx")

  # check local files
  lista.arquivos.locais <- list.files(path = dir.temp, pattern = "*.xlsx", full.names = F)
  lista.arquivos.locais <- rev(lista.arquivos.locais)

  # Download data from BNDES
  download_data <- function() {
    i <- 1
    for (idx in seq_along(links)) {

      # check local files before download
      if(stringr::str_sub(links[i], start = -19) == lista.arquivos.locais[i]){

        print('Os arquivos já foram baixados anteriormente.')

      } else {

        download.file(links[i],
                      paste(dir.temp, # fazer com que o nome do arquivo seja dinâmico
                            stringr::str_sub(links[i], start = -19),
                            sep = "/"),
                      mode = "wb") # download the file in binary mode
      }

        i <- i + 1
    }
  }

  download_data()

  # check local files
  lista.arquivos.locais <- list.files(path = dir.temp, pattern = "*.xlsx", full.names = F)
  lista.arquivos.locais <- rev(lista.arquivos.locais)

  # import the excel files
  import_data <- function() {

    table_col_names <- c("cliente", "cnpj_cpf", "descricao_projeto",
                         "uf", "municipio", "cod_muni", "num_contrato",
                         "data_contrat", "valor_contratacao_reais",
                         "valor_desembolso_reais", "fonte_desembolso",
                         "custo_financeiro", "juros",
                         "prazo_carencia_meses","prazo_amortizacao_meses",
                         "modalidade", "forma_apoio", "produto",
                         "instrumento_financeiro", "inovacao",
                         "area_operacional", "setor_cnae",
                         "subsetor_cnae_agrup", "cod_subsetor_cnae",
                         "nome_subsetor_cnae", "setor_bndes",
                         "subsetor_bndes", "porte_cliente",
                         "natureza_cliente", "instituicao_financeira",
                         "cnpj_instituicao_financeira", "tipo_garantia",
                         "tipo_excepcionalidade", "situacao_operacional")

    table <- data.frame(matrix(NA, nrow = 0, ncol = 34)) # Create empty data frame

    colnames(table) <- table_col_names

    i <- 1

    for(i in seq_along(links)) {

      if (lista.arquivos.locais[i] == "naoautomaticas.xlsx") {
        # nao-automaticas

        table_temp <- readxl::read_excel(paste0(dir.temp, '/', lista.arquivos.locais[i]),
                                         sheet = 1,
                                         skip = 4,
                                         col_types = c(rep('text',34))) %>%
          janitor::clean_names()

        colnames(table_temp) <- colnames(table)


        # Transform

        table_temp <- table_temp %>%
          # format dates
          dplyr::mutate(data_contrat = as.Date(as.numeric(data_contrat),
                                               origin = "1899-12-30",
                                               format = "%Y-%m-%d")) %>%
          dplyr::mutate(data_contrat = format(lubridate::ymd(data_contrat), "%d/%m/%Y")) %>%
          # add year column
          dplyr::mutate(ano = as.character(lubridate::year(as.Date(data_contrat, format = "%d/%m/%Y")))) %>%
          # contratação
          dplyr::mutate(valor_contratacao_reais = gsub(",", ".", valor_contratacao_reais)) %>%
          dplyr::mutate(valor_contratacao_reais = round(as.numeric(valor_contratacao_reais), 2)) %>%
          # desembolso
          dplyr::mutate(valor_desembolso_reais = gsub(",", ".", valor_desembolso_reais)) %>%
          dplyr::mutate(valor_desembolso_reais = round(as.numeric(valor_desembolso_reais), 2)) %>%
          dplyr::mutate(valor_desembolso_reais = ifelse(is.na(valor_desembolso_reais), 0, valor_desembolso_reais)) %>%
          # juros
          dplyr::mutate(juros = gsub(",", ".", juros)) %>%
          dplyr::mutate(juros = round(as.numeric(juros), 2))

      } else {

        # automaticas
        table_temp <- readxl::read_excel(paste0(dir.temp, '/', lista.arquivos.locais[i]),
                                         sheet = 1,
                                         skip = 5,
                                         col_types = c(rep('text',30))) %>%
          janitor::clean_names()

        names_auto <- table_col_names[c(1, 2, 4:6, 8:31, 34)]
        colnames(table_temp) <- names_auto
        table_temp$descricao_projeto <- NA
        table_temp$num_contrato <- NA
        table_temp$tipo_garantia <- NA
        table_temp$tipo_excepcionalidade <- NA

        table_temp <- table_temp %>%
          dplyr::select(1,2,31,3:7,32,8:34)

        # Transform

        table_temp <- table_temp %>%
          # add year column
          dplyr::mutate(ano = lubridate::year(as.Date(data_contrat, format = "%d/%m/%Y"))) %>%
          # valor contratado
          dplyr::mutate(valor_contratacao_reais = gsub("[^0-9-]", "", valor_contratacao_reais)) %>%
          dplyr::mutate(valor_contratacao_reais = gsub("[^0-9-]", "", valor_contratacao_reais)) %>%
          dplyr::mutate(valor_contratacao_reais = as.numeric(valor_contratacao_reais)) %>%
          # valor desembolsado
          dplyr::mutate(valor_desembolso_reais = gsub("[^0-9-]", "", valor_desembolso_reais)) %>%
          dplyr::mutate(valor_desembolso_reais = gsub("[^0-9-]", "", valor_desembolso_reais)) %>%
          dplyr::mutate(valor_desembolso_reais = as.numeric(valor_desembolso_reais)) %>%
          dplyr::mutate(valor_desembolso_reais = ifelse(is.na(valor_desembolso_reais), 0, valor_desembolso_reais)) %>%
          # juros
          dplyr::mutate(juros = gsub(",", ".", juros)) %>%
          dplyr::mutate(juros = round(as.numeric(juros), 2))

      }

      table <- rbind(table, table_temp)
      i <- i + 1
    }

    # clean data
    table <- table %>%
      # situacao_operacional
      dplyr::mutate(situacao_operacional = replace(situacao_operacional, situacao_operacional == "LIQUIDADA\n", "LIQUIDADO"),
             situacao_operacional = replace(situacao_operacional, situacao_operacional == "ATIVA\n", "ATIVO")) %>%
      # carencia
      dplyr::mutate(prazo_carencia_meses = as.numeric(prazo_carencia_meses)) %>%
      dplyr::mutate(prazo_amortizacao_meses = as.numeric(prazo_amortizacao_meses)) %>%

      # juros
      dplyr::mutate(juros = gsub(",", ".", juros)) %>%
      dplyr::mutate(juros = round(as.numeric(juros), 2))

    return(table)

  }

  table <- import_data()
  return(table)
}
