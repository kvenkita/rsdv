# Constraint: only observed column combinations are valid

Constraint: only observed column combinations are valid

## Usage

``` r
fixed_combinations_constraint(columns, reference_data)
```

## Arguments

- columns:

  Character vector of column names.

- reference_data:

  Data frame containing the allowed combinations.

## Value

An `rsdv_constraint` object.

## Examples

``` r
ref <- data.frame(city = c("NY", "LA"), state = c("NY", "CA"),
                  stringsAsFactors = FALSE)
fixed_combinations_constraint(c("city", "state"), ref)
#> $type
#> [1] "fixed_combinations"
#> 
#> $columns
#> [1] "city"  "state"
#> 
#> $allowed
#>   city state
#> 1   NY    NY
#> 2   LA    CA
#> 
#> attr(,"class")
#> [1] "fixed_combinations_constraint" "rsdv_constraint"              
```
