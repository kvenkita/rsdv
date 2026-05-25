# All functions in this file are internal (@noRd). They are not exported.
# They are used by gaussian_copula.R for pre-processing and post-processing data.

# NumericalTransformer --------------------------------------------------------
# Maps to (epsilon, 1-epsilon) using min/max scaling.
# The epsilon clamp prevents qnorm(0) = -Inf and qnorm(1) = +Inf downstream.

#' @noRd
fit_numerical_transformer <- function(x) {
  x_clean <- x[is.finite(x)]
  list(type = "numerical", min = min(x_clean), max = max(x_clean))
}

#' @noRd
apply_numerical_transformer <- function(x, tr) {
  eps <- 1e-6
  rng <- tr$max - tr$min
  if (rng == 0) return(rep(0.5, length(x)))
  u <- (x - tr$min) / rng
  pmin(pmax(u, eps), 1 - eps)
}

#' @noRd
invert_numerical_transformer <- function(u, tr) {
  eps <- 1e-6
  # Snap epsilon-clamped boundary values back to exact min/max, then
  # perform the linear inverse to recover the original scale.
  u_raw <- ifelse(abs(u - eps) < 2 * eps, 0, ifelse(abs(u - (1 - eps)) < 2 * eps, 1, u))
  u_raw * (tr$max - tr$min) + tr$min
}

# CategoricalTransformer ------------------------------------------------------
# Stores observed levels and their empirical probabilities.

#' @noRd
fit_categorical_transformer <- function(x) {
  x_char     <- as.character(x)
  levels_vec <- sort(unique(x_char))
  freq       <- tabulate(match(x_char, levels_vec))
  prob       <- freq / sum(freq)
  list(type = "categorical", levels = levels_vec, prob = prob)
}

#' @noRd
apply_categorical_transformer <- function(x, tr) {
  as.integer(match(as.character(x), tr$levels))
}

#' @noRd
invert_categorical_transformer <- function(codes, tr) {
  tr$levels[codes]
}

#' Sample n values from a categorical transformer's empirical distribution
#' @noRd
sample_categorical <- function(n, tr) {
  tr$levels[sample.int(length(tr$levels), n, replace = TRUE, prob = tr$prob)]
}

# BooleanTransformer ----------------------------------------------------------

#' @noRd
fit_boolean_transformer <- function(x) {
  list(type = "boolean", prob_true = mean(as.logical(x), na.rm = TRUE))
}

#' @noRd
apply_boolean_transformer <- function(x, tr) as.integer(as.logical(x))

#' @noRd
invert_boolean_transformer <- function(codes, tr) as.logical(codes)

# Dispatch helpers ------------------------------------------------------------

#' Fit one transformer per column according to metadata column types
#' @noRd
fit_transformers <- function(data, meta) {
  cols <- names(meta$columns)
  trs  <- lapply(cols, function(col) {
    type <- meta$columns[[col]]$type
    x    <- data[[col]]
    switch(type,
      numerical   = fit_numerical_transformer(x),
      categorical = fit_categorical_transformer(x),
      boolean     = fit_boolean_transformer(x),
      NULL
    )
  })
  setNames(trs, cols)
}

#' Transform columns to intermediate representation
#' Numerical -> (0,1), categorical -> integer codes, boolean -> 0/1
#' @noRd
apply_transformers <- function(data, transformers, meta) {
  result <- data
  for (col in names(meta$columns)) {
    tr   <- transformers[[col]]
    if (is.null(tr)) next
    type <- meta$columns[[col]]$type
    result[[col]] <- switch(type,
      numerical   = apply_numerical_transformer(data[[col]], tr),
      categorical = apply_categorical_transformer(data[[col]], tr),
      boolean     = apply_boolean_transformer(data[[col]], tr),
      data[[col]]
    )
  }
  result
}

#' Inverse-transform columns back to original scale / levels
#' @noRd
invert_transformers <- function(data, transformers, meta) {
  result <- data
  for (col in names(meta$columns)) {
    tr   <- transformers[[col]]
    if (is.null(tr)) next
    type <- meta$columns[[col]]$type
    result[[col]] <- switch(type,
      numerical   = invert_numerical_transformer(data[[col]], tr),
      categorical = invert_categorical_transformer(data[[col]], tr),
      boolean     = invert_boolean_transformer(data[[col]], tr),
      data[[col]]
    )
  }
  result
}
