#' Nearest-Neighbor Distance Ratio privacy score
#'
#' For each synthetic row, computes the ratio of its distance to the nearest
#' real row vs. its distance to the second-nearest real row. A high ratio
#' (close to 1) means the synthetic row is not unusually close to any
#' specific real row — low disclosure risk. Score = mean(ratio > 0.5).
#'
#' @param real,synthetic Data frames with only numerical columns.
#' @param k Number of nearest neighbors to use (default 5).
#' @return A scalar score in [0, 1]; higher = more private.
#' @export
#' @examples
#' real <- data.frame(x = rnorm(50), y = rnorm(50))
#' syn  <- data.frame(x = rnorm(50), y = rnorm(50))
#' nndr(real, syn)
nndr <- function(real, synthetic, k = 5L) {
  real_mat <- as.matrix(real[, vapply(real, is.numeric, logical(1)), drop = FALSE])
  syn_mat  <- as.matrix(synthetic[, vapply(synthetic, is.numeric, logical(1)), drop = FALSE])

  if (ncol(real_mat) == 0 || ncol(syn_mat) == 0) return(1)

  # Find 2 nearest real neighbors for each synthetic point
  nn_result <- FNN::knnx.dist(data = real_mat, query = syn_mat, k = 2L)
  d1 <- nn_result[, 1L]  # distance to nearest real row
  d2 <- nn_result[, 2L]  # distance to second-nearest

  # Avoid division by zero: treat ratio as 0 when both distances are 0
  ratio <- ifelse(d2 == 0, 0, d1 / d2)
  mean(ratio > 0.5)
}

#' Attribute disclosure risk
#'
#' Estimates the fraction of synthetic rows where a sensitive column value
#' can be correctly inferred from known columns via a k-NN lookup in the
#' real training data.
#'
#' @param real,synthetic Data frames.
#' @param sensitive_col Name of the column to protect.
#' @param known_cols Character vector of columns assumed known to an adversary.
#' @param k Number of nearest neighbors used in inference.
#' @return A scalar in [0, 1]; lower = more private.
#' @export
#' @examples
#' real <- data.frame(age = sample(20:60, 50, replace = TRUE),
#'                    income = sample(c("low", "high"), 50, replace = TRUE),
#'                    stringsAsFactors = FALSE)
#' syn  <- real[sample(50), ]
#' attribute_disclosure_risk(real, syn, sensitive_col = "income", known_cols = "age")
attribute_disclosure_risk <- function(real, synthetic,
                                      sensitive_col, known_cols, k = 1L) {
  train_x <- as.matrix(real[, known_cols, drop = FALSE])
  train_y <- real[[sensitive_col]]
  test_x  <- as.matrix(synthetic[, known_cols, drop = FALSE])
  true_y  <- synthetic[[sensitive_col]]

  nn_idx  <- FNN::knnx.index(data = train_x, query = test_x, k = k)
  pred_y  <- train_y[nn_idx[, 1L]]
  mean(pred_y == true_y)
}
