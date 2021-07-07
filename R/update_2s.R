#' Convenience function to update age 2 recruit scalers given forecast 2s
#' @export
#'
#' @description This function modernizes scripts developed by Jon Carey
#'  and Derek Dapp to update and overwrite Chinook age 2 recruit scalers
#'  in a database run. It calculates the ratio of the provided forecast
#'  age 2 abundance to the existing mature cohort abundance, and then
#'  multiplies that ratio against the existing recruit scaler.
#'
#' @param chinrs string, path to "ChinRSScalers" file with provided a2s
#' @param db string, file path to database
#' @param runID numeric, RunID to be altered
#'
#' @return Nothing, but database tables are altered.
#'
#' @examples
#' \dontrun{
#' #note that reads from xlsm ChinRSScaler files can be very slow
#' #due to old/leftover sheet names & connections
#' update_2s("path/to/ChinRSScalarsMR21.xlsm", "path/to/Chinook_FRAM_Database.mdb", runID = NNN)
#'
#' }
update_2s <- function(chinrs, db, runID){

  print(paste0("Getting forecast 2s from ", basename(chinrs)))
  forecasts <- readxl::read_excel(chinrs, sheet = "Age2forR") |>
    dplyr::filter(Forecast != "2s3s", Age == 2) #should already be only 2s...

  #open a connection to a FRAM project file database
  db_con <- DBI::dbConnect(
    drv = odbc::odbc(),
    .connection_string = paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=",db,";")
  )

  #confirm passed run ID is valid
  stopifnot("runID is not in RunIDs" = dplyr::tbl(db_con, "RunID") |> dplyr::filter(RunID == runID) |> dplyr::collect() |> nrow() == 1)

  print(paste0("Getting StockRecruit and Cohort tables from ", basename(db)))
  #get StockRecruit
  StockRecruit <- dplyr::tbl(db_con, "StockRecruit") |>
    dplyr::filter(RunID == runID, Age == 2) |>
    dplyr::collect()

  #get Cohort
  #double filter top avoid bringing in all runs from a bloated mdb
  #but due to issues passing StockID vector args into Access SQL
  Cohort <- dplyr::tbl(db_con, "Cohort") |>
    dplyr::filter(RunID == runID) |>
    dplyr::collect() |>
    dplyr::filter(
      StockID %in% forecasts$StockID,
      Age == 2,
      TimeStep %in% 1:3
      ) |>
    dplyr::group_by(RunID, StockID, Age) |>
    dplyr::summarise(Age2MatureSum = sum(MatureCohort), .groups = "drop")

  print(paste0("Calculating adjustments from age 2 MatureCohort of run ", runID))
  #associate existing TRS 2s value
  forecasts <- dplyr::left_join(forecasts, Cohort, by = c("StockID", "Age"))  |>
    dplyr::mutate(
      dplyr::across(c(RunID, Age2MatureSum), ~tidyr::replace_na(., -99)),
      Forecast = as.numeric(Forecast),
      Adjustment = Forecast / Age2MatureSum
      )

  SR_new <- dplyr::left_join(StockRecruit, forecasts, by = c("RunID", "StockID", "Age")) |>
    dplyr::mutate(
      RecruitScaleFactor = round(Adjustment * RecruitScaleFactor, 4) #not sure why rounding
    ) |>
    dplyr::select(PrimaryKey:RecruitCohortSize)

  #would be nice to dplyr::rows_upsert here
  #but Access, so sticking with prior delete/append pattern
  print(paste0("Updating ", nrow(SR_new), " rows of StockRecruit for run ", runID))
  DBI::dbGetQuery(db_con, paste0(
      "DELETE StockRecruit.* FROM StockRecruit WHERE RunID = ", runID, " AND (Age = 2);")
    )
  DBI::dbAppendTable(db_con, name = "StockRecruit", value = SR_new, batch_rows = 1)
  DBI::dbDisconnect(db_con)

}
