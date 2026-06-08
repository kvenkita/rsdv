# Attribute disclosure risk

Estimates the fraction of synthetic rows where a sensitive column value
can be correctly inferred from known columns via a k-NN lookup in the
real training data.

## Usage

``` r
attribute_disclosure_risk(real, synthetic, sensitive_col, known_cols, k = 1L)
```

## Arguments

- real, synthetic:

  Data frames.

- sensitive_col:

  Name of the column to protect.

- known_cols:

  Character vector of **numeric** columns assumed known to an adversary.
  Categorical columns are rejected with a clear error.

- k:

  Number of nearest neighbors used in inference.

## Value

A scalar in \[0, 1\]; lower = more private.

## Details

`known_cols` must be numeric, because nearest-neighbour lookup operates
on Euclidean distance over the columns. If you want to use a categorical
column as a known attribute, one-hot encode it first (e.g. with
`model.matrix(~ col - 1, data)`).

## Examples

``` r
real <- data.frame(age = sample(20:60, 50, replace = TRUE),
                   income = sample(c("low", "high"), 50, replace = TRUE),
                   stringsAsFactors = FALSE)
syn  <- real[sample(50), ]
attribute_disclosure_risk(real, syn, sensitive_col = "income", known_cols = "age")
#> [1] 0.72
```
