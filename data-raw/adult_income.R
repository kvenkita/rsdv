# Prepares a 500-row subset of UCI Adult Income for package examples.
# Source: https://archive.ics.uci.edu/ml/datasets/adult

col_names <- c(
  "age", "workclass", "fnlwgt", "education", "education_num",
  "marital_status", "occupation", "relationship", "race", "sex",
  "capital_gain", "capital_loss", "hours_per_week", "native_country", "income"
)

url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"

raw <- tryCatch(
  read.csv(url, header = FALSE, col.names = col_names,
           strip.white = TRUE, na.strings = "?"),
  error = function(e) stop("Could not download adult.data: ", e$message)
)

set.seed(42)
adult_income <- raw[sample(nrow(raw), 500), ]
adult_income <- tibble::as_tibble(adult_income)
adult_income$id <- seq_len(nrow(adult_income))
adult_income <- dplyr::select(adult_income, id, dplyr::everything())

usethis::use_data(adult_income, overwrite = TRUE)
