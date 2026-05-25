# Set the type of a column in metadata

Set the type of a column in metadata

## Usage

``` r
set_column_type(meta, column, type)
```

## Arguments

- meta:

  An `rsdv_metadata` object.

- column:

  Column name (character).

- type:

  One of `"numerical"`, `"categorical"`, `"boolean"`, `"datetime"`,
  `"id"`.

## Value

The updated `rsdv_metadata` object (for piping).

## Examples

``` r
metadata() |> set_column_type("age", "numerical")
#> rsdv Metadata
#>   Columns: 1 
#>     age [numerical]
```
