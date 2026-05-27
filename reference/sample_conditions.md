# Sample synthetic rows that match fixed column values (conditional sampling)

Generates rows in which one or more **categorical or boolean** columns
are held to specified values, via rejection sampling against the fitted
copula. This preserves the modeled dependence between the conditioned
columns and the rest of the table (unlike overwriting values after the
fact).

## Usage

``` r
sample_conditions(x, conditions, max_tries = 100L)
```

## Arguments

- x:

  A fitted `gaussian_copula_synthesizer`.

- conditions:

  A data frame whose columns are the variables to fix. Each row is one
  condition; an optional integer column `.n` gives how many rows to
  generate for that condition (default 1 per row).

- max_tries:

  Maximum rejection-sampling rounds per condition.

## Value

A data frame of synthetic rows satisfying the conditions.

## Examples

``` r
# \donttest{
meta <- metadata(adult_income)
syn  <- gaussian_copula_synthesizer(meta) |> fit(adult_income)
sample_conditions(syn, data.frame(income = ">50K", .n = 20))
#>            id      age        workclass    fnlwgt    education education_num
#> 11 218.822675 30.90465          Private 324717.88  Prof-school     13.363416
#> 13 384.738445 68.44926 Self-emp-not-inc 310593.11 Some-college     10.420431
#> 14 325.756964 21.57893          Private 251934.45 Some-college     14.904096
#> 15 352.125542 45.43990          Private 100460.39         12th      9.983138
#> 17 153.255800 56.46857          Private  32813.10 Some-college     12.792614
#> 24  17.508105 28.64699          Private 417179.54    Bachelors      7.769195
#> 28 160.955018 31.52125     Self-emp-inc 113454.37      HS-grad     12.211911
#> 33  90.870462 48.16254          Private 151842.85      HS-grad     10.172091
#> 45 442.724963 33.87502 Self-emp-not-inc 204749.75 Some-college     13.645111
#> 46 357.654725 23.74789          Private 134317.89  Prof-school      9.648725
#> 54 495.117944 37.79434          Private 113659.33 Some-college      8.118010
#> 56 488.228489 50.92532 Self-emp-not-inc 114969.24      HS-grad     15.019079
#> 58 218.578142 39.52778          Private  77478.44    Doctorate     14.106156
#> 61 355.609110 34.65901          Private  90193.28      HS-grad     11.286586
#> 65 498.691823 53.89243          Private 122761.39 Some-college      6.856831
#> 70 227.120005 38.58683          Private  74196.21          9th      9.183831
#> 73 337.765421 20.40998          Private 137027.75 Some-college     12.273447
#> 78 171.931516 47.68097          Private 429585.66  Prof-school      8.305664
#> 1  307.596951 19.34693             <NA> 138481.99      HS-grad     10.524892
#> 3    4.467406 37.16348          Private  81887.34      HS-grad      6.263031
#>        marital_status      occupation   relationship  race    sex capital_gain
#> 11      Never-married   Other-service        Husband White   Male   6014.99150
#> 13 Married-civ-spouse           Sales      Own-child White   Male     13.21143
#> 14      Never-married           Sales  Not-in-family White   Male   1172.40120
#> 15 Married-civ-spouse   Other-service  Not-in-family White   Male   1165.00309
#> 17 Married-civ-spouse Exec-managerial  Not-in-family White   Male   1836.09271
#> 24 Married-civ-spouse           Sales        Husband White   Male   1512.97534
#> 28      Never-married    Craft-repair      Own-child White   Male    764.68827
#> 33 Married-civ-spouse   Other-service        Husband White   Male   1919.51866
#> 45      Never-married   Other-service  Not-in-family White   Male    147.01363
#> 46          Separated   Other-service      Unmarried White Female   1766.13276
#> 54      Never-married           Sales      Unmarried White Female   3246.78893
#> 56           Divorced    Craft-repair  Not-in-family White   Male   3042.29061
#> 58           Divorced           Sales Other-relative White   Male    969.57926
#> 61 Married-civ-spouse Exec-managerial  Not-in-family White   Male      0.00000
#> 65 Married-civ-spouse    Craft-repair      Own-child White Female   2683.58866
#> 70          Separated   Other-service  Not-in-family White   Male      0.00000
#> 73      Never-married  Prof-specialty Other-relative White   Male      0.00000
#> 78 Married-civ-spouse Exec-managerial        Husband Black   Male   2876.82299
#> 1             Widowed    Adm-clerical      Own-child White Female   2364.52483
#> 3  Married-civ-spouse Exec-managerial      Own-child White   Male   3325.30648
#>    capital_loss hours_per_week native_country income
#> 11      0.00000       47.81940  United-States   >50K
#> 13    243.32611       30.02707        Jamaica   >50K
#> 14    126.04612       55.86331  United-States   >50K
#> 15    431.03873       44.80922  United-States   >50K
#> 17     40.29587       41.31825        Vietnam   >50K
#> 24    545.13531       36.70909  United-States   >50K
#> 28      0.00000       60.55708           <NA>   >50K
#> 33    972.38834       63.99284  United-States   >50K
#> 45    589.42260       49.44479  United-States   >50K
#> 46      0.00000       32.64750  United-States   >50K
#> 54      0.00000       29.27767  United-States   >50K
#> 56     92.83474       72.54016  United-States   >50K
#> 58    380.82144       43.82534  United-States   >50K
#> 61    135.41597       52.31162  United-States   >50K
#> 65    439.32340       33.64485  United-States   >50K
#> 70      0.00000       34.00656  United-States   >50K
#> 73    221.89106       60.44604  United-States   >50K
#> 78    951.03405       26.76013  United-States   >50K
#> 1     227.34198       32.06385  United-States   >50K
#> 3     137.80236       33.20034  United-States   >50K
# }
```
