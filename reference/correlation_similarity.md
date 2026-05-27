# Correlation similarity between real and synthetic numerical column pairs

For each pair of numerical columns, computes
`1 - |corr_real - corr_syn| / 2` (the SDMetrics `CorrelationSimilarity`
score), where `corr` is the Pearson correlation. Returns one row per
pair plus the mean.

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

A list with `pairs` (a tibble of `column_1`, `column_2`, `score`) and
`score` (the mean over pairs; `1` when there are fewer than two
numerical columns).

## Examples

``` r
# \donttest{
syn       <- gaussian_copula_synthesizer(metadata(adult_income)) |> fit(adult_income)
synth_data <- sample(syn, n = 500)
correlation_similarity(adult_income, synth_data, metadata(adult_income))
#> $pairs
#> # A tibble: 21 × 3
#>    column_1 column_2       score
#>    <chr>    <chr>          <dbl>
#>  1 id       age            0.977
#>  2 id       fnlwgt         0.998
#>  3 id       education_num  0.990
#>  4 id       capital_gain   0.997
#>  5 id       capital_loss   0.956
#>  6 id       hours_per_week 0.969
#>  7 age      fnlwgt         0.993
#>  8 age      education_num  0.979
#>  9 age      capital_gain   0.979
#> 10 age      capital_loss   0.999
#> # ℹ 11 more rows
#> 
#> $score
#> [1] 0.9744202
#> 
# }
```
