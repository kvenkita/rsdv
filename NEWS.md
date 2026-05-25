# rsdv 0.1.0

* Initial release.
* Implements `gaussian_copula_synthesizer` for synthetic tabular data generation.
* Adds quality metrics: `ks_similarity`, `tvd_similarity`, `correlation_similarity`, `ml_efficacy`.
* Adds privacy metrics: `nndr`, `attribute_disclosure_risk`.
* Adds `quality_report` and `privacy_report` with `print` and `autoplot` S3 methods.
* Includes `adult_income` example dataset.
* Supports metadata column types (numerical, categorical, boolean) and constraint system.
