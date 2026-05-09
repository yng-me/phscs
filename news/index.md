# Changelog

## phscs 0.2.0

### Breaking changes

- **[`get_psgc()`](https://yng-me.github.io/phscs/reference/get_psgc.md)
  has a completely new interface.** It is now re-exported directly from
  the [`psgc`](https://cran.r-project.org/package=psgc) package. The old
  parameters (`token`, `version`, `level`, `harmonize`, `minimal`,
  `cols`) are gone. Use the new `psgc` parameters instead:

  ``` r

  # Before
  get_psgc(level = "regions")
  get_psgc(grepl("^10", area_code))   # dplyr filter

  # After
  get_psgc(geographic_level = "region")
  psgc_all <- get_psgc()
  psgc_all[grepl("^10", psgc_all$psgc_code), ]   # base R subsetting
  ```

  See
  [`vignette("psgc", package = "psgc")`](https://yng-me.github.io/psgc/articles/psgc.html)
  for full documentation.

- **`...` (dplyr filter) removed from all classification functions.**
  [`get_psic()`](https://yng-me.github.io/phscs/reference/get_psic.md),
  [`get_psoc()`](https://yng-me.github.io/phscs/reference/get_psoc.md),
  [`get_pcpc()`](https://yng-me.github.io/phscs/reference/get_pcpc.md),
  [`get_psced()`](https://yng-me.github.io/phscs/reference/get_psced.md),
  and
  [`get_pcoicop()`](https://yng-me.github.io/phscs/reference/get_pcoicop.md)
  no longer accept unquoted filter expressions. Filter rows with
  standard R subsetting after the call.

- **`token` and `harmonize` parameters removed** from all classification
  functions. Data is now always sourced from the bundled local dataset —
  no API access or internet connection is needed.

### New features

- Added
  [`get_psccs()`](https://yng-me.github.io/phscs/reference/get_psccs.md)
  for the Philippine Standard Commodity Classification System (PSCCS
  2018).

- All classification functions gain a `cols = "description"` option to
  include the full text description alongside `value` and `label`.

- PCOICOP now ships both the 2020 (default) and 2009 editions. Switch
  with `get_pcoicop(version = "2009")`.

### Other improvements

- Removed runtime dependencies on `dplyr`, `tidyr`, `purrr`, `stringr`,
  and `jsonlite`. The only Imports are now `cli` and `psgc`.

- Minimum R version lowered from 4.1.0 to 3.5.

- Data is pre-parsed at build time into a compressed `sysdata.rda`,
  making all functions substantially faster.

## phscs 0.1.0

CRAN release: 2025-11-09

- Initial CRAN submission.
