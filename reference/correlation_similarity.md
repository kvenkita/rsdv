# Correlation matrix similarity between real and synthetic numerical data

Computes 1 minus the normalized Frobenius norm of the difference between
the Pearson correlation matrices of real and synthetic data.

## Usage

``` r
correlation_similarity(real, synthetic, meta)
```

## Arguments

- real:

  A data frame of real data.

- synthetic:

  A data frame of synthetic data.

- meta:

  An `rsdv_metadata` object.

## Value

A scalar score in \[0, 1\]; higher = better.

## Examples

``` r
# \donttest{
syn       <- gaussian_copula_synthesizer(metadata(adult_income)) |> fit(adult_income)
synth_data <- sample(syn, n = 500)
correlation_similarity(adult_income, synth_data, metadata(adult_income))
#> [1] 0.973481
# }
```
