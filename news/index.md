# Changelog

## rsdv 0.1.0

Initial CRAN release.

### New features

- Gaussian copula synthesizer
  ([`gaussian_copula_synthesizer()`](https://kvenkita.github.io/rsdv/reference/gaussian_copula_synthesizer.md))
  for generating synthetic tabular data that preserves marginal
  distributions and inter-column correlations.
- Column-type metadata system
  ([`metadata()`](https://kvenkita.github.io/rsdv/reference/metadata.md),
  [`set_column_type()`](https://kvenkita.github.io/rsdv/reference/set_column_type.md),
  [`set_primary_key()`](https://kvenkita.github.io/rsdv/reference/set_primary_key.md))
  with auto-detection and JSON serialization.
- Constraint system: equality, inequality, fixed-combinations, and
  custom row-level predicates
  ([`add_constraint()`](https://kvenkita.github.io/rsdv/reference/add_constraint.md),
  [`check_constraints()`](https://kvenkita.github.io/rsdv/reference/check_constraints.md)).
- Quality evaluation: KS similarity, TVD similarity, correlation
  similarity, and ML efficacy (TSTR/TRTR) metrics.
- Privacy evaluation: nearest-neighbor distance ratio (NNDR) score and
  attribute disclosure risk.
- `autoplot()` methods for quality and privacy reports.
- Missingness modeling: empirical NA rates from training data are
  reproduced in synthetic output.
- Bundled dataset: `adult_income` — a 500-row sample of the UCI Adult
  Income dataset for use in examples and vignettes.
