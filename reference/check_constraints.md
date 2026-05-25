# Check all constraints in metadata against a data frame

Check all constraints in metadata against a data frame

## Usage

``` r
check_constraints(data, meta)
```

## Arguments

- data:

  A data frame.

- meta:

  An `rsdv_metadata` object.

## Value

Logical vector of length `nrow(data)`. `TRUE` = row passes all
constraints.

## Examples

``` r
meta <- metadata() |>
  set_column_type("x", "numerical") |>
  add_constraint(custom_constraint(function(row) row$x > 0))
check_constraints(data.frame(x = c(1, -1, 2)), meta)
#> [1]  TRUE FALSE  TRUE
```
