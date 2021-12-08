#' Lookup of Chinook FRAM (marine) fisheries
#'
#' Contains FisheryIDs and names from a current Chinook project database
#' and appends several fields of metadata and catch database identifiers.
#' Note that additional TAMM fisheries are required for a complete
#' depiction of impacts (i.e., including terminal and freshwater mortality).
#' Various fields are NA for fisheries for which they do not apply.
#'
#' @docType data
#'
#' @format data frame (tbl_df) with 73 rows and 11 cols:
#' \describe{
#'   \item{Species}{character Chinook}
#'   \item{VersionNumber}{integer 1}
#'   \item{FisheryID}{integer 1:73}
#'   \item{FisheryName}{character short name}
#'   \item{FisheryTitle}{character long name}
#'   \item{catch_soure}{character designating primary data source}
#'   \item{region}{character string of geographic domain}
#'   \item{areacode}{character string of CRC identifiers}
#'   \item{CatchAreaCode}{character string of WDFW FishTix identifiers}
#'   \item{FisherTypeDescription}{character string FishTix Tr/NT levels}
#'   \item{gear}{character string of net or line}
#' }
#'
#' @source see vignette 'chinook_lookup_creation'
#'
#' @examples
#' lu_chin_fishery |>
#' dplyr::filter(catch_source == "FishTicket/TOCAS") |>
#' dplyr::select(catch_source, FisheryID, FisheryName, CatchAreaCode, FisherTypeDescription, gear) |>
#' tidyr::separate_rows(CatchAreaCode)
"lu_chin_fishery"
