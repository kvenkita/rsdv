# Changelog

## rsdv 0.1.0

Initial CRAN release.

### Synthesizer

- Gaussian copula synthesizer
  ([`gaussian_copula_synthesizer()`](https://kvenkita.github.io/rsdv/reference/gaussian_copula_synthesizer.md))
  that fits a single joint copula over **all** modeled columns:
  numerical, categorical, and boolean.
- Parametric marginal fitting for numerical columns with best-fit
  selection among `norm`, `beta`, `gamma`, `truncnorm`, and `uniform` by
  Kolmogorov-Smirnov distance. Per-column overrides via
  `numerical_distributions`; global default via `default_distribution`.
- Categorical and boolean columns are embedded into the copula via their
  cumulative-frequency intervals, preserving cross-column dependence
  (numeric↔︎categorical and categorical↔︎categorical).
- [`sample()`](https://kvenkita.github.io/rsdv/reference/sample.md) for
  unconditional generation and
  [`sample_conditions()`](https://kvenkita.github.io/rsdv/reference/sample_conditions.md)
  for conditional generation on categorical or boolean values via
  rejection sampling.
- Per-column missingness rates from training data are reproduced in
  synthetic output.

### Metadata and constraints

- Column-type metadata system
  ([`metadata()`](https://kvenkita.github.io/rsdv/reference/metadata.md),
  [`set_column_type()`](https://kvenkita.github.io/rsdv/reference/set_column_type.md),
  [`set_primary_key()`](https://kvenkita.github.io/rsdv/reference/set_primary_key.md))
  with auto-detection and JSON serialization
  ([`metadata_to_json()`](https://kvenkita.github.io/rsdv/reference/metadata_to_json.md),
  [`save_metadata()`](https://kvenkita.github.io/rsdv/reference/save_metadata.md)).
- Declarative constraint system: equality, inequality,
  fixed-combinations, and custom row-level predicates
  ([`add_constraint()`](https://kvenkita.github.io/rsdv/reference/add_constraint.md),
  [`check_constraints()`](https://kvenkita.github.io/rsdv/reference/check_constraints.md)),
  enforced via rejection sampling.

### Evaluation

- [`quality_report()`](https://kvenkita.github.io/rsdv/reference/quality_report.md)
  aggregates metrics into the two-property hierarchy used by the Python
  `SDMetrics` library:
  - **Column Shapes** — per-column marginal fidelity (KS similarity for
    numerical, TVD similarity for categorical).
  - **Column Pair Trends** — pairwise dependence
    ([`correlation_similarity()`](https://kvenkita.github.io/rsdv/reference/correlation_similarity.md)
    for numerical pairs,
    [`contingency_similarity()`](https://kvenkita.github.io/rsdv/reference/contingency_similarity.md)
    for categorical pairs). ML efficacy (train-on-synthetic /
    test-on-real, TSTR/TRTR) is reported separately, not folded into the
    overall score.
- [`diagnostic_report()`](https://kvenkita.github.io/rsdv/reference/diagnostic_report.md)
  checks structural validity: boundary adherence (numerical ranges),
  category adherence (categorical values), and key uniqueness for
  primary keys.
- [`privacy_report()`](https://kvenkita.github.io/rsdv/reference/privacy_report.md)
  reports the nearest-neighbour distance ratio (NNDR) and, optionally,
  attribute disclosure risk.
- `autoplot()` methods for quality, diagnostic, and privacy reports.

### Data

- Bundled dataset `adult_income` — a 500-row sample of the UCI Adult
  Income dataset used in examples and vignettes.

### Vignettes

- “Getting Started with rsdv” — practitioner-oriented guide covering
  metadata, fitting, conditional sampling, quality and diagnostic
  reports, privacy evaluation, constraints, and missing-data handling.
- “Migrating from synthpop” — side-by-side comparison and feature table.
