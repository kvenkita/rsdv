# rsdv — The R Synthetic Data Vault

**Synthetic data generation in R (Gaussian Copula based, extensible to
deep generative models)**

`rsdv` is an R implementation of Python’s [Synthetic Data Vault
(SDV)](https://sdv.dev/) framework (Patki, Wedge, and Veeramachaneni
2016). It generates synthetic tabular data using Gaussian copula models,
with built-in quality and privacy evaluation.

## Installation

``` r
# Development version
remotes::install_github("kvenkita/rsdv")
```

## Quick start

``` r
library(rsdv)
#> 
#> Attaching package: 'rsdv'
#> The following object is masked from 'package:base':
#> 
#>     sample

set.seed(42)

# Describe column types
meta <- metadata(adult_income) |>
  set_column_type("age",        "numerical") |>
  set_column_type("occupation", "categorical") |>
  set_column_type("income",     "categorical") |>
  set_primary_key("id")

# Fit a GaussianCopula synthesizer
syn       <- gaussian_copula_synthesizer(meta)
syn       <- fit(syn, adult_income)

# Generate 500 synthetic rows
synth_data <- sample(syn, n = 500)

# Evaluate quality
qr <- quality_report(real = adult_income, synthetic = synth_data,
                     metadata = meta)
#> Warning in ks.test.default(real[[col]], synthetic[[col]]): p-value will be
#> approximate in the presence of ties
#> Warning in ks.test.default(real[[col]], synthetic[[col]]): p-value will be
#> approximate in the presence of ties
#> Warning in ks.test.default(real[[col]], synthetic[[col]]): p-value will be
#> approximate in the presence of ties
#> Warning in ks.test.default(real[[col]], synthetic[[col]]): p-value will be
#> approximate in the presence of ties
#> Warning in ks.test.default(real[[col]], synthetic[[col]]): p-value will be
#> approximate in the presence of ties
#> Warning in ks.test.default(real[[col]], synthetic[[col]]): p-value will be
#> approximate in the presence of ties
print(qr)
#> == rsdv Quality Report ==
#> 
#> Column Similarity (KS, numerical):
#>   id                   0.972
#>   age                  0.672
#>   fnlwgt               0.318
#>   education_num        0.616
#>   capital_gain         0.066
#>   capital_loss         0.046
#>   hours_per_week       0.614
#> 
#> Column Similarity (TVD, categorical):
#>   workclass            0.953
#>   education            0.948
#>   marital_status       0.952
#>   occupation           0.953
#>   relationship         0.972
#>   race                 0.982
#>   sex                  0.968
#>   native_country       0.952
#>   income               0.996
#> 
#> Correlation Similarity:      0.965
#> 
#> Overall Score:               0.800
```

## Related work

- Python SDV: [sdv-dev/SDV](https://github.com/sdv-dev/SDV)
- Synthetic Data Vault paper: Patki et al., IEEE DSAA 2016
- CTGAN: Xu et al., NeurIPS 2019 (implemented in companion package
  `rsdv.torch`)
