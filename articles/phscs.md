# Getting Started with phscs

The `phscs` package provides a single, consistent interface to seven
Philippine Statistical Authority (PSA) classification systems. All data
is **bundled with the package** — no internet connection or API token is
required.

| Function | Classification | Source |
|----|----|----|
| [`get_psgc()`](https://yng-me.github.io/phscs/reference/get_psgc.md) | Philippine Standard Geographic Code | PSA via `psgc` |
| [`get_psic()`](https://yng-me.github.io/phscs/reference/get_psic.md) | Philippine Standard Industrial Classification | PSA |
| [`get_psoc()`](https://yng-me.github.io/phscs/reference/get_psoc.md) | Philippine Standard Occupational Classification | PSA |
| [`get_psced()`](https://yng-me.github.io/phscs/reference/get_psced.md) | Philippine Standard Classification of Education | PSA |
| [`get_pcoicop()`](https://yng-me.github.io/phscs/reference/get_pcoicop.md) | Phil. Classification of Individual Consumption According to Purpose | PSA |
| [`get_pcpc()`](https://yng-me.github.io/phscs/reference/get_pcpc.md) | Philippine Central Product Classification | PSA |
| [`get_psccs()`](https://yng-me.github.io/phscs/reference/get_psccs.md) | Philippine Standard Commodity Classification System | PSA |

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

## Common interface

All classification functions share the same parameters:

| Parameter | Default | Description |
|----|----|----|
| `version` | latest | Which edition of the standard to use (e.g. `"2019"`, `"2009"`) |
| `level` | most detailed | Which level of the hierarchy to return |
| `minimal` | `TRUE` | Return only `value` and `label`; set `FALSE` for all columns |
| `cols` | `NULL` | Extra columns to include alongside `value` and `label` (e.g. `"description"`) |

Every classification has a `description` column available via
`cols = "description"`:

``` r

get_psic(level = "sections", cols = "description") |>
  head(5) |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label                                               | description |
|-------|-----------------------------------------------------|-------------|
| A     | Agriculture, forestry and fishing                   | NA          |
| B     | Mining and quarrying                                | NA          |
| C     | Manufacturing                                       | NA          |
| D     | Electricity, gas, steam and air conditioning supply | NA          |
| E     | Water supply; sewerage, waste management            | NA          |

## Philippine Standard Geographic Code (PSGC)

[`get_psgc()`](https://yng-me.github.io/phscs/reference/get_psgc.md) is
re-exported from the [`psgc`](https://cran.r-project.org/package=psgc)
package. For a full walkthrough — releases, crosswalks, population data
— see
[`vignette("psgc", package = "psgc")`](https://yng-me.github.io/psgc/articles/psgc.html).

Use `geographic_level` to filter to a specific tier:

``` r

psgc_regions <- get_psgc(geographic_level = "region")

psgc_regions |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| psgc_code | area_name | correspondence_code | geographic_level | old_name | city_class | income_classification | urban_rural | island_region |
|----|----|----|----|----|----|----|----|----|
| 0100000000 | Region I (Ilocos Region) | 010000000 | Reg | NA | NA | NA | NA | L |
| 0200000000 | Region II (Cagayan Valley) | 020000000 | Reg | NA | NA | NA | NA | L |
| 0300000000 | Region III (Central Luzon) | 030000000 | Reg | NA | NA | NA | NA | L |
| 0400000000 | Region IV-A (CALABARZON) | 040000000 | Reg | NA | NA | NA | NA | L |
| 0500000000 | Region V (Bicol Region) | 050000000 | Reg | NA | NA | NA | NA | L |
| 0600000000 | Region VI (Western Visayas) | 060000000 | Reg | NA | NA | NA | NA | V |
| 0700000000 | Region VII (Central Visayas) | 070000000 | Reg | NA | NA | NA | NA | V |
| 0800000000 | Region VIII (Eastern Visayas) | 080000000 | Reg | NA | NA | NA | NA | V |
| 0900000000 | Region IX (Zamboanga Peninsula) | 090000000 | Reg | NA | NA | NA | NA | M |
| 1000000000 | Region X (Northern Mindanao) | 100000000 | Reg | NA | NA | NA | NA | M |
| 1100000000 | Region XI (Davao Region) | 110000000 | Reg | NA | NA | NA | NA | M |
| 1200000000 | Region XII (SOCCSKSARGEN) | 120000000 | Reg | NA | NA | NA | NA | M |
| 1300000000 | National Capital Region (NCR) | 130000000 | Reg | NA | NA | NA | NA | L |
| 1400000000 | Cordillera Administrative Region (CAR) | 140000000 | Reg | NA | NA | NA | NA | L |
| 1600000000 | Region XIII (Caraga) | 160000000 | Reg | NA | NA | NA | NA | M |
| 1700000000 | MIMAROPA Region | 170000000 | Reg | NA | NA | NA | NA | L |
| 1800000000 | Negros Island Region (NIR) | NA | Reg | NA | NA | NA | NA | V |
| 1900000000 | Bangsamoro Autonomous Region In Muslim Mindanao (BARMM) | 150000000 | Reg | NA | NA | NA | NA | M |

Use
[`shorten_region_name()`](https://yng-me.github.io/phscs/reference/shorten_region_name.md)
to compact long region labels for plots or tables:

``` r

psgc_regions |>
  shorten_region_name(which = "label") |>
  head(5) |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| psgc_code | area_name | correspondence_code | geographic_level | old_name | city_class | income_classification | urban_rural | island_region |
|----|----|----|----|----|----|----|----|----|
| 0100000000 | Ilocos Region | 010000000 | Reg | NA | NA | NA | NA | L |
| 0200000000 | Cagayan Valley | 020000000 | Reg | NA | NA | NA | NA | L |
| 0300000000 | Central Luzon | 030000000 | Reg | NA | NA | NA | NA | L |
| 0400000000 | CALABARZON | 040000000 | Reg | NA | NA | NA | NA | L |
| 0500000000 | Bicol Region | 050000000 | Reg | NA | NA | NA | NA | L |

To filter rows by code, use standard R subsetting after the call:

``` r

# All areas whose PSGC code starts with "10" (Region X)
psgc_all <- get_psgc()
psgc_region_10 <- psgc_all[grepl("^10", psgc_all$psgc_code), ]
```

## Philippine Standard Industrial Classification (PSIC)

The [PSIC](https://psa.gov.ph/classification/psic) organises economic
activities into sections, divisions, groups, classes, and sub-classes.
The default returns the most detailed level.

``` r

get_psic() |>
  head(10) |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label |
|----|----|
| 01111 | Growing of leguminous crops such as: mongo, string beans (sitao), pigeon peas, gisantes, garbanzos, bountiful beans (habichuelas), peas (sitsaro) |
| 01112 | Growing of groundnuts |
| 01113 | Growing of oil seeds (except groundnuts) such as soya beans, sunflower and growing of other oil seeds, n.e.c. |
| 01114 | Growing of sorghum, wheat |
| 01119 | Growing of other cereals (except rice and corn), leguminous crops and oil seeds, n.e.c. |
| 01121 | Growing of paddy rice, lowland, irrigated |
| 01122 | Growing of paddy rice, lowland, rainfed |
| 01123 | Growing of paddy rice, upland/kaingin |
| 01130 | Growing of corn, except young corn (vegetable) |
| 01140 | Growing of sugarcane including muscovado sugar-making in the farm |

``` r

get_psic(level = "sections") |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label |
|----|----|
| A | Agriculture, forestry and fishing |
| B | Mining and quarrying |
| C | Manufacturing |
| D | Electricity, gas, steam and air conditioning supply |
| E | Water supply; sewerage, waste management |
| F | Construction |
| G | Wholesale and retail trade; repair of motor vehicles and motorcycles |
| H | Transportation and storage |
| I | Accommodation and food service activities |
| J | Information and communication |
| K | Financial and insurance activities |
| L | Real estate activities |
| M | Professional, scientific and technical activities |
| N | Administrative and support service activities |
| O | Public administration and defense; compulsory social security |
| P | Education |
| Q | Human health and social work activities |
| R | Arts, entertainment and recreation |
| S | Other service activities |
| T | Activities of households as employers; undifferentiated goods-and services-producing activities of households for own use |
| U | Activities of extra-territorial organizations and bodies |

## Philippine Standard Occupational Classification (PSOC)

The [PSOC](https://psa.gov.ph/classification/psoc) classifies
occupations into major, sub-major, minor, and unit groups. The default
returns unit groups.

``` r

get_psoc() |>
  head(10) |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label |
|----|----|
| 1111 | Legislators |
| 1112 | Senior government officials |
| 1113 | Traditional chiefs and heads of villages |
| 1114 | Senior officials of special-interest organizations |
| 1120 | Managing directors and chief executives |
| 1211 | Finance managers |
| 1212 | Human resource managers |
| 1213 | Policy and planning managers |
| 1219 | Business services and administration managers not elsewhere classified |
| 1221 | Sales and marketing managers |

``` r

get_psoc(level = "major") |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label                                              |
|-------|----------------------------------------------------|
| 1     | Managers                                           |
| 2     | Professionals                                      |
| 3     | Technicians and associate professionals            |
| 4     | Clerical support workers                           |
| 5     | Service and sales workers                          |
| 6     | Skilled agricultural, forestry and fishery workers |
| 7     | Craft and related trades workers                   |
| 8     | Plant and machine operators, and assemblers        |
| 9     | Elementary occupations                             |
| 0     | Armed forces occupations                           |

## Philippine Standard Classification of Education (PSCED)

The [PSCED](https://psa.gov.ph/classification/psced) classifies fields
of study into education levels, broad fields, narrow fields, and
detailed fields. The default returns detailed fields.

``` r

get_psced() |>
  head(10) |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label |
|----|----|
| 01000 | Early Childhood Educational Development Programs |
| 02000 | Pre-Primary Education Programs (Kindergarten) |
| 10001 | Primary Education Programs |
| 10002 | Inclusive and Special Needs Education Programs |
| 10003 | Continuing / Second-Chance Education Programs |
| 24001 | Lower Secondary Education Programs |
| 24002 | Inclusive and Special Needs Education Programs |
| 24003 | Continuing / Second-Chance Education Programs |
| 25000 | Lower Secondary Technical-Vocational Livelihood Programs (Junior High School) |
| 34001 | Academic Track |

``` r

get_psced(level = "levels") |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label                                  |
|-------|----------------------------------------|
| 0     | Early Childhood Education              |
| 1     | Primary Education                      |
| 2     | Lower Secondary Education              |
| 3     | Upper Secondary Education              |
| 4     | Post-secondary non-tertiary education  |
| 5     | Short-cycle tertiary education         |
| 6     | Bachelor level education or equivalent |
| 7     | Master level education or equivalent   |
| 8     | Doctoral level education or equivalent |

## Philippine Classification of Individual Consumption According to Purpose (PCOICOP)

The [PCOICOP](https://psa.gov.ph/classification/pcoicop) classifies
household expenditures. Two editions are available: `"2020"` (default,
3,472 items) and `"2009"` (1,722 items).

``` r

get_pcoicop() |>
  head(10) |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label                                                              |
|-------|--------------------------------------------------------------------|
| 01    | Food and non-alcoholic beverages                                   |
| 02    | Alcoholic beverages, tobacco and narcotics                         |
| 03    | Clothing and footwear                                              |
| 04    | Housing, water, electricity, gas and other fuels                   |
| 05    | Furnishings, household equipment and routine household maintenance |
| 06    | Health                                                             |
| 07    | Transport                                                          |
| 08    | Information and communication                                      |
| 09    | Recreation, sport and culture                                      |
| 10    | Education services                                                 |

``` r

get_pcoicop(level = "divisions") |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label |
|----|----|
| 01 | Food and non-alcoholic beverages |
| 02 | Alcoholic beverages, tobacco and narcotics |
| 03 | Clothing and footwear |
| 04 | Housing, water, electricity, gas and other fuels |
| 05 | Furnishings, household equipment and routine household maintenance |
| 06 | Health |
| 07 | Transport |
| 08 | Information and communication |
| 09 | Recreation, sport and culture |
| 10 | Education services |
| 11 | Restaurants and accommodation services |
| 12 | Insurance and financial services |
| 13 | Personal care, social protection and miscellaneous goods and services |
| 14 | Individual consumption expenditure of non-profit institutions serving households |
| 15 | Individual consumption expenditure of general government |

Switch to the 2009 edition with `version = "2009"`:

``` r

get_pcoicop(version = "2009", level = "divisions") |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label |
|----|----|
| 1 | Food and non- alcoholic beverages |
| 2 | Alcoholic beverages, tobacco and narcotics |
| 3 | Clothing and footwear |
| 4 | Housing, water, electricity, gas and other fuels |
| 5 | Furnishings, household equipment and routine household maintenance |
| 6 | Health |
| 7 | Transport |
| 8 | Communication |
| 9 | Recreation and culture |
| 10 | Education |
| 11 | Restaurants and hotels |
| 12 | Miscellaneous goods and services |
| 13 | Individual consumption expenditures of non-profit institutions serving households |
| 14 | Individual consumption expenditure of general government |

## Philippine Central Product Classification (PCPC)

The [PCPC](https://psa.gov.ph/classification/pcpc) classifies goods and
services. The default returns all 8,734 items across six levels.

``` r

get_pcpc() |>
  head(10) |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label |
|----|----|
| 0 | Agriculture, forestry and fishery |
| 1 | Ores and minerals; electricity, gas and water |
| 2 | Food products, beverages and tobacco, textiles, apparel and leather products |
| 3 | Other transportable goods, except metal products, machinery and equipment |
| 4 | Metal products, machinery and equipment |
| 5 | Intangible assets; land; constructions; construction services |
| 6 | Distributive trade services; lodging; food and beverage serving services; transport services; and utilities distribution services |
| 7 | Financial and related services; real estate services; and rental and leasing services |
| 8 | Business and production services |
| 9 | Community, social and personal services |

``` r

get_pcpc(level = "sections") |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label |
|----|----|
| 0 | Agriculture, forestry and fishery |
| 1 | Ores and minerals; electricity, gas and water |
| 2 | Food products, beverages and tobacco, textiles, apparel and leather products |
| 3 | Other transportable goods, except metal products, machinery and equipment |
| 4 | Metal products, machinery and equipment |
| 5 | Intangible assets; land; constructions; construction services |
| 6 | Distributive trade services; lodging; food and beverage serving services; transport services; and utilities distribution services |
| 7 | Financial and related services; real estate services; and rental and leasing services |
| 8 | Business and production services |
| 9 | Community, social and personal services |

## Philippine Standard Commodity Classification System (PSCCS)

The [PSCCS](https://psa.gov.ph/classification/psccs) classifies
commodities into sections, divisions, groups, classes, and sub-classes.
The default returns all 1,870 items.

``` r

get_psccs() |>
  head(10) |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label                                                               |
|-------|---------------------------------------------------------------------|
| 01    | Acts leading to death or intending to cause death                   |
| 02    | Acts leading to harm or intending to cause harm to the person       |
| 03    | Injurious acts of a sexual nature                                   |
| 04    | Acts against property involving violence or threat against a person |
| 05    | Acts against property only                                          |
| 06    | Acts involving controlled drugs or other psychoactive substances    |
| 07    | Acts involving fraud, deception or corruption                       |
| 08    | Acts against public order, authority and provisions of the State    |
| 09    | Acts against public safety and state security                       |
| 10    | Acts against the natural environment                                |

``` r

get_psccs(level = "section") |>
  gt::gt() |>
  gt::tab_options(table.align = "left")
```

| value | label                                                               |
|-------|---------------------------------------------------------------------|
| 01    | Acts leading to death or intending to cause death                   |
| 02    | Acts leading to harm or intending to cause harm to the person       |
| 03    | Injurious acts of a sexual nature                                   |
| 04    | Acts against property involving violence or threat against a person |
| 05    | Acts against property only                                          |
| 06    | Acts involving controlled drugs or other psychoactive substances    |
| 07    | Acts involving fraud, deception or corruption                       |
| 08    | Acts against public order, authority and provisions of the State    |
| 09    | Acts against public safety and state security                       |
| 10    | Acts against the natural environment                                |
| 11    | Other criminal acts not elsewhere classified                        |
