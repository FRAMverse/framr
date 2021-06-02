
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
`RDCOMClient` package, which (as of 2021-06-02) can be installed with:

``` r
#install.packages("RDCOMClient", repos = "http://www.omegahat.net/R")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(framr)
## basic example code
```
