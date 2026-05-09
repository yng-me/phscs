# Philippine Central Product Classification (PCPC)

Philippine Central Product Classification (PCPC)

## Usage

``` r
get_pcpc(version = NULL, level = NULL, minimal = TRUE, cols = NULL)
```

## Arguments

- version:

  Character. Version of the PCPC dataset. Default is the latest
  available (`"2002"`).

- level:

  Character. Classification level: `"all"`, `"sections"`, `"divisions"`,
  `"groups"`, `"classes"`, `"sub-classes"`, or `"item"` (default).

- minimal:

  Logical. If `TRUE` (default), returns only `value` and `label`
  columns.

- cols:

  Optional character vector of additional columns to include
  (`"description"` is the only extra column available).

## Value

A data frame of PCPC classifications.

## References

<https://psa.gov.ph/classification/pcpc>

## Examples

``` r
pcpc <- get_pcpc()
pcpc_sections <- get_pcpc(level = "sections")
```
