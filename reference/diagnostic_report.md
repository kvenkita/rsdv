# Generate a diagnostic (validity) report for synthetic data

Checks whether synthetic data is *structurally valid* against the real
data and metadata — independent of how closely it matches the real
distributions (that is the job of
[`quality_report()`](https://kvenkita.github.io/rsdv/reference/quality_report.md)).
Mirrors the SDMetrics `DiagnosticReport` two-property hierarchy:

## Usage

``` r
diagnostic_report(real, synthetic, metadata)
```

## Arguments

- real:

  A data frame of real data.

- synthetic:

  A data frame of synthetic data.

- metadata:

  An `rsdv_metadata` object.

## Value

An `rsdv_diagnostic_report` object.

## Details

- **Data Validity** — per-column checks:

  - numerical: boundary adherence (fraction of values within the real
    min/max range),

  - categorical: category adherence (fraction of values whose category
    was seen in the real data),

  - boolean: always valid,

  - primary key: key uniqueness (all values unique and non-missing).

- **Data Structure** — fraction of expected columns present in the
  synthetic data.

Missing (`NA`) values are excluded from adherence denominators, since
missingness is modeled separately.

## Examples

``` r
# \donttest{
meta  <- metadata(adult_income)
syn   <- gaussian_copula_synthesizer(meta) |> fit(adult_income)
synth <- sample(syn, n = 500)
diagnostic_report(adult_income, synth, meta)
#> == rsdv Diagnostic Report ==
#> 
#> Data Validity (per column):
#>   id                   boundary adherence   1.000
#>   age                  boundary adherence   1.000
#>   fnlwgt               boundary adherence   1.000
#>   education_num        boundary adherence   1.000
#>   capital_gain         boundary adherence   1.000
#>   capital_loss         boundary adherence   1.000
#>   hours_per_week       boundary adherence   1.000
#>   workclass            category adherence   1.000
#>   education            category adherence   1.000
#>   marital_status       category adherence   1.000
#>   occupation           category adherence   1.000
#>   relationship         category adherence   1.000
#>   race                 category adherence   1.000
#>   sex                  category adherence   1.000
#>   native_country       category adherence   1.000
#>   income               category adherence   1.000
#> 
#> Data Validity score:   1.000
#> Data Structure score:  1.000
#> 
#> Overall Score:         1.000
# }
```
