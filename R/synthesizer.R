# Re-export generics::fit so users get fit() without loading generics separately.
#' @importFrom generics fit
#' @export
generics::fit

#' Sample synthetic rows from a fitted synthesizer
#'
#' Dispatches to the synthesizer-specific method when `x` is an
#' `rsdv_synthesizer`. For plain R vectors, integers, or characters it
#' falls back to [base::sample()], preserving backward compatibility.
#'
#' @param x A fitted synthesizer object, or a vector for [base::sample()] compat.
#' @param n Number of synthetic rows to generate (synthesizer path), or
#'   sample size (base::sample path).
#' @param ... Additional arguments passed to the method or to [base::sample()].
#' @export
sample <- function(x, n = NULL, ...) {
  if (inherits(x, "rsdv_synthesizer")) {
    UseMethod("sample")
  } else {
    args <- list(x = x, ...)
    if (!is.null(n)) args[["size"]] <- n
    do.call(base::sample, args)
  }
}

#' Check whether a synthesizer has been fitted
#'
#' @param x A synthesizer object.
#' @return `TRUE` if [fit()] has been called; `FALSE` otherwise.
#' @export
#' @examples
#' \dontrun{
#' syn <- gaussian_copula_synthesizer(metadata())
#' is_fitted(syn)
#' }
is_fitted <- function(x) {
  isTRUE(x$fitted)
}

#' Validate that a data frame is compatible with metadata
#'
#' Checks that all columns registered in `meta` are present in `data`.
#'
#' @param data A data frame.
#' @param meta An `rsdv_metadata` object.
#' @return Invisibly `TRUE`; throws an error if validation fails.
#' @export
#' @examples
#' \dontrun{
#' validate_data(adult_income, metadata(adult_income))
#' }
validate_data <- function(data, meta) {
  expected     <- names(meta$columns)
  missing_cols <- setdiff(expected, names(data))
  if (length(missing_cols) > 0L) {
    stop("Missing columns in data: ", paste(missing_cols, collapse = ", "))
  }
  invisible(TRUE)
}
