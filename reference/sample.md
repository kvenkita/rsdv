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
#> [1] 1 3 6

# \donttest{
meta  <- metadata(adult_income) |>
  set_column_type("age",    "numerical") |>
  set_column_type("income", "categorical")
syn   <- gaussian_copula_synthesizer(meta) |> fit(adult_income)
synth <- sample(syn, n = 100)
head(synth)
#>         id      age workclass    fnlwgt    education education_num
#> 1 496.1005 22.63580   Private 244277.33      HS-grad      9.402237
#> 2 151.7045 52.34715   Private 253542.40      HS-grad     11.311088
#> 3  42.4010 39.55661      <NA> 519520.69 Some-college      6.377475
#> 4 324.3207 60.55661 Local-gov 181866.18    Bachelors     11.438681
#> 5 449.4966 20.84860   Private 127803.23      HS-grad      7.604183
#> 6 186.6424 40.96523   Private  92935.35 Some-college      8.565641
#>       marital_status        occupation  relationship  race    sex capital_gain
#> 1      Never-married Machine-op-inspct          Wife White   Male        0.000
#> 2 Married-civ-spouse   Protective-serv       Husband White   Male     1788.196
#> 3 Married-civ-spouse   Exec-managerial       Husband Black   Male        0.000
#> 4 Married-civ-spouse   Protective-serv Not-in-family White Female      860.563
#> 5      Never-married      Craft-repair          Wife White Female        0.000
#> 6      Never-married      Craft-repair       Husband White Female      738.085
#>   capital_loss hours_per_week native_country income
#> 1        0.000       45.43182  United-States   >50K
#> 2        0.000       26.79922  United-States  <=50K
#> 3        0.000       46.09208  United-States  <=50K
#> 4     1001.675       65.98557  United-States   >50K
#> 5        0.000       15.74493  United-States  <=50K
#> 6      186.460       40.37035  United-States  <=50K
# }
```
