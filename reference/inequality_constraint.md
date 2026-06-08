# Constraint: col_a must be less than / greater than col_b

Constraint: col_a must be less than / greater than col_b

## Usage

``` r
inequality_constraint(col_a, col_b, type = c("lt", "lte", "gt", "gte"))
```

## Arguments

- col_a, col_b:

  Column names (character).

- type:

  One of `"lt"`, `"lte"`, `"gt"`, `"gte"`.

## Value

An `rsdv_constraint` object.

## Examples

``` r
inequality_constraint("low", "high", type = "lt")
#> <inequality_constraint>  low < high
```
