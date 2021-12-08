
<!-- README.md is generated from README.Rmd. Please edit that file -->

# framr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/framr)](https://CRAN.R-project.org/package=framr)
<!-- badges: end -->

The goal of `framr` is to make it easier and faster to perform common
tasks associated with the [FRAM
model](https://framverse.github.io/fram_doc/).

The package currently consists of high-level convenience functions that
typically require both updated R/RStudio installations and various
FRAM-related files (e.g., Access project databases, Excel files).

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("FRAMverse/framr")
```

Several functions also require the Windows/Office low-level tools in the
`RDCOMClient` package, which (as of 2021-07-19) can be installed with:

``` r
#worked with 4.1.0 to get to ver 0.95-0
devtools::install_github("BSchamberger/RDCOMClient")

## compiled but fatal errors when running 4.1.0
#devtools::install_github("omegahat/RDCOMClient")

##no longer working?
#install.packages("RDCOMClient", repos = "http://www.omegahat.net/R")
```

## Examples

The function `aeq_mort` quickly generates AEQ’d mortality values for
Chinook.

``` r
library(framr)

m_hcff <- aeq_mort(
  db = "path/to/ChinookFRAM.mdb",
  runs = 201, #defaults to all RunIDs
  stocks = 31:32, #defaults to all StockIDS 
  drop_t1 = T, #defaults to TRUE for "fishing year" t2:t4
  sum_ages = T #defaults to FALSE for disaggregated returned object
  )
```

The functions `ayock_split` and `sps` perform Chinook post-processing
tasks, altering TAMM file values.

The functions `rep_ocean_opt` and `update_2s` perform Chinook database
manipulation tasks.
