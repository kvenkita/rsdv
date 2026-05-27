# Generate a privacy report comparing real and synthetic data

Generate a privacy report comparing real and synthetic data

## Usage

``` r
privacy_report(real, synthetic, sensitive_col = NULL, known_cols = NULL)
```

## Arguments

- real:

  A data frame of real data.

- synthetic:

  A data frame of synthetic data.

- sensitive_col:

  Optional. Column name for attribute disclosure risk.

- known_cols:

  Optional. Column names known to an adversary (required if
  `sensitive_col` is supplied).

## Value

An `rsdv_privacy_report` object.

## Examples

``` r
# \donttest{
syn   <- gaussian_copula_synthesizer(metadata(adult_income)) |>
  fit(adult_income)
synth <- sample(syn, n = 500)
pr    <- privacy_report(adult_income, synth)
print(pr)
#> == rsdv Privacy Report ==
#> 
#> NNDR Score (higher = more private):  0.852
# }
```
