# Nearest-Neighbor Distance Ratio privacy score

For each synthetic row, computes the ratio of its distance to the
nearest real row vs. its distance to the second-nearest real row. A high
ratio (close to 1) means the synthetic row is not unusually close to any
specific real row — low disclosure risk. Score = mean(ratio \> 0.5).

## Usage

``` r
nndr(real, synthetic, normalize = TRUE)
```

## Arguments

- real, synthetic:

  Data frames; only numerical columns are used.

- normalize:

  Logical. When `TRUE` (default), columns are z-scored using the
  real-data mean and standard deviation before distance computation.
  Constant columns in `real` are dropped to avoid division by zero.

## Value

A scalar score in \[0, 1\]; higher = more private.

## Details

By default columns are z-scored using the real-data mean and standard
deviation before the Euclidean distance is computed; without this, a
single large-scale column (e.g. income in dollars) dominates the
distance and the score becomes a function of measurement units rather
than of similarity.

## Examples

``` r
real <- data.frame(x = rnorm(50), y = rnorm(50))
syn  <- data.frame(x = rnorm(50), y = rnorm(50))
nndr(real, syn)
#> [1] 0.84
```
