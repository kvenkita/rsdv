# Check whether a synthesizer has been fitted

Check whether a synthesizer has been fitted

## Usage

``` r
is_fitted(x)
```

## Arguments

- x:

  A synthesizer object.

## Value

`TRUE` if [`fit()`](https://generics.r-lib.org/reference/fit.html) has
been called; `FALSE` otherwise.

## Examples

``` r
syn <- gaussian_copula_synthesizer(metadata())
is_fitted(syn)  # FALSE before fitting
#> [1] FALSE
```
