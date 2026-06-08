# Changelog

## rsdv 0.2.0

A correctness and robustness release driven by a code review of 0.1.0
(see [issue](https://github.com/kvenkita/rsdv/issues/12)
[\#12](https://github.com/kvenkita/rsdv/issues/12) for the full
catalogue). Two changes alter previously-returned numeric output and are
called out separately below.

### ⚠ Default-output changes (potentially breaking)

- [`nndr()`](https://kvenkita.github.io/rsdv/reference/nndr.md) now
  standardises (z-scores) each numerical column by the **real-data**
  mean and standard deviation before the nearest-neighbour distance is
  computed. Without this, a single large-scale column (e.g. `income` in
  dollars) dominated the Euclidean distance and the score moved with
  measurement units rather than with row similarity. Pass
  `normalize = FALSE` to recover the previous behaviour exactly.
- [`correlation_similarity()`](https://kvenkita.github.io/rsdv/reference/correlation_similarity.md)
  and
  [`contingency_similarity()`](https://kvenkita.github.io/rsdv/reference/contingency_similarity.md)
  now return `score = NA_real_` (rather than `1`) when there are fewer
  than two columns of the relevant type, and
  [`diagnostic_report()`](https://kvenkita.github.io/rsdv/reference/diagnostic_report.md)
  returns `NA_real_` per column when the synthetic column is entirely
  `NA`. Aggregated property scores in
  [`quality_report()`](https://kvenkita.github.io/rsdv/reference/quality_report.md)
  /
  [`diagnostic_report()`](https://kvenkita.github.io/rsdv/reference/diagnostic_report.md)
  skip these NAs (`na.rm = TRUE`) so they no longer overstate fidelity
  with a synthetic “1” where there is no signal to measure.

### New features

- [`equality_constraint()`](https://kvenkita.github.io/rsdv/reference/equality_constraint.md)
  gains a `tolerance` argument: with `tolerance > 0` on numeric columns,
  the check is `abs(a - b) <= tolerance` instead of exact `==`. Default
  `0` preserves prior behaviour.
- [`custom_constraint()`](https://kvenkita.github.io/rsdv/reference/custom_constraint.md)
  gains a `vectorized` argument: when `TRUE`, the predicate is called
  **once** with the whole data frame instead of once per row.
  Substantially faster on large synthetic samples for vectorisable
  predicates.
- [`ml_efficacy()`](https://kvenkita.github.io/rsdv/reference/ml_efficacy.md)
  gains a `seed` argument for reproducible train/test splits. The
  caller’s global RNG state is restored on exit, so callers using
  [`set.seed()`](https://rdrr.io/r/base/Random.html) elsewhere are
  unaffected.
- [`nndr()`](https://kvenkita.github.io/rsdv/reference/nndr.md) gains a
  `normalize` argument (default `TRUE`) — see the default-output note
  above.
- [`print()`](https://rdrr.io/r/base/print.html) methods for
  `equality_constraint`, `inequality_constraint`,
  `fixed_combinations_constraint`, and `custom_constraint`.

### Robustness and correctness

- [`metadata_to_json()`](https://kvenkita.github.io/rsdv/reference/metadata_to_json.md)
  /
  [`metadata_from_json()`](https://kvenkita.github.io/rsdv/reference/metadata_from_json.md)
  now round-trip the structural constraint types (`equality`,
  `inequality`, and `fixed_combinations`). `custom_constraint` cannot be
  serialised — it holds an R closure — and is dropped with a warning.
  Previously
  [`metadata_to_json()`](https://kvenkita.github.io/rsdv/reference/metadata_to_json.md)
  crashed on **any** constraint, so
  [`save_metadata()`](https://kvenkita.github.io/rsdv/reference/save_metadata.md)
  was effectively broken for non-trivial metadata.
- `check_constraint.equality_constraint` and
  `check_constraint.inequality_constraint` now return `FALSE` (not `NA`)
  for rows containing `NA`. This prevents `NA` from propagating into the
  row selector used by
  [`sample()`](https://kvenkita.github.io/rsdv/reference/sample.md)’s
  rejection loop, which previously inserted phantom NA-only rows.
- [`sample_conditions()`](https://kvenkita.github.io/rsdv/reference/sample_conditions.md)
  now honours metadata constraints alongside the user-supplied
  conditions (previously it filtered only on the conditions).
- [`tvd_similarity()`](https://kvenkita.github.io/rsdv/reference/tvd_similarity.md)
  now strips `NA`s from both sides and divides by the non-NA count on
  each side; previously NA-padding inflated TVD.
- [`ks_similarity()`](https://kvenkita.github.io/rsdv/reference/ks_similarity.md)
  now suppresses the [`ks.test()`](https://rdrr.io/r/stats/ks.test.html)
  *“p-value will be approximate in the presence of ties”* warning, which
  it leaked to users on any tied integer column (very common in tables
  with integer ages, capital gains, etc.).
- `fixed_combinations_constraint` now uses a collision-free
  length-prefix key encoding (`"<nchar>:<value>"`), removing a
  theoretical separator collision in the previous paste-based
  comparison.

### Clearer errors and validations

- `fit.gaussian_copula_synthesizer()` errors clearly when a modeled
  column is entirely `NA` or when no row is complete across all modeled
  columns. Previously the user saw a cryptic
  `'dim' must be an integer (>= 2)` from inside
  [`copula::normalCopula`](https://rdrr.io/pkg/copula/man/ellipCopula.html).
- [`ml_efficacy()`](https://kvenkita.github.io/rsdv/reference/ml_efficacy.md)
  validates `target_col` (must be a column of `real`) and
  `test_fraction` (must be strictly between 0 and 1) up front.
- [`attribute_disclosure_risk()`](https://kvenkita.github.io/rsdv/reference/attribute_disclosure_risk.md)
  validates that `known_cols` are present and numeric (one-hot encode
  categorical knowns first); previously triggered a cryptic
  [`FNN::knnx.index`](https://rdrr.io/pkg/FNN/man/knn.index.html) error.
- [`gaussian_copula_synthesizer()`](https://kvenkita.github.io/rsdv/reference/gaussian_copula_synthesizer.md)
  cross-checks `numerical_distributions` names against the metadata’s
  numerical columns; silently-ignored typos like
  `list(capitl_gain = "gamma")` now raise a clear error.
- [`sample_conditions()`](https://kvenkita.github.io/rsdv/reference/sample_conditions.md)
  validates that `.n` values are positive whole numbers (was silently
  truncating or accepting negatives).
- [`privacy_report()`](https://kvenkita.github.io/rsdv/reference/privacy_report.md)
  errors when only one of `sensitive_col` / `known_cols` is supplied
  (previously silently dropped disclosure-risk computation).
- [`set_primary_key()`](https://kvenkita.github.io/rsdv/reference/set_primary_key.md)
  emits an advisory warning when the column’s metadata type is not
  `"id"`, since the column would otherwise be modeled as ordinary data
  and the diagnostic key-uniqueness check would typically fail.

### Documentation

- [`set_column_type()`](https://kvenkita.github.io/rsdv/reference/set_column_type.md)
  docstring documents the level-ordering rule for categorical columns —
  `factor` keeps [`levels()`](https://rdrr.io/r/base/levels.html) order,
  character is sorted **lexicographically** (`c("2", "10")` becomes
  levels `c("10", "2")`).

## rsdv 0.1.0

CRAN release: 2026-06-08

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
