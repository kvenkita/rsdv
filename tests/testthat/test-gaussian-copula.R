test_that("gaussian_copula_synthesizer() creates unfitted synthesizer", {
  syn <- gaussian_copula_synthesizer(small_meta())
  expect_s3_class(syn, "gaussian_copula_synthesizer")
  expect_s3_class(syn, "rsdv_synthesizer")
  expect_false(is_fitted(syn))
})

test_that("fit() returns a fitted synthesizer", {
  syn <- gaussian_copula_synthesizer(small_meta())
  fitted_syn <- fit(syn, small_data())
  expect_true(is_fitted(fitted_syn))
  expect_false(is.null(fitted_syn$transformers))
})

test_that("fit() errors when data is missing required columns", {
  syn <- gaussian_copula_synthesizer(small_meta())
  bad <- small_data()[, c("age", "income")]
  expect_error(fit(syn, bad), "Missing columns")
})

test_that("fit() stores a correlation matrix for 2+ numerical columns", {
  syn <- gaussian_copula_synthesizer(small_meta())
  syn <- fit(syn, small_data())
  # small_meta has 2 numerical cols: age + income
  expect_equal(dim(syn$cor_matrix), c(2L, 2L))
  expect_equal(rownames(syn$cor_matrix), c("age", "income"))
})

test_that("fit() works with only one numerical column", {
  meta <- metadata() |> set_column_type("x", "numerical")
  df   <- data.frame(x = 1:10)
  syn  <- gaussian_copula_synthesizer(meta) |> fit(df)
  expect_true(is_fitted(syn))
  expect_null(syn$copula)  # no copula needed for 1 column
})
