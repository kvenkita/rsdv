test_that("quality_report() returns an rsdv_quality_report object", {
  syn <- gaussian_copula_synthesizer(small_meta()) |> fit(small_data())
  synth <- sample(syn, n = 50)
  qr  <- quality_report(real = small_data(), synthetic = synth, metadata = small_meta())
  expect_s3_class(qr, "rsdv_quality_report")
})

test_that("quality_report() contains expected score components", {
  syn <- gaussian_copula_synthesizer(small_meta()) |> fit(small_data())
  synth <- sample(syn, n = 50)
  qr  <- quality_report(real = small_data(), synthetic = synth, metadata = small_meta())
  expect_true(all(c("ks_scores", "tvd_scores", "correlation_score",
                    "overall_score") %in% names(qr)))
})

test_that("quality_report() overall_score is in [0, 1]", {
  syn <- gaussian_copula_synthesizer(small_meta()) |> fit(small_data())
  synth <- sample(syn, n = 50)
  qr  <- quality_report(small_data(), synth, small_meta())
  expect_true(qr$overall_score >= 0 && qr$overall_score <= 1)
})

test_that("print.rsdv_quality_report() prints without error", {
  syn <- gaussian_copula_synthesizer(small_meta()) |> fit(small_data())
  synth <- sample(syn, n = 50)
  qr  <- quality_report(small_data(), synth, small_meta())
  expect_output(print(qr), "Quality Report")
  expect_output(print(qr), "Overall")
})
