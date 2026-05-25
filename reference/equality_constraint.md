# Constraint: two columns must be equal row-wise

Constraint: two columns must be equal row-wise

## Usage

``` r
equality_constraint(col_a, col_b)
```

## Arguments

- col_a, col_b:

  Column names (character).

## Value

An `rsdv_constraint` object.

## Examples

``` r
equality_constraint("city", "city_copy")
#> $type
#> [1] "equality"
#> 
#> $col_a
#> [1] "city"
#> 
#> $col_b
#> [1] "city_copy"
#> 
#> attr(,"class")
#> [1] "equality_constraint" "rsdv_constraint"    
```
