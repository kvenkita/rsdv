# Serialize metadata to a JSON string

Round-trips column types, primary key, and the structural constraints
(`equality`, `inequality`, `fixed_combinations`). `custom_constraint`
cannot be serialized — it holds an R closure — and is dropped with a
warning.

## Usage

``` r
metadata_to_json(meta)
```

## Arguments

- meta:

  An `rsdv_metadata` object.

## Value

A JSON character string. Inverse of
[`metadata_from_json()`](https://kvenkita.github.io/rsdv/reference/metadata_from_json.md).

## Examples

``` r
meta <- metadata() |>
  set_column_type("a", "numerical") |>
  set_column_type("b", "numerical") |>
  add_constraint(inequality_constraint("a", "b", type = "lt"))
json <- metadata_to_json(meta)
meta2 <- metadata_from_json(json)
```
