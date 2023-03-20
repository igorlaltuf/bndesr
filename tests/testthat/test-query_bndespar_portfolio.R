
df <- query_bndespar_portifolio()

test_that("Check row number", {
  expect_equal(ncol(df), 13)
  expect_gt(nrow(df), 3122)
})
