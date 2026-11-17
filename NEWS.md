# phscs 0.3.0

## New features

* Added `get_ptscs()` for the Philippine Tourism Statistical Classification
  System (PTSCS). Choose the list with `type = "industries"` (default) or
  `type = "products"`. It has no `version`, `level`, `minimal` or `cols`
  argument, and returns `id`, `category_id`, `description` and `keywords`
  instead of `value` and `label`. For industries `keywords` is a list column
  (split by comma); for products it is the original text.

## Bug fixes

* `get_psced()`: each level is now built from its own source file, so broad
  and narrow field labels match the published per-level lists. For levels 4
  to 8, 5 broad field and 50 narrow field labels change; for example, broad
  field `"60"` is now "Social sciences, journalism and information" (was
  "Generic Programmes and Qualifications"). Codes are unchanged.

* `get_psccs()`: sub-class `"0103129"` is listed twice in the source; its
  label is now "Other acts of robbery with homicide, n.e.c.", matching the
  per-level source file (was "arson").

* `get_pcoicop(level = "subitem")` now returns the sub-item name as `label`
  (e.g. `"Wheat"`) instead of repeating the code.

* Labels that were blank in the source data now fall back to the first line
  of the description (PCOICOP 2020 groups `01.3`, `02.3`, `02.4`, `03.2`).

* `version` can now be given as a number, e.g. `get_psic(version = 2019)`.

* `get_psced()`: the `level` column (with `minimal = FALSE` or
  `cols = "level"`) now holds the education level code (`"0"` to `"8"`)
  instead of the hierarchy depth (1 to 4).

* Requesting a level that an edition does not have (e.g.
  `get_pcoicop(version = "2009", level = "subitem")`) now gives an error
  instead of an empty data frame.

* Documentation for `get_pcpc()`, `get_pcoicop()`, and `get_psccs()` now
  states the correct default level (`"all"`).

# phscs 0.2.0

## Breaking changes

* **`get_psgc()` has a completely new interface.** It is now re-exported directly
  from the [`psgc`](https://cran.r-project.org/package=psgc) package.
  The old parameters (`token`, `version`, `level`, `harmonize`, `minimal`, `cols`)
  are gone. Use the new `psgc` parameters instead:

  ```r
  # Before
  get_psgc(level = "regions")
  get_psgc(grepl("^10", area_code))   # dplyr filter

  # After
  get_psgc(geographic_level = "region")
  psgc_all <- get_psgc()
  psgc_all[grepl("^10", psgc_all$psgc_code), ]   # base R subsetting
  ```

  See `vignette("psgc", package = "psgc")` for full documentation.

* **`...` (dplyr filter) removed from all classification functions.**
  `get_psic()`, `get_psoc()`, `get_pcpc()`, `get_psced()`, and `get_pcoicop()`
  no longer accept unquoted filter expressions. Filter rows with standard R
  subsetting after the call.

* **`token` and `harmonize` parameters removed** from all classification
  functions. Data is now always sourced from the bundled local dataset — no
  API access or internet connection is needed.

## New features

* Added `get_psccs()` for the Philippine Standard Commodity Classification
  System (PSCCS 2018).

* All classification functions gain a `cols = "description"` option to include
  the full text description alongside `value` and `label`.

* PCOICOP now ships both the 2020 (default) and 2009 editions. Switch with
  `get_pcoicop(version = "2009")`.

## Other improvements

* Removed runtime dependencies on `dplyr`, `tidyr`, `purrr`, `stringr`, and
  `jsonlite`. The only Imports are now `cli` and `psgc`.

* Minimum R version lowered from 4.1.0 to 3.5.

* Data is pre-parsed at build time into a compressed `sysdata.rda`, making
  all functions substantially faster.

# phscs 0.1.0

* Initial CRAN submission.
