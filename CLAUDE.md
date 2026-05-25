# Package: rsdv

## What this is

R port of SDV's GaussianCopula synthesizer plus quality/privacy metrics.
No torch dependency — CTGAN/TVAE live in companion package `rsdv.torch`.

## Stack

- R 4.3+, S3 classes throughout
- `copula` for Gaussian copula fitting/sampling
- `generics` for fit() generic (tidymodels-compatible)
- `jsonlite` for metadata JSON serialization
- `ggplot2` for autoplot methods
- `FNN` for nearest-neighbor privacy metrics
- `rpart` for ML efficacy metric
- `MASS` for mvrnorm (multivariate normal sampling in GaussianCopula)

## Commands

- `"/c/Program Files/R/R-4.4.3/bin/Rscript.exe" -e "devtools::load_all()"` — load package
- `"/c/Program Files/R/R-4.4.3/bin/Rscript.exe" -e "devtools::test()"` — run all tests
- `"/c/Program Files/R/R-4.4.3/bin/Rscript.exe" -e "devtools::check()"` — full R CMD check

## Conventions

- snake_case everywhere
- One exported function family per file in R/
- All exported functions need @examples and a corresponding test
- Never use Python/reticulate from package code

## Out of scope for v0.1

- CTGAN, TVAE (→ rsdv.torch)
- Multi-table HMA synthesizer
- Time-series PAR synthesizer
- DP-CTGAN
- Shiny GUI
