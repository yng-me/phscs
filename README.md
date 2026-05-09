
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The `phscs` Package

<!-- badges: start -->

[![R-CMD-check](https://github.com/yng-me/phscs/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yng-me/phscs/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/phscs)](https://CRAN.R-project.org/package=phscs)
<!-- badges: end -->

`phscs` provides a single, consistent interface to seven [Philippine
Statistics Authority](https://psa.gov.ph/classification) (PSA)
classification systems. All data is **bundled with the package** — no
internet connection or API token required.

| Function | Classification |
|----|----|
| `get_psgc()` | Philippine Standard Geographic Code |
| `get_psic()` | Philippine Standard Industrial Classification |
| `get_psoc()` | Philippine Standard Occupational Classification |
| `get_psced()` | Philippine Standard Classification of Education |
| `get_pcoicop()` | Phil. Classification of Individual Consumption According to Purpose |
| `get_pcpc()` | Philippine Central Product Classification |
| `get_psccs()` | Philippine Standard Commodity Classification System |

## Installation

Install from CRAN:

``` r
install.packages("phscs")
```

Or install the development version from GitHub:

``` r
# install.packages("pak")
pak::pak("yng-me/phscs")
```

## Usage

``` r
library(phscs)

# Geographic data — re-exported from the psgc package
get_psgc(geographic_level = "region") |> head(3)
#>       psgc_code                  area_name correspondence_code geographic_level
#> 1    0100000000   Region I (Ilocos Region)           010000000              Reg
#> 3398 0200000000 Region II (Cagayan Valley)           020000000              Reg
#> 5808 0300000000 Region III (Central Luzon)           030000000              Reg
#>      old_name city_class income_classification urban_rural island_region
#> 1        <NA>       <NA>                  <NA>        <NA>             L
#> 3398     <NA>       <NA>                  <NA>        <NA>             L
#> 5808     <NA>       <NA>                  <NA>        <NA>             L

# Industrial classification (default: sub-classes)
get_psic() |> head(3)
#>   value
#> 1 01111
#> 2 01112
#> 3 01113
#>                                                                                                                                               label
#> 1 Growing of leguminous crops such as: mongo, string beans (sitao), pigeon peas, gisantes, garbanzos, bountiful beans (habichuelas), peas (sitsaro)
#> 2                                                                                                                             Growing of groundnuts
#> 3                                     Growing of oil seeds (except groundnuts) such as soya beans, sunflower and growing of other oil seeds, n.e.c.

# Occupational classification (default: unit groups)
get_psoc() |> head(3)
#>   value                                    label
#> 1  1111                              Legislators
#> 2  1112              Senior government officials
#> 3  1113 Traditional chiefs and heads of villages
```

All classification functions share the same interface:

``` r
# Choose a level of detail
get_psic(level = "sections")
get_psoc(level = "major")
get_pcoicop(level = "divisions")

# Include the full text description
get_psic(level = "sections", cols = "description")

# Switch to an older edition (where available)
get_pcoicop(version = "2009")
```

For a full walkthrough of every classification and more examples, see:

``` r
vignette("phscs")
```
