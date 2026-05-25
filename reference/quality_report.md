# Generate a quality report comparing real and synthetic data

Runs KS similarity, TVD similarity, correlation similarity, and ML
efficacy, then computes a weighted overall score.

## Usage

``` r
quality_report(real, synthetic, metadata, target_col = NULL)
```

## Arguments

- real:

  A data frame of real data.

- synthetic:

  A data frame of synthetic data.

- metadata:

  An `rsdv_metadata` object.

- target_col:

  Optional. Name of a categorical column for ML efficacy. If `NULL`, ML
  efficacy is omitted from the overall score.

## Value

An `rsdv_quality_report` object.

## Examples

``` r
# \donttest{
meta  <- metadata(adult_income) |>
  set_column_type("age", "numerical") |>
  set_column_type("occupation", "categorical")
syn   <- gaussian_copula_synthesizer(meta) |> fit(adult_income)
synth <- sample(syn, n = 500)
qr    <- quality_report(adult_income, synth, meta)
#> Warning: p-value will be approximate in the presence of ties
#> Warning: p-value will be approximate in the presence of ties
#> Warning: p-value will be approximate in the presence of ties
#> Warning: p-value will be approximate in the presence of ties
#> Warning: p-value will be approximate in the presence of ties
#> Warning: p-value will be approximate in the presence of ties
print(qr)
#> == rsdv Quality Report ==
#> 
#> Column Similarity (KS, numerical):
#>   id                   0.964
#>   age                  0.688
#>   fnlwgt               0.334
#>   education_num        0.594
#>   capital_gain         0.066
#>   capital_loss         0.046
#>   hours_per_week       0.636
#> 
#> Column Similarity (TVD, categorical):
#>   workclass            0.982
#>   education            0.954
#>   marital_status       0.960
#>   occupation           0.924
#>   relationship         0.962
#>   race                 0.990
#>   sex                  0.996
#>   native_country       0.966
#>   income               0.986
#> 
#> Correlation Similarity:      0.965
#> 
#> Overall Score:               0.803
# }
```
