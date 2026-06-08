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
#> <fixed_combinations_constraint>  city, state  (2 allowed combinations)
```
