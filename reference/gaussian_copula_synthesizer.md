# Create a Gaussian Copula synthesizer

Fits a Gaussian copula to the numerical columns and samples categorical
columns independently from empirical marginals.

## Usage

``` r
gaussian_copula_synthesizer(metadata, enforce_min_max = TRUE)
```

## Arguments

- metadata:

  An `rsdv_metadata` object.

- enforce_min_max:

  Logical. Clamp sampled numerical values to the observed range. Default
  `TRUE`.

## Value

An unfitted `gaussian_copula_synthesizer` object.

## Examples

``` r
# \donttest{
meta <- metadata(adult_income) |>
  set_column_type("age", "numerical") |>
  set_column_type("occupation", "categorical")
syn <- gaussian_copula_synthesizer(meta)
syn <- fit(syn, adult_income)
# }
```
