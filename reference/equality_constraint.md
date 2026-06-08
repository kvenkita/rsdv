# Constraint: two columns must be equal row-wise

For continuous numerical columns, exact `==` is almost never satisfied
by the copula sampler; use the `tolerance` argument or
[`inequality_constraint()`](https://kvenkita.github.io/rsdv/reference/inequality_constraint.md)
with a narrow band. With `tolerance > 0`, equality is
`abs(a - b) <= tolerance` for numeric columns and exact `==` otherwise.

## Usage

``` r
equality_constraint(col_a, col_b, tolerance = 0)
```

## Arguments

- col_a, col_b:

  Column names (character).

- tolerance:

  Numeric. When non-zero, numeric columns compare with
  `abs(a - b) <= tolerance` instead of exact `==`. Ignored for
  non-numeric columns. Default `0` (exact equality).

## Value

An `rsdv_constraint` object.

## Examples

``` r
equality_constraint("city", "city_copy")
#> <equality_constraint>  city == city_copy
equality_constraint("price_left", "price_right", tolerance = 1e-6)
#> <equality_constraint>  abs(price_left - price_right) <= 1e-06
```
