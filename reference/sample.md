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

## Value

When `x` inherits from `rsdv_synthesizer`, a data frame of `n` synthetic
rows whose columns match the metadata. When `x` is any other object, the
value returned by [`base::sample()`](https://rdrr.io/r/base/sample.html)
— typically a vector of the same type as `x` and length `n`.

## Examples

``` r
# Falls back to base::sample for non-synthesizer objects:
sample(1:10, 3)
#> [1] 3 9 8

# \donttest{
meta  <- metadata(adult_income) |>
  set_column_type("age",    "numerical") |>
  set_column_type("income", "categorical")
syn   <- gaussian_copula_synthesizer(meta) |> fit(adult_income)
synth <- sample(syn, n = 100)
head(synth)
#>         id      age        workclass    fnlwgt    education education_num
#> 1 448.6573 36.24731          Private 312211.18 Some-college     14.819022
#> 2 208.1265 35.85911        Local-gov 298879.70      HS-grad     10.652169
#> 3 443.4026 63.24909 Self-emp-not-inc 214673.51    Bachelors     15.032347
#> 4 263.7632 42.22189          Private  72283.41      5th-6th     10.679390
#> 5 381.7495 27.64909     Self-emp-inc 218046.41      HS-grad      8.153799
#> 6 473.1874 21.44361        State-gov 210007.96 Some-college     10.157060
#>       marital_status      occupation  relationship  race    sex capital_gain
#> 1      Never-married    Craft-repair Not-in-family White   Male    648.42667
#> 2           Divorced Farming-fishing     Own-child Black Female     35.93673
#> 3      Never-married            <NA>       Husband White Female   3034.72984
#> 4      Never-married    Craft-repair     Unmarried White Female   2221.87632
#> 5      Never-married    Adm-clerical Not-in-family White   Male      0.00000
#> 6 Married-civ-spouse Exec-managerial     Own-child White Female      0.00000
#>   capital_loss hours_per_week native_country income
#> 1     800.6278       42.87681  United-States  <=50K
#> 2     274.3510       21.81674        Vietnam   >50K
#> 3     155.4710       62.35495  United-States  <=50K
#> 4     520.0082       20.15901  United-States   >50K
#> 5       0.0000       43.23913  United-States  <=50K
#> 6       0.0000       26.80713    Philippines  <=50K
# }
```
