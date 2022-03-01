#' Extract JA3 starting cohort values from Coho FRAM database
#' @export
#'
#' @param db string, file path to database
#' @param runs numeric, RunID(s) as ID or ID:ID, default NULL for all runs
#' @param stocks numeric, StockID(s) as ID or ID:ID, default NULL for all stocks
#'
#' @return a tibble of JA3 starting cohort values; already only age 3 in TimeStep 1;
#' these represent forecasts for a preseason database, backwards-FRAM constructed
#' abundances for post-season
#'
#' @examples
#' \dontrun{
#'
#' #fetch all runs for WA stocks
#' read_coho_cohort("path/to/FRAM_Database.mdb", stocks = 1:164)

#' #fetch a single run for a single stock
#' read_coho_cohort("path/to/FRAM_Database.mdb", stocks = 161)
#'
#' }
#'
read_coho_cohort <- function(db, runs = NULL, stocks = NULL) {
  db_con <- DBI::dbConnect(drv = odbc::odbc(), .connection_string = paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=", db, ";"))

  cohort <- dplyr::tbl(db_con, "Cohort") |>
    dplyr::filter(TimeStep == 1) |>
    dplyr::select(RunID, StockID, cohort = StartCohort)
  if (!is.null(runs)) { cohort <- dplyr::filter(cohort, RunID %in% runs) }
  if (!is.null(stocks)) { cohort <- dplyr::filter(cohort, StockID %in% stocks) }

  #associate metainfo and pull
  cohort <- cohort |>
    dplyr::left_join(
      dplyr::tbl(db_con, "RunID") |>  dplyr::select(RunID, RunYear, RunName),
      by = "RunID") |>
    dplyr::left_join(
      dplyr::tbl(db_con, "Stock") |> dplyr::filter(Species == "COHO") |> dplyr::select(StockID, StockLongName),
      by = "StockID") |>
    dplyr::select(RunID, RunName, RunYear, StockID, StockLongName, cohort) |>
    dplyr::collect() |>
    dplyr::arrange(RunYear, StockID)

  DBI::dbDisconnect(db_con)

  return(cohort)
}
