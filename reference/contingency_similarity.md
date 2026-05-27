# Contingency similarity between real and synthetic categorical column pairs

For each pair of categorical columns, compares the joint (normalized
contingency) distributions of real and synthetic data via total
variation distance, scoring `1 - TVD` (the SDMetrics
`ContingencySimilarity` score). This is the categorical analogue of
correlation similarity and captures categorical-vs-categorical
dependence.

## Usage

``` r
contingency_similarity(real, synthetic, meta)
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
categorical columns).

## Examples

``` r
# \donttest{
meta  <- metadata(adult_income)
syn   <- gaussian_copula_synthesizer(meta) |> fit(adult_income)
synth <- sample(syn, n = 500)
contingency_similarity(adult_income, synth, meta)
#> $pairs
#> # A tibble: 36 × 3
#>    column_1  column_2       score
#>    <chr>     <chr>          <dbl>
#>  1 workclass education      0.833
#>  2 workclass marital_status 0.883
#>  3 workclass occupation     0.79 
#>  4 workclass relationship   0.887
#>  5 workclass race           0.945
#>  6 workclass sex            0.949
#>  7 workclass native_country 0.924
#>  8 workclass income         0.929
#>  9 education marital_status 0.834
#> 10 education occupation     0.673
#> # ℹ 26 more rows
#> 
#> $score
#> [1] 0.8600278
#> 
# }
```
