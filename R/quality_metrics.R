#' Kolmogorov-Smirnov similarity score per numerical column
#'
#' @param real A data frame of real data.
#' @param synthetic A data frame of synthetic data.
#' @param meta An `rsdv_metadata` object.
#' @return A tibble with columns `column` (chr) and `score` (dbl, 0–1, higher = better).
#' @export
#' @examples
#' \dontrun{
#' syn   <- gaussian_copula_synthesizer(metadata(adult_income)) |> fit(adult_income)
#' synth <- sample(syn, n = 500)
#' ks_similarity(adult_income, synth, metadata(adult_income))
#' }
ks_similarity <- function(real, synthetic, meta) {
  num_cols <- get_columns_by_type(meta, "numerical")
  rows <- lapply(num_cols, function(col) {
    ks <- stats::ks.test(real[[col]], synthetic[[col]])
    list(column = col, score = 1 - ks$statistic[[1L]])
  })
  tibble::tibble(
    column = vapply(rows, `[[`, character(1L), "column"),
    score  = vapply(rows, `[[`, double(1L),    "score")
  )
}

#' Total variation distance similarity score per categorical column
#'
#' @param real A data frame of real data.
#' @param synthetic A data frame of synthetic data.
#' @param meta An `rsdv_metadata` object.
#' @return A tibble with columns `column` (chr) and `score` (dbl, 0–1, higher = better).
#' @export
#' @examples
#' \dontrun{
#' syn   <- gaussian_copula_synthesizer(metadata(adult_income)) |> fit(adult_income)
#' synth <- sample(syn, n = 500)
#' tvd_similarity(adult_income, synth, metadata(adult_income))
#' }
tvd_similarity <- function(real, synthetic, meta) {
  cat_cols <- get_columns_by_type(meta, "categorical")
  rows <- lapply(cat_cols, function(col) {
    all_levels <- union(unique(real[[col]]), unique(synthetic[[col]]))
    p_real <- table(factor(real[[col]],      levels = all_levels)) / nrow(real)
    p_syn  <- table(factor(synthetic[[col]], levels = all_levels)) / nrow(synthetic)
    tvd    <- 0.5 * sum(abs(as.numeric(p_real) - as.numeric(p_syn)))
    list(column = col, score = 1 - tvd)
  })
  tibble::tibble(
    column = vapply(rows, `[[`, character(1L), "column"),
    score  = vapply(rows, `[[`, double(1L),    "score")
  )
}

#' Correlation matrix similarity between real and synthetic numerical data
#'
#' Computes 1 minus the normalized Frobenius norm of the difference between
#' the Pearson correlation matrices of real and synthetic data.
#'
#' @param real A data frame of real data.
#' @param synthetic A data frame of synthetic data.
#' @param meta An `rsdv_metadata` object.
#' @return A scalar score in [0, 1]; higher = better.
#' @export
#' @examples
#' \dontrun{
#' correlation_similarity(adult_income, synth_data, metadata(adult_income))
#' }
correlation_similarity <- function(real, synthetic, meta) {
  num_cols <- get_columns_by_type(meta, "numerical")
  if (length(num_cols) < 2L) return(1)
  cor_real <- stats::cor(real[, num_cols, drop = FALSE],
                         use = "pairwise.complete.obs")
  cor_syn  <- stats::cor(synthetic[, num_cols, drop = FALSE],
                         use = "pairwise.complete.obs")
  p        <- length(num_cols)
  max_diff <- sqrt(p * (p - 1L) * 4)  # off-diagonals bounded by [-2, 2]
  diff_frob <- norm(cor_real - cor_syn, type = "F")
  max(0, 1 - diff_frob / max_diff)
}

#' ML efficacy: train-on-synthetic / test-on-real accuracy ratio (TSTR)
#'
#' Trains an `rpart` decision tree on synthetic data and on a real training
#' split, evaluates both on a real held-out test set, and returns the ratio
#' TSTR / TRTR. A score near 1 means synthetic data is as informative as
#' real data for this prediction task.
#'
#' @param real A data frame of real data.
#' @param synthetic A data frame of synthetic data.
#' @param meta An `rsdv_metadata` object.
#' @param target_col Name of a categorical column to use as the outcome.
#' @param test_fraction Fraction of `real` to hold out as the test set.
#' @return A list with elements `tstr` (accuracy), `trtr` (accuracy), and
#'   `score` (ratio, capped at 1).
#' @export
#' @examples
#' \dontrun{
#' ml_efficacy(adult_income, synth_data, meta, target_col = "income")
#' }
ml_efficacy <- function(real, synthetic, meta, target_col,
                        test_fraction = 0.2) {
  n        <- nrow(real)
  test_idx <- sample.int(n, size = floor(n * test_fraction))
  train_real <- real[-test_idx, , drop = FALSE]
  test_real  <- real[ test_idx, , drop = FALSE]

  formula <- stats::as.formula(paste(target_col, "~ ."))

  fit_syn  <- rpart::rpart(formula, data = synthetic,  method = "class")
  fit_real <- rpart::rpart(formula, data = train_real, method = "class")

  pred_syn  <- predict(fit_syn,  newdata = test_real, type = "class")
  pred_real <- predict(fit_real, newdata = test_real, type = "class")

  acc <- function(pred) mean(pred == test_real[[target_col]])
  tstr  <- acc(pred_syn)
  trtr  <- acc(pred_real)
  score <- if (trtr > 0) min(tstr / trtr, 1) else 0

  list(tstr = tstr, trtr = trtr, score = score)
}
