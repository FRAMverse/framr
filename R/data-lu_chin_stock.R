#' Lookup of Chinook FRAM stocks.
#'
#' Containing BackwardsFRAM and 'forward' StockIDs.
#' The BackwardsFRAM table contains additional rows
#' of summed marked and unmarked per-stock; these are
#' NA for forward fields.
#'
#' @docType data
#'
#' @format data frame (tbl_df) with 116 rows and 11 cols:
#' \describe{
#'   \item{Species}{character Chinook or NA}
#'   \item{StockVersion}{integer 5 or NA}
#'   \item{StockID}{numeric forward FRAM stock ID}
#'   \item{ProductionRegionNumber}{numeric rarely used, value or NA}
#'   \item{ManagementUnitNumber}{numeric rarely used, value or NA}
#'   \item{StockName}{character forward FRAM stock name}
#'   \item{StockLongName}{character forward FRAM long name}
#'   \item{bkfram_id}{numeric BKFRAM ID}
#'   \item{bkfram_id_tot}{numeric BackwardsFRAM ID of associated total}
#'   \item{bk_run_def}{character definition of return elements used}
#'   \item{region}{character string of geographic domain}
#' }
#'
#' @source see vignette 'chinook_lookup_creation'; R7.1 Chinook FRAM project database tables 'Stock'
#' and 'BackwardsFRAM', with derivation in chin_valid_2020.Rmd
#' from FRAMEscapeV2 sheets in ChinRSScalers and Valid2018 workbooks
#'
#' @examples
#' lu_chin_stock |> dplyr::filter(!is.na(StockID))
"lu_chin_stock"
