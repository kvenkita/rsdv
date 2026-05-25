# Serialize metadata to a JSON string

Serialize metadata to a JSON string

## Usage

``` r
metadata_to_json(meta)
```

## Arguments

- meta:

  An `rsdv_metadata` object.

## Value

A JSON character string.

## Examples

``` r
meta <- metadata() |> set_column_type("age", "numerical")
json <- metadata_to_json(meta)
meta2 <- metadata_from_json(json)
```
