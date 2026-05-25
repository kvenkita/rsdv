# Load metadata from a JSON file

Load metadata from a JSON file

## Usage

``` r
load_metadata(path)
```

## Arguments

- path:

  Path to a JSON file produced by
  [`save_metadata()`](https://kvenkita.github.io/rsdv/reference/save_metadata.md).

## Value

An `rsdv_metadata` object.

## Examples

``` r
meta <- metadata() |> set_column_type("age", "numerical")
tmp  <- tempfile(fileext = ".json")
save_metadata(meta, tmp)
load_metadata(tmp)
#> rsdv Metadata
#>   Columns: 1 
#>     age [numerical]
```
