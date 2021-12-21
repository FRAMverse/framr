#' Extract escapement values from Coho FRAM database
#' @export
#'
#' @param db string, file path to database
#' @param runs numeric, RunID(s) as ID or ID:ID, default NULL for all runs
#' @param stocks numeric, StockID(s) as ID or ID:ID, default NULL for all stocks
#'
#' @return a tibble of escapement estimates; already only age 3 in TimeStep 5
#'
#' @examples
#' \dontrun{
#'
#' #fetch all runs for WA stocks
#' read_coho_escp("path/to/FRAM_Database.mdb", stocks = 1:164)

#' #fetch a single run for a single stock
#' read_coho_escp("path/to/FRAM_Database.mdb", stocks = 161)
#'
#' }
#'
read_coho_escp <- function (db, runs = NULL, stocks = NULL) {

  db_con <- DBI::dbConnect(
    drv = odbc::odbc(),
    .connection_string = paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=", db, ";"))

  #coho is already only age 3 in TimeStep 5
  #lazy, full table then reduce as specified
  escp <- dplyr::tbl(db_con, "Escapement") |>
    dplyr::select(RunID, StockID, escp = Escapement)
  if (!is.null(runs)) { escp <- dplyr::filter(escp, RunID %in% runs) }
  if (!is.null(stocks)) { escp <- dplyr::filter(escp, StockID %in% stocks) }

  #associate metainfo and pull
  escp <- escp |>
    dplyr::left_join(
      dplyr::tbl(db_con, "RunID") |>  dplyr::select(RunID, RunYear, RunName),
      by = "RunID") |>
    dplyr::left_join(
      dplyr::tbl(db_con, "Stock") |> dplyr::filter(Species == "COHO") |> dplyr::select(StockID, StockLongName),
      by = "StockID") |>
    dplyr::select(RunID, RunName, RunYear, StockID, StockLongName, escp) |>
    dplyr::collect() |>
    dplyr::arrange(RunYear, StockID)

  DBI::dbDisconnect(db_con)

  return(escp)
}
