# rsdv Stress Testing Report

**Date:** 2026-05-25  
**Package version:** 0.1.0  
**R version:** 4.4.3

---

## Summary

Ten real-world researcher scenarios were executed against the package after initial development.
Three bugs were found and fixed (commits `079081f`, `92419a9`).
One design-level silent behavior was identified and documented.

---

## Scenarios

### S1 — Numerical-only dataset (`mtcars`)

**Description:** All columns treated as numerical; no categorical columns.  
**Status:** ✅ Works correctly  
**Notes:** TVD scores tibble was empty (as expected). `overall_score` computed from KS and correlation components only, no NaN. Quality report printed cleanly.

---

### S2 — Numerical columns with missing values (`airquality`)

**Description:** `Ozone` (37 NAs) and `Solar.R` (7 NAs) contain real missingness.  
**Status:** ✅ Works — silent behavior noted  
**Notes:** NAs are silently dropped before copula fitting via `is.finite()` in `fit_numerical_transformer`. Synthetic output contains zero NAs regardless of real-data missingness. The synthesizer makes no attempt to model or reproduce missing-data mechanisms. This is consistent with standard copula-based synthesis but is undocumented.

---

### S3 — Factor columns (`diamonds` from ggplot2)

**Description:** `cut`, `color`, `clarity` are `ordered factor` in the input.  
**Status:** 🐛 Bug found and fixed (commit `92419a9`)  
**Root cause:** `fit_categorical_transformer()` called `as.character(x)` unconditionally, discarding the factor class and ordinal level ordering. `sample_categorical()` returned plain character strings.  
**Fix:** Transformer now records `is_factor` and `is_ordered` flags and the original level order. `sample_categorical()` returns a `factor` (with `ordered = TRUE` if appropriate) when the training column was a factor.  
**Before:** `class(out$cut)` → `"character"`  
**After:** `class(out$cut)` → `"ordered" "factor"`, `levels(out$cut)` → `Fair < Good < Very Good < Premium < Ideal`

---

### S4 — Date columns

**Description:** Data frame containing a `Date` column (`dob`) alongside numerical and boolean columns.  
**Status:** 🐛 Bug found and fixed (commit `92419a9`)  
**Root cause:** `fit_transformers()` returns `NULL` for `datetime` and `id` types. `.sample_raw()` only iterates over `num_cols`, `cat_cols`, and `bool_cols`, leaving `dob` as `NULL` in the result list. `as.data.frame()` on a list with a `NULL` element treated it as a zero-row column, causing `"arguments imply differing number of rows: n, 0"`.  
**Fix:** `.sample_raw()` now filters `NULL` entries from the result list before calling `as.data.frame()`. `fit()` now emits a warning listing any excluded columns.  
**Before:** `sample()` errors with dimension mismatch  
**After:** `sample()` succeeds; `dob` is excluded from output with a warning: *"Column(s) 'dob' have unsupported type(s) (e.g. 'datetime', 'id') and will be excluded from synthetic output."*

---

### S5 — High-cardinality categorical columns (50 states, 80 occupations)

**Description:** Categorical columns with 50 and 80 unique levels sampled into a 300-row dataset.  
**Status:** ✅ Works correctly  
**Notes:** Not all levels appeared in the 300-row synthetic output (47/50 states, 76/80 occupations) — expected behavior when sampling fewer rows than there are levels. `quality_report()` and `ml_efficacy()` ran without error.

---

### S6 — Very small dataset (5 rows)

**Description:** 5-row data frame with 2 numerical and 1 categorical column.  
**Status:** ✅ Works correctly  
**Notes:** Copula fitting and sampling from a 5-row dataset succeeded. `sample(syn, n = 20)` produced 20 rows (more than the training set). Quality report ran without error.

---

### S7 — Wide dataset with many correlated numerical columns (15 biomarkers)

**Description:** 15 correlated numerical columns (uniform correlation 0.4) plus 1 categorical outcome. Simulates a biomarker / clinical panel dataset.  
**Status:** ✅ Works correctly  
**Notes:** `normalCopula(dim = 15, dispstr = "un")` fitted without near-singularity issues. `itau` estimation stable. Correlation similarity score: 0.955, indicating the copula correctly captured the inter-column structure.

