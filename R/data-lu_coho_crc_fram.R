#' Lookup of Coho FRAM sport fisheries
#'
#' Maps WDFW Catch Record Card catch areas to Coho FRAM
#' FisheryIDs.
#'
#' @docType data
#'
#' @format data frame (tbl_df) with 134 rows and 3 cols:
#' \describe{
#'   \item{area_code}{min 2 character string of WDFW CRC catch area code}
#'   \item{FisheryID}{integer associated FRAM FisheryID}
#'   \item{FisheryID_alt}{integer 'true' fishery for a few instances of small rivers that are aggregated into larger}
#' }
#'
#' @source unexported lu_coho.xlsx
#' lu_coho_crc_fram <- readxl::read_excel("xlsx/lu_coho.xlsx", sheet = "CRC_FRAM") |>
#'  dplyr::mutate(dplyr::across(dplyr::starts_with('FisheryID'), as.integer))
#' save(lu_coho_crc_fram, file = 'data/lu_coho_crc_fram.rda')
#'
"lu_coho_crc_fram"
