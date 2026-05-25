# Save metadata to a JSON file

Save metadata to a JSON file

## Usage

``` r
save_metadata(meta, path)
```

## Arguments

- meta:

  An `rsdv_metadata` object.

- path:

  File path to write to.

## Value

Invisibly returns `meta`.

## Examples

``` r
meta <- metadata() |> set_column_type("age", "numerical")
tmp <- tempfile(fileext = ".json")
save_metadata(meta, tmp)
meta2 <- load_metadata(tmp)
```
