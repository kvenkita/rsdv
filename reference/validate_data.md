# Validate that a data frame is compatible with metadata

Checks that all columns registered in `meta` are present in `data`.

## Usage

``` r
validate_data(data, meta)
```

## Arguments

- data:

  A data frame.

- meta:

  An `rsdv_metadata` object.

## Value

Invisibly `TRUE`; throws an error if validation fails.

## Examples

``` r
meta <- metadata() |> set_column_type("age", "numerical")
validate_data(data.frame(age = 1:5), meta)
```
