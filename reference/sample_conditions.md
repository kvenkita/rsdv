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
#> 3    35.04209 44.42807 Self-emp-not-inc 256683.33    Assoc-voc      9.190270
#> 6   491.66844 40.85277 Self-emp-not-inc 228998.08      HS-grad      8.328983
#> 11   29.87270 73.61848          Private 112817.73         11th     10.481706
#> 13  355.66350 44.69825 Self-emp-not-inc 211613.70    Bachelors     13.075877
#> 15  436.63050 37.89232        Local-gov 191834.18    Bachelors      8.645717
#> 24  469.44515 46.51247          Private 195484.37 Some-college     12.392167
#> 36  471.49163 60.64892        State-gov 165212.24   Assoc-acdm     10.753584
#> 41   17.30974 41.90962          Private 329917.95         10th     11.084558
#> 42  373.83315 39.18879          Private 303704.71   Assoc-acdm      8.763322
#> 43  351.84878 58.99607          Private  41931.05          9th     13.457904
#> 48   81.38596 23.69715          Private  33624.78      7th-8th      8.247015
#> 60  490.01407 49.17818          Private 111274.35         11th      9.423415
#> 61  467.22816 23.77856             <NA> 122917.70      HS-grad      9.389316
#> 64  427.05000 61.51472          Private 211830.71    Bachelors     14.093172
#> 1   435.21279 19.00053 Self-emp-not-inc 217106.36 Some-college      8.048320
#> 5   146.60520 23.39611             <NA> 140145.93      7th-8th      8.359141
#> 10  497.82178 25.41194 Self-emp-not-inc 105243.77      HS-grad      8.507569
#> 131 412.78472 45.34705 Self-emp-not-inc  60500.87    Bachelors     12.213861
#> 14  128.46251 37.34718          Private 132113.20      HS-grad     10.618252
#> 151 218.26804 43.43061          Private 172995.81 Some-college      3.143792
#>            marital_status        occupation   relationship  race    sex
#> 3           Never-married   Exec-managerial  Not-in-family White   Male
#> 6   Married-spouse-absent    Prof-specialty      Unmarried White   Male
#> 11               Divorced      Adm-clerical  Not-in-family White   Male
#> 13          Never-married      Craft-repair  Not-in-family White Female
#> 15          Never-married   Exec-managerial        Husband White Female
#> 24               Divorced      Craft-repair  Not-in-family White   Male
#> 36     Married-civ-spouse   Exec-managerial  Not-in-family White   Male
#> 41     Married-civ-spouse   Exec-managerial  Not-in-family White   Male
#> 42     Married-civ-spouse     Other-service        Husband White   Male
#> 43     Married-civ-spouse    Prof-specialty        Husband White   Male
#> 48              Separated   Farming-fishing        Husband White   Male
#> 60     Married-civ-spouse Machine-op-inspct  Not-in-family White   Male
#> 61     Married-civ-spouse    Prof-specialty      Unmarried White   Male
#> 64     Married-civ-spouse   Exec-managerial  Not-in-family White   Male
#> 1           Never-married     Other-service Other-relative White   Male
#> 5           Never-married             Sales  Not-in-family White   Male
#> 10     Married-civ-spouse     Other-service      Own-child White   Male
#> 131              Divorced   Exec-managerial        Husband Black Female
#> 14     Married-civ-spouse     Other-service      Own-child White Female
#> 151    Married-civ-spouse Handlers-cleaners  Not-in-family White   Male
#>     capital_gain capital_loss hours_per_week     native_country income
#> 3       793.7141    743.44551       32.35546      United-States   >50K
#> 6      2240.3643      0.00000       36.57502      United-States   >50K
#> 11      100.1136      0.00000       62.68463           Portugal   >50K
#> 13        0.0000    310.81039       40.24056      United-States   >50K
#> 15        0.0000    530.49276       39.38298      United-States   >50K
#> 24     2205.5249      0.00000       56.62289      United-States   >50K
#> 36     1501.2198     12.12366       29.25473      United-States   >50K
#> 41        0.0000    618.84733       53.20314 Dominican-Republic   >50K
#> 42        0.0000    769.71221       60.77036      United-States   >50K
#> 43     1284.8113   1158.82745       83.43212      United-States   >50K
#> 48     1821.5660     86.68609       40.75433      United-States   >50K
#> 60     3422.1619    774.04811       43.36069      United-States   >50K
#> 61        0.0000    197.41299       44.68429      United-States   >50K
#> 64        0.0000     19.44796       74.45704            Germany   >50K
#> 1      1609.1082      0.00000       34.79870      United-States   >50K
#> 5         0.0000    454.73499       28.40710        Philippines   >50K
#> 10        0.0000      0.00000       45.95187      United-States   >50K
#> 131    2415.4115      0.00000       34.85091      United-States   >50K
#> 14        0.0000    928.64780       33.39666      United-States   >50K
#> 151       0.0000    219.48570       26.23661      United-States   >50K
# }
```
