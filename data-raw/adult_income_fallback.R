# DEVELOPER CONVENIENCE ONLY — produces SYNTHETIC stand-in data.
# The shipped data/adult_income.rda was built from real UCI data via adult_income.R.
# Use this script only if the UCI download is unavailable.
set.seed(42)
n <- 500
adult_income <- tibble::tibble(
  id             = 1:n,
  age            = sample(18:90, n, replace = TRUE),
  workclass      = sample(c("Private","Self-emp","Gov","Never-worked"), n, replace = TRUE, prob = c(0.6,0.15,0.2,0.05)),
  fnlwgt         = sample(10000:1000000, n, replace = TRUE),
  education      = sample(c("HS-grad","Some-college","Bachelors","Masters","Doctorate"), n, replace = TRUE, prob = c(0.35,0.25,0.25,0.1,0.05)),
  education_num  = sample(1:16, n, replace = TRUE),
  marital_status = sample(c("Married","Never-married","Divorced","Separated","Widowed"), n, replace = TRUE, prob = c(0.45,0.32,0.14,0.05,0.04)),
  occupation     = sample(c("Prof-specialty","Craft-repair","Exec-managerial","Adm-clerical","Sales","Other-service"), n, replace = TRUE),
  relationship   = sample(c("Wife","Own-child","Husband","Not-in-family","Other-relative","Unmarried"), n, replace = TRUE),
  race           = sample(c("White","Black","Asian-Pac-Islander","Other"), n, replace = TRUE, prob = c(0.85,0.09,0.04,0.02)),
  sex            = sample(c("Male","Female"), n, replace = TRUE, prob = c(0.67,0.33)),
  capital_gain   = sample(c(rep(0, 400), sample(1000:100000, 100, replace = TRUE))),
  capital_loss   = sample(c(rep(0, 450), sample(100:4000, 50, replace = TRUE))),
  hours_per_week = sample(20:60, n, replace = TRUE),
  native_country = sample(c("United-States","Mexico","Philippines","Germany","Canada"), n, replace = TRUE, prob = c(0.9,0.04,0.02,0.02,0.02)),
  income         = sample(c("<=50K",">50K"), n, replace = TRUE, prob = c(0.75,0.25))
)
usethis::use_data(adult_income, overwrite = TRUE)
