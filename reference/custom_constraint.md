# Constraint: arbitrary row-wise predicate

With `vectorized = FALSE` (default) `fn` is invoked once per row with a
one-row data frame and must return a single logical — easy to write but
slow on large frames. With `vectorized = TRUE` `fn` is invoked **once**
with the full data frame and must return a logical vector of length
`nrow(data)`; use this when your predicate is vectorisable for
substantial speedups on large synthetic samples.

## Usage

``` r
custom_constraint(fn, vectorized = FALSE)
```

## Arguments

- fn:

  A predicate function. If `vectorized = FALSE`, signature is `f(row)`
  returning a single logical. If `vectorized = TRUE`, signature is
  `f(data)` returning a logical vector of length `nrow(data)`.

- vectorized:

  Logical. See above. Default `FALSE`.

## Value

An `rsdv_constraint` object.

## Examples

``` r
custom_constraint(function(row) row$x > 0)
#> <custom_constraint>  row-wise predicate
# Vectorised — usually much faster:
custom_constraint(function(data) data$x > 0, vectorized = TRUE)
#> <custom_constraint>  vectorised predicate
```
