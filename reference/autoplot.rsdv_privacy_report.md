# Plot a privacy report

Plots the NNDR score as a gauge-style bar.

## Usage

``` r
# S3 method for class 'rsdv_privacy_report'
autoplot(object, ...)
```

## Arguments

- object:

  An `rsdv_privacy_report` object.

- ...:

  Unused.

## Value

A `ggplot` object.

## Examples

``` r
# \donttest{
syn <- gaussian_copula_synthesizer(metadata(adult_income)) |> fit(adult_income)
synth <- sample(syn, n = 500)
pr <- privacy_report(adult_income, synth)
ggplot2::autoplot(pr)

# }
```
