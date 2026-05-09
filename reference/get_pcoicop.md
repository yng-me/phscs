# Philippine Classification of Individual Consumption According to Purpose (PCOICOP)

Philippine Classification of Individual Consumption According to Purpose
(PCOICOP)

## Usage

``` r
get_pcoicop(version = NULL, level = NULL, minimal = TRUE, cols = NULL)
```

## Arguments

- version:

  Character. Version of the PCOICOP dataset. Default is the latest
  available (`"2020"`). Use `"2009"` for the 2009 edition.

- level:

  Character. Classification level: `"all"`, `"divisions"`, `"groups"`,
  `"class"`, `"sub-class"`, `"item"`, or `"subitem"` (default).

- minimal:

  Logical. If `TRUE` (default), returns only `value` and `label`
  columns.

- cols:

  Optional character vector of additional columns to include
  (`"description"` is the only extra column available).

## Value

A data frame of PCOICOP classifications.

## References

<https://psa.gov.ph/classification/pcoicop>

## Examples

``` r
pcoicop <- get_pcoicop()
pcoicop_divisions <- get_pcoicop(level = "divisions")
```
