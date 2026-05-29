# Generate a quality report comparing real and synthetic data

Aggregates metrics into the two-property hierarchy used by SDMetrics:

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

  Optional. Name of a categorical column for ML efficacy. Reported
  alongside the score but excluded from the overall.

## Value

An `rsdv_quality_report` object.

## Details

- **Column Shapes** — per-column marginal fidelity: KS similarity for
  numerical columns and TVD similarity for categorical columns.

- **Column Pair Trends** — pairwise dependence: correlation similarity
  for numerical pairs and contingency similarity for categorical pairs.

The overall score is the mean of the two property scores, so a table
with many categorical columns and few numerical ones is not weighted by
raw column counts. ML efficacy, when requested, is reported separately
and does **not** enter the overall score (matching SDMetrics).

## Examples

``` r
# \donttest{
meta  <- metadata(adult_income) |>
  set_column_type("age", "numerical") |>
  set_column_type("occupation", "categorical")
syn   <- gaussian_copula_synthesizer(meta) |> fit(adult_income)
synth <- sample(syn, n = 500)
qr    <- quality_report(adult_income, synth, meta)
print(qr)
#> == rsdv Quality Report ==
#> 
#> Column Similarity (KS, numerical):
#>   id                   0.974
#>   age                  0.954
#>   fnlwgt               0.956
#>   education_num        0.784
#>   capital_gain         0.480
#>   capital_loss         0.468
#>   hours_per_week       0.762
#> 
#> Column Similarity (TVD, categorical):
#>   workclass            0.960
#>   education            0.950
#>   marital_status       0.972
#>   occupation           0.942
#>   relationship         0.954
#>   race                 0.986
#>   sex                  0.996
#>   native_country       0.960
#>   income               0.996
#> 
#> Property scores:
#>   Column Shapes        0.881
#>   Column Pair Trends   0.901
#>     (correlation 0.980, contingency 0.854)
#> 
#> Overall Score:               0.891
# }
```
