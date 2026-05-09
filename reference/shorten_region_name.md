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
#> 3398  0200000000      Cagayan Valley           020000000              Reg
#> 5808  0300000000       Central Luzon           030000000              Reg
#> 9051  0400000000          CALABARZON           040000000              Reg
#> 13191 0500000000        Bicol Region           050000000              Reg
#> 16783 0600000000     Western Visayas           060000000              Reg
#> 20279 0700000000     Central Visayas           070000000              Reg
#> 22695 0800000000     Eastern Visayas           080000000              Reg
#> 27210 0900000000 Zamboanga Peninsula           090000000              Reg
#> 29621 1000000000   Northern Mindanao           100000000              Reg
#> 31742 1100000000        Davao Region           110000000              Reg
#> 32959 1200000000        SOCCSKSARGEN           120000000              Reg
#> 34110 1300000000                 NCR           130000000              Reg
#> 35857 1400000000                 CAR           140000000              Reg
#> 37119 1600000000              Caraga           160000000              Reg
#> 38510 1700000000     MIMAROPA Region           170000000              Reg
#> 40049 1800000000                 NIR                <NA>              Reg
#> 41469 1900000000               BARMM           150000000              Reg
#>       old_name city_class income_classification urban_rural island_region
#> 1         <NA>       <NA>                  <NA>        <NA>             L
#> 3398      <NA>       <NA>                  <NA>        <NA>             L
#> 5808      <NA>       <NA>                  <NA>        <NA>             L
#> 9051      <NA>       <NA>                  <NA>        <NA>             L
#> 13191     <NA>       <NA>                  <NA>        <NA>             L
#> 16783     <NA>       <NA>                  <NA>        <NA>             V
#> 20279     <NA>       <NA>                  <NA>        <NA>             V
#> 22695     <NA>       <NA>                  <NA>        <NA>             V
#> 27210     <NA>       <NA>                  <NA>        <NA>             M
#> 29621     <NA>       <NA>                  <NA>        <NA>             M
#> 31742     <NA>       <NA>                  <NA>        <NA>             M
#> 32959     <NA>       <NA>                  <NA>        <NA>             M
#> 34110     <NA>       <NA>                  <NA>        <NA>             L
#> 35857     <NA>       <NA>                  <NA>        <NA>             L
#> 37119     <NA>       <NA>                  <NA>        <NA>             M
#> 38510     <NA>       <NA>                  <NA>        <NA>             L
#> 40049     <NA>       <NA>                  <NA>        <NA>             V
#> 41469     <NA>       <NA>                  <NA>        <NA>             M
shorten_region_name(regions, which = "number")
#>        psgc_code area_name correspondence_code geographic_level old_name
#> 1     0100000000         I           010000000              Reg     <NA>
#> 3398  0200000000        II           020000000              Reg     <NA>
#> 5808  0300000000       III           030000000              Reg     <NA>
#> 9051  0400000000      IV-A           040000000              Reg     <NA>
#> 13191 0500000000         V           050000000              Reg     <NA>
#> 16783 0600000000        VI           060000000              Reg     <NA>
#> 20279 0700000000       VII           070000000              Reg     <NA>
#> 22695 0800000000      VIII           080000000              Reg     <NA>
#> 27210 0900000000        IX           090000000              Reg     <NA>
#> 29621 1000000000         X           100000000              Reg     <NA>
#> 31742 1100000000        XI           110000000              Reg     <NA>
#> 32959 1200000000       XII           120000000              Reg     <NA>
#> 34110 1300000000       NCR           130000000              Reg     <NA>
#> 35857 1400000000       CAR           140000000              Reg     <NA>
#> 37119 1600000000      XIII           160000000              Reg     <NA>
#> 38510 1700000000  MIMAROPA           170000000              Reg     <NA>
#> 40049 1800000000       NIR                <NA>              Reg     <NA>
#> 41469 1900000000     BARMM           150000000              Reg     <NA>
#>       city_class income_classification urban_rural island_region
#> 1           <NA>                  <NA>        <NA>             L
#> 3398        <NA>                  <NA>        <NA>             L
#> 5808        <NA>                  <NA>        <NA>             L
#> 9051        <NA>                  <NA>        <NA>             L
#> 13191       <NA>                  <NA>        <NA>             L
#> 16783       <NA>                  <NA>        <NA>             V
#> 20279       <NA>                  <NA>        <NA>             V
#> 22695       <NA>                  <NA>        <NA>             V
#> 27210       <NA>                  <NA>        <NA>             M
#> 29621       <NA>                  <NA>        <NA>             M
#> 31742       <NA>                  <NA>        <NA>             M
#> 32959       <NA>                  <NA>        <NA>             M
#> 34110       <NA>                  <NA>        <NA>             L
#> 35857       <NA>                  <NA>        <NA>             L
#> 37119       <NA>                  <NA>        <NA>             M
#> 38510       <NA>                  <NA>        <NA>             L
#> 40049       <NA>                  <NA>        <NA>             V
#> 41469       <NA>                  <NA>        <NA>             M
```
