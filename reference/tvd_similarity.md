# Total variation distance similarity score per categorical column

Total variation distance similarity score per categorical column

## Usage

``` r
tvd_similarity(real, synthetic, meta)
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
tvd_similarity(adult_income, synth, metadata(adult_income))
#> # A tibble: 9 × 2
#>   column         score
#>   <chr>          <dbl>
#> 1 workclass      0.95 
#> 2 education      0.942
#> 3 marital_status 0.96 
#> 4 occupation     0.92 
#> 5 relationship   0.972
#> 6 race           0.99 
#> 7 sex            0.982
#> 8 native_country 0.96 
#> 9 income         0.988
# }
```
