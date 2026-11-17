# Philippine Tourism Statistical Classification System (PTSCS)

Returns a PTSCS list with columns `id`, `category_id`, `description`
(the category name) and `keywords`.

## Usage

``` r
get_ptscs(type = c("industries", "products"))
```

## Arguments

- type:

  Character. Which list to return: `"industries"` (default), the tourism
  characteristic industries, or `"products"`, the tourism characteristic
  products. The two lists reuse the same codes.

## Value

A data frame of PTSCS classifications. For industries, `keywords` is a
list column of the comma-separated keywords; for products, it is the
original “Includes ...” text, unchanged.

## References

<https://psa.gov.ph/classification/ptsc>

## Examples

``` r
ptscs <- get_ptscs()
ptscs_products <- get_ptscs(type = "products")
```
