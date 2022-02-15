#' Extract FisheryScaler values from Coho FRAM database
#' @export
#'
#' @param db string, file path to database
#' @param runs numeric, RunID(s) as ID or ID:ID, default NULL for all runs
#' @param fisheries numeric, FisheryID(s) as ID or ID:ID, default NULL for all fisheries
#'
#' @return a tibble of non-selective and mark-selective input
#' fishery catch estimates, with mark-selective parameters where applicable
#'
#'
read_coho_fish_sclr <- function(db, runs = NULL, fisheries = NULL){
  db_con <- DBI::dbConnect(
    drv = odbc::odbc(),
    .connection_string = paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=", db, ";"))

  fs <- dplyr::select(dplyr::tbl(db_con, "FisheryScalers"), -PrimaryKey)

  if (!is.null(runs)) { fs <- dplyr::filter(fs, RunID %in% runs) }
  if (!is.null(fisheries)) { fs <- dplyr::filter(fs, FisheryID %in% fisheries) }

  fs <- fs |>
    dplyr::left_join(
      dplyr::tbl(db_con, "RunID") |>  dplyr::select(RunID, RunYear, RunName),
      by = "RunID") |>
    dplyr::left_join(
      dplyr::tbl(db_con, "Fishery") |> dplyr::filter(Species == "COHO") |> dplyr::select(FisheryID, FisheryName),
      by = "FisheryID") |>
    dplyr::select(RunID, RunName, RunYear, FisheryID, FisheryName, TimeStep, everything()) |>
    dplyr::collect() |>
    dplyr::arrange(RunYear, FisheryID, TimeStep) |>
    dplyr::mutate(RunYear = as.numeric(RunYear))

  DBI::dbDisconnect(db_con)
  return(fs)
}
