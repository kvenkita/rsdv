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

  unsupported <- names(Filter(is.null, object$transformers))
  if (length(unsupported) > 0L)
    warning(sprintf(
      "Column(s) %s have unsupported type(s) (e.g. 'datetime', 'id') and will be excluded from synthetic output.",
      paste(sprintf("'%s'", unsupported), collapse = ", ")
    ))

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

#' @export
sample.gaussian_copula_synthesizer <- function(x, n = 100, max_tries = 100L, ...) {
  if (!is_fitted(x)) stop("Synthesizer must be fitted before calling sample().")

  meta      <- x$metadata
  collected <- vector("list", max_tries)
  remaining <- n
  tries     <- 0L

  while (remaining > 0L && tries < max_tries) {
    tries  <- tries + 1L
    batch  <- .sample_raw(x, remaining)
    valid  <- check_constraints(batch, meta)
    good   <- batch[valid, , drop = FALSE]
    if (nrow(good) > 0L) {
      collected[[tries]] <- good
      remaining <- remaining - nrow(good)
    }
  }

  if (remaining > 0L) {
    warning(sprintf(
      "Could not satisfy all constraints after %d tries. Returning %d/%d rows.",
      max_tries, n - remaining, n
    ))
  }

  valid_batches <- Filter(Negate(is.null), collected)
  if (length(valid_batches) == 0L) {
    # All tries exhausted with zero valid rows — return a 0-row data frame
    col_names <- names(x$metadata$columns)
    empty <- vector("list", length(col_names))
    names(empty) <- col_names
    return(as.data.frame(empty, stringsAsFactors = FALSE))
  }
  out <- do.call(rbind, valid_batches)
  out[seq_len(min(n, nrow(out))), , drop = FALSE]
}

# Internal: generate n rows without constraint checking
.sample_raw <- function(x, n) {
  num_cols  <- x$num_cols
  cat_cols  <- x$cat_cols
  bool_cols <- x$bool_cols
  all_cols  <- names(x$metadata$columns)

  result <- vector("list", length(all_cols))
  names(result) <- all_cols

  if (length(num_cols) >= 2L) {
    u_samples <- copula::rCopula(n, x$copula)
    colnames(u_samples) <- num_cols
    for (col in num_cols) {
      vals <- invert_numerical_transformer(u_samples[, col], x$transformers[[col]])
      if (x$enforce_min_max) {
        tr   <- x$transformers[[col]]
        vals <- pmin(pmax(vals, tr$min), tr$max)
      }
      result[[col]] <- vals
    }
  } else if (length(num_cols) == 1L) {
    col  <- num_cols
    vals <- invert_numerical_transformer(stats::runif(n), x$transformers[[col]])
    if (x$enforce_min_max) {
      tr   <- x$transformers[[col]]
      vals <- pmin(pmax(vals, tr$min), tr$max)
    }
    result[[col]] <- vals
  }

  for (col in cat_cols) {
    result[[col]] <- sample_categorical(n, x$transformers[[col]])
  }
  for (col in bool_cols) {
    result[[col]] <- as.logical(stats::rbinom(n, 1L, x$transformers[[col]]$prob_true))
  }

  # Drop columns with no transformer (unsupported types: datetime, id)
  result <- Filter(Negate(is.null), result)

  as.data.frame(result, stringsAsFactors = FALSE)
}
