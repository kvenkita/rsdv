# Set the primary key column of the metadata

Set the primary key column of the metadata

## Usage

``` r
set_primary_key(meta, column)
```

## Arguments

- meta:

  An `rsdv_metadata` object.

- column:

  Name of the primary key column. Must already be registered via
  [`set_column_type()`](https://kvenkita.github.io/rsdv/reference/set_column_type.md).

## Value

The updated `rsdv_metadata` object (for piping).

## Examples

``` r
meta <- metadata() |>
  set_column_type("id", "id") |>
  set_primary_key("id")
```
