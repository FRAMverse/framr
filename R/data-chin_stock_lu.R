#' Lookup of Chinook FRAM stocks.
#'
#' Containing BackwardsFRAM and 'forward' StockIDs.
#' The BackwardsFRAM table contains additional rows
#' of summed marked and unmarked per-stock; these are
#' NA for forward fields.
#'
#' @docType data
#'
#' @format data frame (tbl_df) with 116 rows and 4 cols:
#' \describe{
#'   \item{bkfram_id}{numeric BKFRAM ID}
#'   \item{StockID}{numeric forward FRAM stock ID}
#'   \item{StockName}{character forward FRAM stock name}
#'   \item{StockLongName}{character forward FRAM long name}
#' }
#'
#' @source R7.1 Chinook FRAM project database tables 'Stock'
#' and 'BackwardsFRAM', with derivation in chin_valid_2020.Rmd
#' from FRAMEscapeV2 sheets in ChinRSScalers and Valid2018 workbooks
#'
#' @examples
#' chin_stock_lu |> dplyr::filter(!is.na(StockID))
"chin_stock_lu"
