
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The `phscs` Package

<!-- badges: start -->

[![R-CMD-check](https://github.com/yng-me/phscs/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yng-me/phscs/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of `phscs` is to provide a unified interface to access and
manipulate various Philippine statistical classifications, such as the
Philippine Standard Geographic Code (PSGC), Philippine Standard
Industrial Classification (PSIC), Philippine Standard Occupational
Classification (PSOC), and others.

It allows users to retrieve, filter, and harmonize classification data
from the [Philippine Statistics
Authority](https://psa.gov.ph/classification) (PSA)’s open-access data
and other sources, making it easier to work with Philippine statistical
data in R.

## Installation

You can install the development version of `phscs` from GitHub using the
`pak` package:

``` r
# install.packages("pak")
pak::pak("yng-me/phscs")
```

## Usage

``` r
library(phscs)

# Retrieve Philippine Standard Geographic Code (PSGC) data
psgc_data <- get_psgc()
head(psgc_data)

# Retrieve Philippine Standard Industrial Classification (PSIC) data
psic_data <- get_psic()
head(psic_data)

# Retrieve Philippine Standard Occupational Classification (PSOC) data
psoc_data <- get_psoc()
head(psoc_data)
```
