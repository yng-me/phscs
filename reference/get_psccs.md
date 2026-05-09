# Philippine Standard Commodity Classification System (PSCCS)

Philippine Standard Commodity Classification System (PSCCS)

## Usage

``` r
get_psccs(version = NULL, level = NULL, minimal = TRUE, cols = NULL)
```

## Arguments

- version:

  Character. Version of the PSCCS dataset. Default is the latest
  available (`"2018"`).

- level:

  Character. Classification level: `"all"`, `"section"`, `"divisions"`,
  `"groups"`, `"classes"`, or `"sub-classes"` (default).

- minimal:

  Logical. If `TRUE` (default), returns only `value` and `label`
  columns.

- cols:

  Optional character vector of additional columns to include
  (`"description"` is the only extra column available).

## Value

A data frame of PSCCS classifications.

## References

<https://psa.gov.ph/classification/psccs>

## Examples

``` r
psccs <- get_psccs()
psccs_sections <- get_psccs(level = "section")
```
