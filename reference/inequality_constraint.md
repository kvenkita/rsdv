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
#> $type
#> [1] "inequality"
#> 
#> $col_a
#> [1] "low"
#> 
#> $col_b
#> [1] "high"
#> 
#> $direction
#> [1] "lt"
#> 
#> attr(,"class")
#> [1] "inequality_constraint" "rsdv_constraint"      
```
