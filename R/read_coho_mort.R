#' Extract mortality values from Coho FRAM database
#' @export
#'
#' @param db string, file path to database
#' @param runs numeric, RunID(s) as ID or ID:ID, default NULL for all runs
#' @param stocks numeric, StockID(s) as ID or ID:ID, default NULL for all stocks
#' @param fisheries numeric, FisheryID(s) as ID or ID:ID, default NULL for all fisheries
#'
#' @return a tibble of mortality by run-stock-fishery-timestep
#'
#' @examples
#' \dontrun{
#'
#' #fetch all runs for WA stocks across all fisheries
#' read_coho_mort("path/to/FRAM_Database.mdb", stocks = 1:164)

#' #fetch a single stock in a single fishery across runs/years
#' read_coho_mort("path/to/FRAM_Database.mdb", stocks = 161, fisheries = 45)
#'
#' }
#'
read_coho_mort <- function (db, runs = NULL, stocks = NULL, fisheries = NULL) {

  db_con <- DBI::dbConnect(
    drv = odbc::odbc(),
    .connection_string = paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=", db, ";"))

  #lazy, full table then reduce as specified
  m <- dplyr::tbl(db_con, "Mortality") |> dplyr::select(-PrimaryKey)
  if (!is.null(runs)) { m <- dplyr::filter(m, RunID %in% runs) }
  if (!is.null(stocks)) { m <- dplyr::filter(m, StockID %in% stocks) }
  if (!is.null(fisheries)) { m <- dplyr::filter(m, FisheryID %in% fisheries) }

  #associate metainfo and pull
  m <- m |>
    dplyr::left_join(
      dplyr::tbl(db_con, "RunID") |>  dplyr::select(RunID, RunYear, RunName),
      by = "RunID") |>
    dplyr::left_join(
      dplyr::tbl(db_con, "Stock") |> dplyr::filter(Species == "COHO") |> dplyr::select(StockID, StockLongName),
      by = "StockID") |>
    dplyr::left_join(
      dplyr::tbl(db_con, "Fishery") |> dplyr::filter(Species == "COHO") |> dplyr::select(FisheryID, FisheryName),
      by = "FisheryID") |>
    dplyr::select(RunID, RunName, RunYear,
                  StockID, StockLongName, Age,
                  FisheryID, FisheryName, TimeStep,
                  LandedCatch:MSFEncounter) |>
    dplyr::collect() |>
    dplyr::mutate(
      mort = LandedCatch + NonRetention + Shaker + DropOff + MSFLandedCatch + MSFNonRetention + MSFShaker + MSFDropOff
    ) |>
    dplyr::arrange(RunYear, FisheryID, TimeStep, StockID)

  DBI::dbDisconnect(db_con)

  return(m)
}
