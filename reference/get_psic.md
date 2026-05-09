# Philippine Standard Industrial Classification (PSIC)

Philippine Standard Industrial Classification (PSIC)

## Usage

``` r
get_psic(version = NULL, level = NULL, minimal = TRUE, cols = NULL)
```

## Arguments

- version:

  Character. Version of the PSIC dataset. Default is the latest
  available (`"2019"`).

- level:

  Character. Classification level: `"all"`, `"sections"`, `"divisions"`,
  `"groups"`, `"classes"`, or `"sub-classes"` (default).

- minimal:

  Logical. If `TRUE` (default), returns only `value` and `label`
  columns.

- cols:

  Optional character vector of additional columns to include
  (`"description"` is the only extra column available).

## Value

A data frame of PSIC classifications.

## References

<https://psa.gov.ph/classification/psic>

## Examples

``` r
psic <- get_psic()
psic_sections <- get_psic(level = "sections")
```
