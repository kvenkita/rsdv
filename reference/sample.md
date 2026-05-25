# Sample synthetic rows from a fitted synthesizer

Dispatches to the synthesizer-specific method when `x` is an
`rsdv_synthesizer`. For plain R vectors, integers, or characters it
falls back to [`base::sample()`](https://rdrr.io/r/base/sample.html),
preserving backward compatibility.

## Usage

``` r
sample(x, n = NULL, ...)
```

## Arguments

- x:

  A fitted synthesizer object, or a vector for
  [`base::sample()`](https://rdrr.io/r/base/sample.html) compat.

- n:

  Number of synthetic rows to generate (synthesizer path), or sample
  size (base::sample path).

- ...:

  Additional arguments passed to the method or to
  [`base::sample()`](https://rdrr.io/r/base/sample.html).

## Examples

``` r
# Falls back to base::sample for non-synthesizer objects:
sample(1:10, 3)
#> [1] 2 6 8

# \donttest{
meta  <- metadata(adult_income) |>
  set_column_type("age",    "numerical") |>
  set_column_type("income", "categorical")
syn   <- gaussian_copula_synthesizer(meta) |> fit(adult_income)
synth <- sample(syn, n = 100)
head(synth)
#>           id      age        workclass     fnlwgt    education education_num
#> 1 254.688509 69.20714        Local-gov 1205107.28 Some-college      5.432897
#> 2 484.677518 70.29259          Private  832026.75      HS-grad      6.339311
#> 3 190.119016 78.15592 Self-emp-not-inc  331122.48    Assoc-voc     14.030534
#> 4 158.907900 17.08895          Private  853314.93      HS-grad      1.089733
#> 5   3.549389 25.35576          Private   96612.11 Some-college     11.630921
#> 6 272.118523 53.08531          Private  696779.40 Some-college      2.917459
#>       marital_status      occupation  relationship  race    sex capital_gain
#> 1 Married-civ-spouse Exec-managerial       Husband White   Male     784.1551
#> 2      Never-married  Prof-specialty     Unmarried White Female    3087.2572
#> 3      Never-married    Craft-repair Not-in-family White   Male    8978.0378
#> 4 Married-civ-spouse  Prof-specialty     Own-child White   Male    1222.8088
#> 5      Never-married  Prof-specialty     Own-child White   Male    6813.8550
#> 6 Married-civ-spouse   Other-service Not-in-family White   Male    9155.4665
#>   capital_loss hours_per_week native_country income
#> 1   1707.77807      58.174168  United-States  <=50K
#> 2    510.70166      95.413253  United-States  <=50K
#> 3    338.45074      85.025089         Mexico   >50K
#> 4     79.80332       4.695981  United-States  <=50K
#> 5    553.29310      85.796827  United-States  <=50K
#> 6    273.84578       4.816079  United-States  <=50K
# }
```
