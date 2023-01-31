# run the full test only in my personal machine

if (Sys.getenv('USERNAME') == 'igorl') {

  df <- query_contracts(year = c(2002:2021))


  test_that("Check values from previous years", {
    expect_equal(nrow(df), 2124083)
    expect_equal(ncol(df), 35)
    expect_equal(sum(df$valor_contratacao_reais), 1533912219725)
    expect_equal(sum(df$valor_desembolso_reais), 1389763947385)
  })

}

df_2022 <- query_contracts(year = 2022)

test_that("Check values from currenty year", {
  expect_equal(ncol(df_2022), 35)
  expect_gt(nrow(df_2022), 42332)
})