---

### S8 — Real public dataset: UCI Wine Quality (1,599 rows, 12 columns)

**Description:** Downloaded from the UCI Machine Learning Repository. All columns are continuous except `quality` (integer), which was typed as `categorical`.  
**Status:** 🐛 Bug found and fixed (commit `92419a9`)  
**Root cause:** `nndr()` selected numeric columns from `real` and `synthetic` independently using `is.numeric()`. Because `quality` is `integer` (numeric) in `real` but `character` (categorical) in `synthetic`, the two matrices had different column counts. `FNN::knnx.dist()` then errored: *"Number of columns must be same!"*  
**Fix:** `nndr()` now computes the intersection of numeric column names from both frames and operates on that shared set.  
**Before:** `privacy_report()` errors  
**After:** `privacy_report()` succeeds; NNDR score computed on the 11 shared numeric columns.

---

### S9 — Survey data with categorical NAs (GSS-style simulation)

**Description:** 500-row simulated survey with realistic skip-pattern missingness: 10% NA in `income`, ~5% NA in `happy` (categorical). Tests whether `NA` is leaked as the string `"NA"` into categorical levels.  
**Status:** ✅ Works correctly  
**Notes:** NAs are not synthesized as the string `"NA"`. `fit_categorical_transformer()` calls `as.character(NA)` = `"NA"` internally but the updated implementation skips NA values when computing levels (`unique(x_char[!is.na(x_char)])`). Synthetic `happy` column contained only valid survey responses, not the string `"NA"`. Same silent NA-dropping behavior as S2.

---

### S10 — Census-style PUMS simulation (1,000 rows, 250-level PUMA codes)

**Description:** Simulates US Census PUMS data with 250 unique geographic area codes, ~35% missing `WKHP` (hours worked), and standard demographic columns. Tests scalability with very high-cardinality categoricals and a large fraction of missingness.  
**Status:** ✅ Works correctly  
**Notes:** All 250 PUMA levels sampled into 500 synthetic rows (247 unique in output — expected). Missing `WKHP` dropped silently (same as S2/S9). Overall quality score: 0.921. No performance issues at 1,000 rows × 8 columns.

---

## Bugs Fixed

| # | Severity | Scenario | Error | Fix | Commit |
|---|---|---|---|---|---|
| 1 | High | S4 (Date columns) | `arguments imply differing number of rows: n, 0` | Filter `NULL` entries from `.sample_raw()` result before `as.data.frame()`; warn at `fit()` time | `92419a9` |
| 2 | High | S8 (Wine Quality + privacy report) | `Number of columns must be same!` in `FNN::knnx.dist` | `nndr()` now uses intersection of numeric column names from both frames | `92419a9` |
| 3 | Medium | S3 (diamonds, ordered factors) | Silent type change: `ordered factor` → `character` | Transformer records `is_factor`/`is_ordered`; `sample_categorical()` returns factor when input was a factor | `92419a9` |
| 4 | Medium | S10 (Wine, ml_efficacy) | `factor X has new levels Y` in `rpart::predict` | `ml_efficacy()` pre-sets factor levels to the union of training and real-data values via `.set_levels()` | `079081f` |

---

## Known Limitations (Not Bugs)

| Behavior | Affected scenarios | Notes |
|---|---|---|
| Missing values silently dropped | S2, S9, S10 | NAs excluded before copula fitting via `is.finite()` / `!is.na()`. Synthetic output always has zero NAs. The missingness mechanism is not modeled. Standard behavior for copula-based synthesizers; documented here for awareness. |
| `datetime` / `id` columns excluded from synthesis | S4 | No transformer implemented for these types. Columns are silently dropped with a warning. Workaround: convert dates to numeric (e.g. `as.numeric(date)`) before synthesis. |
| Rare categorical levels may not appear in synthetic output | S5, S10 | When synthetic sample size < number of unique levels, some rare levels will not appear. Expected behavior of empirical sampling. |
