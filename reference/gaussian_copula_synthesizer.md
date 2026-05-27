# Create a Gaussian Copula synthesizer

Fits a single Gaussian copula over **all** modeled columns. Numerical
columns use a fitted parametric marginal (see `default_distribution`);
categorical and boolean columns are embedded into the copula via their
cumulative-frequency intervals, so cross-column dependence (numeric vs.
categorical, categorical vs. categorical) is preserved.

## Usage

``` r
gaussian_copula_synthesizer(
  metadata,
  enforce_min_max = TRUE,
  numerical_distributions = list(),
  default_distribution = "auto"
)
```

## Arguments

- metadata:

  An `rsdv_metadata` object.

- enforce_min_max:

  Logical. Clamp sampled numerical values to the observed range. Default
  `TRUE`.

- numerical_distributions:

  Optional named character vector/list mapping numerical column names to
  a distribution in `"norm"`, `"beta"`, `"gamma"`, `"truncnorm"`,
  `"uniform"`, or `"auto"`.

- default_distribution:

  Distribution used for numerical columns not named in
  `numerical_distributions`. `"auto"` (default) selects the best-fitting
  family per column by Kolmogorov-Smirnov distance.

## Value

An unfitted `gaussian_copula_synthesizer` object.

## Examples

``` r
# \donttest{
meta <- metadata(adult_income) |>
  set_column_type("age", "numerical") |>
  set_column_type("occupation", "categorical")
syn <- gaussian_copula_synthesizer(meta, default_distribution = "auto")
syn <- fit(syn, adult_income)
# }
```
