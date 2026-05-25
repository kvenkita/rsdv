# rsdv test script
# Run each section with Ctrl+Enter (line-by-line) or Ctrl+Shift+Enter (whole chunk)
# ─────────────────────────────────────────────────────────────────────────────

library(rsdv)

# ── 1. Explore the built-in dataset ──────────────────────────────────────────

head(adult_income)
dim(adult_income)   # 500 rows, 16 columns


# ── 2. Describe column types ──────────────────────────────────────────────────

meta <- metadata(adult_income) |>
  set_column_type("age",           "numerical") |>
  set_column_type("education_num", "numerical") |>
  set_column_type("hours_per_week","numerical") |>
  set_column_type("capital_gain",  "numerical") |>
  set_column_type("capital_loss",  "numerical") |>
  set_column_type("workclass",     "categorical") |>
  set_column_type("education",     "categorical") |>
  set_column_type("occupation",    "categorical") |>
  set_column_type("income",        "categorical") |>
  set_primary_key("id")

print(meta)


# ── 3. Fit the GaussianCopula synthesizer ─────────────────────────────────────

set.seed(42)
syn <- gaussian_copula_synthesizer(meta)
syn <- fit(syn, adult_income)

is_fitted(syn)       # TRUE
dim(syn$cor_matrix)  # correlation matrix over numerical columns


# ── 4. Generate synthetic data ────────────────────────────────────────────────

synth <- sample(syn, n = 500)

head(synth)
dim(synth)  # 500 rows, same columns as adult_income


# ── 5. Quality report ─────────────────────────────────────────────────────────

qr <- quality_report(adult_income, synth, meta)
print(qr)

# Visual comparison of column similarity scores
ggplot2::autoplot(qr)


# ── 6. Privacy report ─────────────────────────────────────────────────────────

pr <- privacy_report(adult_income, synth)
print(pr)

ggplot2::autoplot(pr)


# ── 7. Constraints ────────────────────────────────────────────────────────────

# Add a constraint: education_num must be less than hours_per_week
# (contrived, but shows the mechanism)
meta_constrained <- meta |>
  add_constraint(inequality_constraint("education_num", "hours_per_week", type = "lt"))

syn2   <- gaussian_copula_synthesizer(meta_constrained) |> fit(adult_income)
synth2 <- sample(syn2, n = 200)

# Verify every row satisfies the constraint
all(synth2$education_num < synth2$hours_per_week)  # TRUE


# ── 8. Save and reload metadata ───────────────────────────────────────────────

tmp <- tempfile(fileext = ".json")
save_metadata(meta, tmp)
meta2 <- load_metadata(tmp)
print(meta2)  # should match meta


# ── 9. Attribute disclosure risk (with known columns) ─────────────────────────

pr2 <- privacy_report(
  adult_income, synth,
  sensitive_col = "income",
  known_cols    = c("age", "education_num", "hours_per_week")
)
print(pr2)
# disclosure_risk: fraction of synthetic rows where income can be
# correctly guessed from the known columns via 1-NN lookup


# ── 10. Quality report with ML efficacy ───────────────────────────────────────

qr2 <- quality_report(adult_income, synth, meta, target_col = "income")
print(qr2)
# ml_efficacy$tstr  = Train-Synthetic Test-Real accuracy
# ml_efficacy$trtr  = Train-Real    Test-Real accuracy
# ml_efficacy$score = min(tstr/trtr, 1)  — how close synthetic is to real for ML
