# Philippine Standard Occupational Classification (PSOC)

Philippine Standard Occupational Classification (PSOC)

## Usage

``` r
get_psoc(version = NULL, level = NULL, minimal = TRUE, cols = NULL)
```

## Arguments

- version:

  Character. Version of the PSOC dataset. Default is the latest
  available (`"2012"`).

- level:

  Character. Classification level: `"all"`, `"major"`, `"sub-major"`,
  `"minor"`, or `"unit"` (default).

- minimal:

  Logical. If `TRUE` (default), returns only `value` and `label`
  columns.

- cols:

  Optional character vector of additional columns to include
  (`"description"` is the only extra column available).

## Value

A data frame of PSOC classifications.

## References

<https://psa.gov.ph/classification/psoc>

## Examples

``` r
psoc <- get_psoc()
psoc_major <- get_psoc(level = "major")
```
