# Create a metadata object describing a dataset's column types

Create a metadata object describing a dataset's column types

## Usage

``` r
metadata(data = NULL)
```

## Arguments

- data:

  Optional data frame. If supplied, column types are auto-detected. You
  can override them with
  [`set_column_type()`](https://kvenkita.github.io/rsdv/reference/set_column_type.md).

## Value

An `rsdv_metadata` object.

## Examples

``` r
meta <- metadata(adult_income) |>
  set_column_type("age", "numerical") |>
  set_column_type("occupation", "categorical")
```
