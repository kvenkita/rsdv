## R CMD CHECK results

0 errors | 0 warnings | 1 note

(The "unable to verify current time" note appears on machines without
internet access during check; it is not present on CRAN servers.)

## Notes on sample() generic

The package exports a `sample()` S3 generic. When `x` is an
`rsdv_synthesizer` object, it dispatches to the synthesizer-specific
method. For all other inputs it falls back to `base::sample()`,
preserving backward compatibility for existing code. The masking is
intentional: `sample(synthesizer, n = 500)` is the primary user API,
mirroring the Python SDV library's interface.

## Test environments

* Windows 11, R 4.4.3 (local)
* R-hub: ubuntu-latest (R-release)
* R-hub: windows-latest (R-release)
* win-builder: R-devel

## Downstream dependencies

None — this is a new package.
