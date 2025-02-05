
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bndesr

<!-- badges: start -->

[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/bndesr)](https://cran.r-project.org/package=bndesr)
[![CRAN_Download_Badge](https://cranlogs.r-pkg.org/badges/grand-total/bndesr)](https://CRAN.R-project.org/package=bndesr)
[![CRAN_Download_Badge](https://cranlogs.r-pkg.org/badges/bndesr)](https://CRAN.R-project.org/package=bndesr)
<!-- badges: end -->

## Sobre o pacote

O pacote bndesr tem como objetivo facilitar a importação dos dados
disponibilizados pelo BNDES para o R.

A função query_contracts contém dados desde o ano de 2002 sobre os
financiamentos feitos pelo banco ( tanto na modalidade direta quanto na
modalidade indireta). Com ela é possível verificar informações sobre
quais empresas que foram apoiadas, as taxas de juros cobradas, as datas
em que as contratações ocorreram, o valor previsto em contrato, qual o
valor que de fato foi desembolsado, entre outras informações. Por esta
função conter os dados de financiamentos de acordo com a data de
contratação, não é recomendado que ela seja utilizada para calcular os
valores mensais ou anuais sobre os desembolsos do banco. Para tal,
deve-se usar a função query_desimbursements.

A função query_desimbursements contém os dados disponibilizados sobre
desembolsos do banco para cada mês desde 1995. O valor total de
desembolsos anuais do banco mostrados pela função são compatíveis com os
valores consolidados no site do BNDES.

O recomendado é que a função query_contracts seja usada para consultas
sobre empresas, sobre valores dos contratos, ou até mesmo comparar o
valor contratado com o valor que de fato foi desembolsado para
determinado contrato específico. A função query_desimbursements deve ser
usada para analisar os desembolsos do banco em uma escala maior, como
por exemplo, a evolução anual de desembolsos por setor ou subsetor da
CNAE.

As funções query_bndespar_portifolio e query_bndespar_desimbursements
são para acessar a carteira de ativos do BNDESPar e os seus desembolsos,
respectivamente.

## Instalação

Para instalar via [CRAN](https://CRAN.R-project.org/package=bndesr):

``` r
install.packages("bndesr")
library(bndesr)
```

Para instalar a versão em
desenvolvimento[(GitHub)](https://github.com/igorlaltuf/bndesr):

``` r
install.packages("devtools")
devtools::install_github("igorlaltuf/bndesr")
library(bndesr)
```

## Exemplos

Acessar dados sobre contratações do BNDES em 2017

``` r
df <- query_contracts(year = 2017) 
```

Carregar dados sobre desembolsos de 1997 até 2015:

``` r
df <- query_desimbursements(year = c(1997:2015))
```

Acessar a carteira do BNDESPar:

``` r
df <- query_bndespar_portifolio(year = 2020)
```

Ver os desembolsos do BNDESPar:

``` r
df <- query_bndespar_desimbursements(year = 2019)
```

## Citação

Para citar em trabalhos, use:

``` r
citation('bndesr')
#> Para citar o pacote 'bndesr' em publicações use:
#> 
#>   Laltuf I (2023). "BNDESR: the package to access data from the
#>   Brazilian Development Bank." <https://github.com/igorlaltuf/bndesr>.
#> 
#> Uma entrada BibTeX para usuários(as) de LaTeX é
#> 
#>   @Misc{,
#>     title = {BNDESR: the package to access data from the Brazilian Development Bank.},
#>     author = {Igor Laltuf},
#>     year = {2023},
#>     url = {https://github.com/igorlaltuf/bndesr},
#>   }
```
