# Constraint: arbitrary row-wise predicate

Constraint: arbitrary row-wise predicate

## Usage

``` r
custom_constraint(fn)
```

## Arguments

- fn:

  A function `f(row)` accepting a one-row data frame, returning a single
  logical.

## Value

An `rsdv_constraint` object.

## Examples

``` r
custom_constraint(function(row) row$x > 0)
#> $type
#> [1] "custom"
#> 
#> $fn
#> function (row) 
#> row$x > 0
#> <environment: 0x556065f980f8>
#> 
#> attr(,"class")
#> [1] "custom_constraint" "rsdv_constraint"  
```
