#' Generate a quality report comparing real and synthetic data
#'
#' Runs KS similarity, TVD similarity, correlation similarity, and ML
#' efficacy, then computes a weighted overall score.
#'
#' @param real A data frame of real data.
#' @param synthetic A data frame of synthetic data.
#' @param metadata An `rsdv_metadata` object.
#' @param target_col Optional. Name of a categorical column for ML efficacy.
#'   If `NULL`, ML efficacy is omitted from the overall score.
#' @return An `rsdv_quality_report` object.
#' @export
#' @examples
#' meta  <- metadata(adult_income) |>
#'   set_column_type("age", "numerical") |>
#'   set_column_type("occupation", "categorical")
#' syn   <- gaussian_copula_synthesizer(meta) |> fit(adult_income)
#' synth <- sample(syn, n = 500)
#' qr    <- quality_report(adult_income, synth, meta)
#' print(qr)
quality_report <- function(real, synthetic, metadata, target_col = NULL) {
  ks_scores  <- ks_similarity(real, synthetic, metadata)
  tvd_scores <- tvd_similarity(real, synthetic, metadata)
  cor_score  <- correlation_similarity(real, synthetic, metadata)

  efficacy <- if (!is.null(target_col)) {
    ml_efficacy(real, synthetic, metadata, target_col)
  } else {
    NULL
  }

  component_scores <- c(
    if (nrow(ks_scores)  > 0L) mean(ks_scores$score,  na.rm = TRUE),
    if (nrow(tvd_scores) > 0L) mean(tvd_scores$score, na.rm = TRUE),
    cor_score
  )
  if (!is.null(efficacy)) component_scores <- c(component_scores, efficacy$score)
  overall <- if (length(component_scores) > 0L) mean(component_scores) else NA_real_

  structure(
    list(
      ks_scores         = ks_scores,
      tvd_scores        = tvd_scores,
      correlation_score = cor_score,
      ml_efficacy       = efficacy,
      overall_score     = overall
    ),
    class = "rsdv_quality_report"
  )
}

#' Print method for rsdv_quality_report
#'
#' @param x An `rsdv_quality_report` object.
#' @param ... Unused.
#' @return `x`, invisibly.
#'
#' @export
print.rsdv_quality_report <- function(x, ...) {
  cat("== rsdv Quality Report ==\n\n")

  if (nrow(x$ks_scores) > 0) {
    cat("Column Similarity (KS, numerical):\n")
    for (i in seq_len(nrow(x$ks_scores))) {
      cat(sprintf("  %-20s %.3f\n", x$ks_scores$column[i], x$ks_scores$score[i]))
    }
    cat("\n")
  }

  if (nrow(x$tvd_scores) > 0) {
    cat("Column Similarity (TVD, categorical):\n")
    for (i in seq_len(nrow(x$tvd_scores))) {
      cat(sprintf("  %-20s %.3f\n", x$tvd_scores$column[i], x$tvd_scores$score[i]))
    }
    cat("\n")
  }

  cat(sprintf("Correlation Similarity:      %.3f\n", x$correlation_score))

  if (!is.null(x$ml_efficacy)) {
    cat(sprintf("ML Efficacy (TSTR/TRTR):     %.3f\n", x$ml_efficacy$score))
  }

  cat(sprintf("\nOverall Score:               %.3f\n", x$overall_score))
  invisible(x)
}
