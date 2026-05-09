# Philippine Standard Geographic Code (PSGC)

Re-exported from the `psgc` package. See
[`get_psgc`](https://yng-me.github.io/psgc/reference/get_psgc.html) for
full documentation.

## Usage

``` r
get_psgc(
  release = latest_release(),
  geographic_level = NULL,
  include_population_data = FALSE
)
```

## Arguments

- release:

  A release name from \[list_releases()\]. Defaults to
  \[latest_release()\].

- geographic_level:

  A character vector of geographic levels to filter by. Accepts
  canonical codes (\`"Reg"\`, \`"Prov"\`, \`"City"\`, \`"Mun"\`,
  \`"SubMun"\`, \`"Bgy"\`) as well as common aliases such as
  \`"Region"\`, \`"Province"\`, \`"Municipality"\`, \`"Barangay"\`,
  \`"Sub-Municipality"\`, etc. Use \`"city_mun"\` (or aliases like
  \`"City-Municipality"\`) to include both cities and municipalities.
  \`NULL\` (default) returns all levels.

- include_population_data:

  Logical. If \`TRUE\`, census population figures are joined onto the
  result, adding \`population\` (integer) and \`year\` columns. Each
  geographic unit produces one row per available census year. Defaults
  to \`FALSE\`.

## Value

A data frame of PSGC geographic data.

## References

<https://psa.gov.ph/classification/psgc>

## Examples

``` r
psgc <- get_psgc()
psgc_regions <- get_psgc(geographic_level = "region")
```
