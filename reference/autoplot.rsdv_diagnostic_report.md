# Plot a diagnostic report

Bar chart of per-column validity scores.

## Usage

``` r
# S3 method for class 'rsdv_diagnostic_report'
autoplot(object, ...)
```

## Arguments

- object:

  An `rsdv_diagnostic_report` object.

- ...:

  Unused.

## Value

A `ggplot` object.

## Examples

``` r
# \donttest{
meta  <- metadata(adult_income)
syn   <- gaussian_copula_synthesizer(meta) |> fit(adult_income)
synth <- sample(syn, n = 500)
ggplot2::autoplot(diagnostic_report(adult_income, synth, meta))

# }
```
