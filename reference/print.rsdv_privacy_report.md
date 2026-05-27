# Print method for rsdv_privacy_report

Print method for rsdv_privacy_report

## Usage

``` r
# S3 method for class 'rsdv_privacy_report'
print(x, ...)
```

## Arguments

- x:

  An `rsdv_privacy_report` object.

- ...:

  Unused.

## Value

`x`, invisibly.

## Examples

``` r
# \donttest{
syn <- gaussian_copula_synthesizer(metadata(adult_income)) |> fit(adult_income)
synth <- sample(syn, n = 500)
pr <- privacy_report(adult_income, synth)
print(pr)
#> == rsdv Privacy Report ==
#> 
#> NNDR Score (higher = more private):  0.840
# }
```
