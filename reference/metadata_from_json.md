# Deserialize metadata from a JSON string

Deserialize metadata from a JSON string

## Usage

``` r
metadata_from_json(json)
```

## Arguments

- json:

  A JSON character string produced by
  [`metadata_to_json()`](https://kvenkita.github.io/rsdv/reference/metadata_to_json.md).

## Value

An `rsdv_metadata` object. Constraints are reconstructed with their
original S3 classes so
[`check_constraint()`](https://kvenkita.github.io/rsdv/reference/check_constraint.md)
dispatches correctly.

## Examples

``` r
meta <- metadata() |>
  set_column_type("a", "numerical") |>
  set_column_type("b", "numerical") |>
  add_constraint(inequality_constraint("a", "b", type = "lt"))
metadata_from_json(metadata_to_json(meta))
#> rsdv Metadata
#>   Columns: 2 
#>     a [numerical]
#>     b [numerical]
```
