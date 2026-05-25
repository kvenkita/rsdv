# Check a single constraint against each row of a data frame

Check a single constraint against each row of a data frame

## Usage

``` r
check_constraint(data, constraint)
```

## Arguments

- data:

  A data frame.

- constraint:

  An `rsdv_constraint` object.

## Value

Logical vector of length `nrow(data)`.

## Examples

``` r
df <- data.frame(a = c(1, 2, 3), b = c(1, 2, 9))
check_constraint(df, equality_constraint("a", "b"))
#> [1]  TRUE  TRUE FALSE
```
