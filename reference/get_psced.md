# Philippine Standard Classification of Education (PSCED)

Philippine Standard Classification of Education (PSCED)

## Usage

``` r
get_psced(version = NULL, level = NULL, minimal = TRUE, cols = NULL)
```

## Arguments

- version:

  Character. Version of the PSCED dataset. Default is the latest
  available (`"2017"`).

- level:

  Character. Classification level: `"all"`, `"levels"`, `"broadfield"`,
  `"narrowfield"`, or `"detailedfield"` (default).

- minimal:

  Logical. If `TRUE` (default), returns only `value` and `label`
  columns.

- cols:

  Optional character vector of additional columns to include
  (`"description"` is the only extra column available).

## Value

A data frame of PSCED classifications.

## References

<https://psa.gov.ph/classification/psced>

## Examples

``` r
psced <- get_psced()
psced_levels <- get_psced(level = "levels")
```
