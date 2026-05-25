# Add a constraint to metadata

Add a constraint to metadata

## Usage

``` r
add_constraint(meta, constraint)
```

## Arguments

- meta:

  An `rsdv_metadata` object.

- constraint:

  A constraint object from
  [`equality_constraint()`](https://kvenkita.github.io/rsdv/reference/equality_constraint.md),
  [`inequality_constraint()`](https://kvenkita.github.io/rsdv/reference/inequality_constraint.md),
  [`fixed_combinations_constraint()`](https://kvenkita.github.io/rsdv/reference/fixed_combinations_constraint.md),
  or
  [`custom_constraint()`](https://kvenkita.github.io/rsdv/reference/custom_constraint.md).

## Value

Updated `rsdv_metadata` (for piping).

## Examples

``` r
meta <- metadata() |>
  set_column_type("low", "numerical") |>
  set_column_type("high", "numerical") |>
  add_constraint(inequality_constraint("low", "high", type = "lt"))
```
