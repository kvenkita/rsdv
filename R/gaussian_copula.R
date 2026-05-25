#' Create a Gaussian Copula synthesizer
#'
#' Fits a Gaussian copula to the numerical columns and samples categorical
#' columns independently from empirical marginals.
#'
#' @param metadata An `rsdv_metadata` object.
#' @param enforce_min_max Logical. Clamp sampled numerical values to the
#'   observed range. Default `TRUE`.
#' @return An unfitted `gaussian_copula_synthesizer` object.
#' @export
#' @examples
#' \dontrun{
#' meta <- metadata(adult_income) |>
#'   set_column_type("age", "numerical") |>
#'   set_column_type("occupation", "categorical")
#' syn <- gaussian_copula_synthesizer(meta)
#' syn <- fit(syn, adult_income)
#' }
gaussian_copula_synthesizer <- function(metadata, enforce_min_max = TRUE) {
  structure(
    list(
      metadata        = metadata,
      enforce_min_max = enforce_min_max,
      fitted          = FALSE,
      copula          = NULL,
      cor_matrix      = NULL,
      transformers    = NULL,
      num_cols        = NULL,
      cat_cols        = NULL,
      bool_cols       = NULL
    ),
    class = c("gaussian_copula_synthesizer", "rsdv_synthesizer")
  )
}

#' @importFrom generics fit
#' @export
fit.gaussian_copula_synthesizer <- function(object, data, ...) {
  validate_data(data, object$metadata)

  meta      <- object$metadata
  num_cols  <- get_columns_by_type(meta, "numerical")
  cat_cols  <- get_columns_by_type(meta, "categorical")
  bool_cols <- get_columns_by_type(meta, "boolean")

  object$num_cols  <- num_cols
  object$cat_cols  <- cat_cols
  object$bool_cols <- bool_cols

  object$transformers <- fit_transformers(data, meta)

  if (length(num_cols) >= 2L) {
    # Build uniform pseudo-observations from each numerical column
    u_mat <- do.call(cbind, lapply(num_cols, function(col) {
      apply_numerical_transformer(data[[col]], object$transformers[[col]])
    }))
    colnames(u_mat) <- num_cols

    # Rank-based pseudo-observations for more robust copula estimation
    u_pobs <- copula::pobs(u_mat)

    nc  <- copula::normalCopula(dim = ncol(u_pobs), dispstr = "un")
    # "itau" (inversion of Kendall's tau) is robust for small samples and
    # avoids non-finite gradients that plague ML with few rows or tied values.
    fit_result <- copula::fitCopula(nc, data = u_pobs, method = "itau")

    object$copula     <- fit_result@copula
    object$cor_matrix <- copula::getSigma(fit_result@copula)
    colnames(object$cor_matrix) <- num_cols
    rownames(object$cor_matrix) <- num_cols

  } else if (length(num_cols) == 1L) {
    object$copula     <- NULL
    object$cor_matrix <- matrix(1, 1, 1,
                                dimnames = list(num_cols, num_cols))
  }

  object$fitted <- TRUE
  object
}
