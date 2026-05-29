# Plot a quality report

Produces a bar chart of per-column similarity scores, with a horizontal
line at the overall score.

## Usage

``` r
# S3 method for class 'rsdv_quality_report'
autoplot(object, ...)
```

## Arguments

- object:

  An `rsdv_quality_report` object.

- ...:

  Unused.

## Value

A `ggplot` object.

## Examples

``` r
# \donttest{
syn <- gaussian_copula_synthesizer(metadata(adult_income)) |> fit(adult_income)
synth <- sample(syn, n = 500)
qr <- quality_report(adult_income, synth, metadata(adult_income))
ggplot2::autoplot(qr)

# }
```
