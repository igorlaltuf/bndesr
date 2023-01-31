
df <- query_bndespar_portifolio()

test_that("Check row number", {
  expect_gt(nrow(df), 3125)
})
