# Shorten region name

This function shortens the region names in a PSGC data frame.

## Usage

``` r
shorten_region_name(data, which = c("label", "number"), col = "area_name")
```

## Arguments

- data:

  A data frame containing PSGC data.

- which:

  Character. Specifies whether to shorten the region name by label or
  number. Options are `"label"` or `"number"`.

- col:

  Character. The name of the column containing the area names. Default
  is `"area_name"`.

## Value

A data frame with the region names shortened based on the specified
`which` argument.

## Examples

``` r
regions <- get_psgc(geographic_level = "region")
shorten_region_name(regions)
#>        psgc_code           area_name correspondence_code geographic_level
#> 1     0100000000       Ilocos Region           010000000              Reg
#> 2     1000000000   Northern Mindanao           100000000              Reg
#> 5519  1100000000        Davao Region           110000000              Reg
#> 6736  1200000000        SOCCSKSARGEN           120000000              Reg
#> 7887  1300000000                 NCR           130000000              Reg
#> 9634  1400000000                 CAR           140000000              Reg
#> 10896 1600000000              Caraga           160000000              Reg
#> 12287 1700000000     MIMAROPA Region           170000000              Reg
#> 13826 1800000000                 NIR           000000000              Reg
#> 15246 1900000000               BARMM           150000000              Reg
#> 17546 0200000000      Cagayan Valley           020000000              Reg
#> 19956 0300000000       Central Luzon           030000000              Reg
#> 23199 0400000000          CALABARZON           040000000              Reg
#> 27339 0500000000        Bicol Region           050000000              Reg
#> 30931 0600000000     Western Visayas           060000000              Reg
#> 34427 0700000000     Central Visayas           070000000              Reg
#> 36843 0800000000     Eastern Visayas           080000000              Reg
#> 41358 0900000000 Zamboanga Peninsula           090000000              Reg
#>       old_name city_class income_classification urban_rural island_region
#> 1         <NA>       <NA>                  <NA>        <NA>             L
#> 2         <NA>       <NA>                  <NA>        <NA>             M
#> 5519      <NA>       <NA>                  <NA>        <NA>             M
#> 6736      <NA>       <NA>                  <NA>        <NA>             M
#> 7887      <NA>       <NA>                  <NA>        <NA>             L
#> 9634      <NA>       <NA>                  <NA>        <NA>             L
#> 10896     <NA>       <NA>                  <NA>        <NA>             M
#> 12287     <NA>       <NA>                  <NA>        <NA>             L
#> 13826     <NA>       <NA>                  <NA>        <NA>             V
#> 15246     <NA>       <NA>                  <NA>        <NA>             M
#> 17546     <NA>       <NA>                  <NA>        <NA>             L
#> 19956     <NA>       <NA>                  <NA>        <NA>             L
#> 23199     <NA>       <NA>                  <NA>        <NA>             L
#> 27339     <NA>       <NA>                  <NA>        <NA>             L
#> 30931     <NA>       <NA>                  <NA>        <NA>             V
#> 34427     <NA>       <NA>                  <NA>        <NA>             V
#> 36843     <NA>       <NA>                  <NA>        <NA>             V
#> 41358     <NA>       <NA>                  <NA>        <NA>             M
shorten_region_name(regions, which = "number")
#>        psgc_code area_name correspondence_code geographic_level old_name
#> 1     0100000000         I           010000000              Reg     <NA>
#> 2     1000000000         X           100000000              Reg     <NA>
#> 5519  1100000000        XI           110000000              Reg     <NA>
#> 6736  1200000000       XII           120000000              Reg     <NA>
#> 7887  1300000000       NCR           130000000              Reg     <NA>
#> 9634  1400000000       CAR           140000000              Reg     <NA>
#> 10896 1600000000      XIII           160000000              Reg     <NA>
#> 12287 1700000000  MIMAROPA           170000000              Reg     <NA>
#> 13826 1800000000       NIR           000000000              Reg     <NA>
#> 15246 1900000000     BARMM           150000000              Reg     <NA>
#> 17546 0200000000        II           020000000              Reg     <NA>
#> 19956 0300000000       III           030000000              Reg     <NA>
#> 23199 0400000000      IV-A           040000000              Reg     <NA>
#> 27339 0500000000         V           050000000              Reg     <NA>
#> 30931 0600000000        VI           060000000              Reg     <NA>
#> 34427 0700000000       VII           070000000              Reg     <NA>
#> 36843 0800000000      VIII           080000000              Reg     <NA>
#> 41358 0900000000        IX           090000000              Reg     <NA>
#>       city_class income_classification urban_rural island_region
#> 1           <NA>                  <NA>        <NA>             L
#> 2           <NA>                  <NA>        <NA>             M
#> 5519        <NA>                  <NA>        <NA>             M
#> 6736        <NA>                  <NA>        <NA>             M
#> 7887        <NA>                  <NA>        <NA>             L
#> 9634        <NA>                  <NA>        <NA>             L
#> 10896       <NA>                  <NA>        <NA>             M
#> 12287       <NA>                  <NA>        <NA>             L
#> 13826       <NA>                  <NA>        <NA>             V
#> 15246       <NA>                  <NA>        <NA>             M
#> 17546       <NA>                  <NA>        <NA>             L
#> 19956       <NA>                  <NA>        <NA>             L
#> 23199       <NA>                  <NA>        <NA>             L
#> 27339       <NA>                  <NA>        <NA>             L
#> 30931       <NA>                  <NA>        <NA>             V
#> 34427       <NA>                  <NA>        <NA>             V
#> 36843       <NA>                  <NA>        <NA>             V
#> 41358       <NA>                  <NA>        <NA>             M
```
