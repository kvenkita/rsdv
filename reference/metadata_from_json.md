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

An `rsdv_metadata` object.

## Examples

``` r
json <- metadata_to_json(metadata() |> set_column_type("age", "numerical"))
metadata_from_json(json)
#> rsdv Metadata
#>   Columns: 1 
#>     age [numerical]
```
