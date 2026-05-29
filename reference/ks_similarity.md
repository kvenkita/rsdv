# Kolmogorov-Smirnov similarity score per numerical column

Kolmogorov-Smirnov similarity score per numerical column

## Usage

``` r
ks_similarity(real, synthetic, meta)
```

## Arguments

- real:

  A data frame of real data.

- synthetic:

  A data frame of synthetic data.

- meta:

  An `rsdv_metadata` object.

## Value

A tibble with columns `column` (chr) and `score` (dbl, 0–1, higher =
better).

## Examples

``` r
# \donttest{
syn   <- gaussian_copula_synthesizer(metadata(adult_income)) |> fit(adult_income)
synth <- sample(syn, n = 500)
ks_similarity(adult_income, synth, metadata(adult_income))
#> # A tibble: 7 × 2
#>   column         score
#>   <chr>          <dbl>
#> 1 id             0.972
#> 2 age            0.944
#> 3 fnlwgt         0.954
#> 4 education_num  0.814
#> 5 capital_gain   0.49 
#> 6 capital_loss   0.462
#> 7 hours_per_week 0.77 
# }
```
