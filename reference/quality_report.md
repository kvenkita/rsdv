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
#>   id                   0.942
#>   age                  0.958
#>   fnlwgt               0.944
#>   education_num        0.768
#>   capital_gain         0.498
#>   capital_loss         0.456
#>   hours_per_week       0.748
#> 
#> Column Similarity (TVD, categorical):
#>   workclass            0.978
#>   education            0.928
#>   marital_status       0.982
#>   occupation           0.938
#>   relationship         0.964
#>   race                 0.976
#>   sex                  0.952
#>   native_country       0.973
#>   income               0.978
#> 
#> Property scores:
#>   Column Shapes        0.874
#>   Column Pair Trends   0.901
#>     (correlation 0.973, contingency 0.859)
#> 
#> Overall Score:               0.887
# }
```
