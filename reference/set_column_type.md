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

  For categorical columns the level *order* used by the synthesizer
  follows the input: a `factor` keeps its
  [`levels()`](https://rdrr.io/r/base/levels.html) order (including
  ordered factors), while a plain character column gets a sorted
  unique-value order for determinism. The sort is **lexicographic**, so
  numeric-like character columns (`c("2", "10")`) come back ordered
  `"10", "2"`. Coerce these to `factor` with the desired level order
  before fitting if order matters.

## Value

The updated `rsdv_metadata` object (for piping).

## Examples

``` r
metadata() |> set_column_type("age", "numerical")
#> rsdv Metadata
#>   Columns: 1 
#>     age [numerical]
```
