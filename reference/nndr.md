# Nearest-Neighbor Distance Ratio privacy score

For each synthetic row, computes the ratio of its distance to the
nearest real row vs. its distance to the second-nearest real row. A high
ratio (close to 1) means the synthetic row is not unusually close to any
specific real row — low disclosure risk. Score = mean(ratio \> 0.5).

## Usage

``` r
nndr(real, synthetic)
```

## Arguments

- real, synthetic:

  Data frames with only numerical columns.

## Value

A scalar score in \[0, 1\]; higher = more private.

## Examples

``` r
real <- data.frame(x = rnorm(50), y = rnorm(50))
syn  <- data.frame(x = rnorm(50), y = rnorm(50))
nndr(real, syn)
#> [1] 0.6
```
