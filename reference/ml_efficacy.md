# ML efficacy: train-on-synthetic / test-on-real accuracy ratio (TSTR)

Trains an `rpart` decision tree on synthetic data and on a real training
split, evaluates both on a real held-out test set, and returns the ratio
TSTR / TRTR. A score near 1 means synthetic data is as informative as
real data for this prediction task.

## Usage

``` r
ml_efficacy(real, synthetic, meta, target_col, test_fraction = 0.2)
```

## Arguments

- real:

  A data frame of real data.

- synthetic:

  A data frame of synthetic data.

- meta:

  An `rsdv_metadata` object.

- target_col:

  Name of a categorical column to use as the outcome.

- test_fraction:

  Fraction of `real` to hold out as the test set.

## Value

A list with elements `tstr` (accuracy), `trtr` (accuracy), and `score`
(ratio, capped at 1).

## Examples

``` r
# \donttest{
meta      <- metadata(adult_income)
syn       <- gaussian_copula_synthesizer(meta) |> fit(adult_income)
synth_data <- sample(syn, n = 500)
ml_efficacy(adult_income, synth_data, meta, target_col = "income")
#> $tstr
#> [1] 0.77
#> 
#> $trtr
#> [1] 0.77
#> 
#> $score
#> [1] 1
#> 
# }
```
