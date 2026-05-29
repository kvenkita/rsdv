# rsdv: Synthetic Tabular Data Generation with Gaussian Copulas

rsdv generates synthetic tabular data from real datasets using Gaussian
copula models, with parametric marginal selection for numerical columns
and a cumulative-frequency embedding that brings categorical and boolean
columns into the same joint copula. It includes a metadata system,
declarative constraints, conditional sampling, and quality, validity,
and privacy reports modeled on those of the Python `SDMetrics` library.

## Details

The main entry points are:

- [`metadata()`](https://kvenkita.github.io/rsdv/reference/metadata.md)
  — describe column types and primary keys.

- [`gaussian_copula_synthesizer()`](https://kvenkita.github.io/rsdv/reference/gaussian_copula_synthesizer.md) +
  [`fit()`](https://generics.r-lib.org/reference/fit.html) +
  [`sample()`](https://kvenkita.github.io/rsdv/reference/sample.md) —
  fit a synthesizer and generate rows.

- [`sample_conditions()`](https://kvenkita.github.io/rsdv/reference/sample_conditions.md)
  — generate rows that hold given categorical or boolean values fixed.

- [`quality_report()`](https://kvenkita.github.io/rsdv/reference/quality_report.md),
  [`diagnostic_report()`](https://kvenkita.github.io/rsdv/reference/diagnostic_report.md),
  [`privacy_report()`](https://kvenkita.github.io/rsdv/reference/privacy_report.md)
  — evaluate the synthetic data.

## See also

Useful links:

- <https://kvenkita.github.io/rsdv/>

- <https://github.com/kvenkita/rsdv>

- Report bugs at <https://github.com/kvenkita/rsdv/issues>

## Author

**Maintainer**: Kailas Venkitasubramanian <kailasv@gmail.com>
