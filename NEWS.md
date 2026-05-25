# rsdv 0.1.0

Initial CRAN release.

## New features

* Gaussian copula synthesizer (`gaussian_copula_synthesizer()`) for generating
  synthetic tabular data that preserves marginal distributions and inter-column
  correlations.
* Column-type metadata system (`metadata()`, `set_column_type()`,
  `set_primary_key()`) with auto-detection and JSON serialization.
* Constraint system: equality, inequality, fixed-combinations, and custom
  row-level predicates (`add_constraint()`, `check_constraints()`).
* Quality evaluation: KS similarity, TVD similarity, correlation similarity,
  and ML efficacy (TSTR/TRTR) metrics.
* Privacy evaluation: nearest-neighbor distance ratio (NNDR) score and
  attribute disclosure risk.
* `autoplot()` methods for quality and privacy reports.
* Missingness modeling: empirical NA rates from training data are reproduced
  in synthetic output.
* Bundled dataset: `adult_income` — a 500-row sample of the UCI Adult Income
  dataset for use in examples and vignettes.
