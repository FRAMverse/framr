#' Convenience function to replicate PFMC fishery inputs across FRAM RunIDs
#' @export
#'
#' @description This updates a OceanOptMergeFile.R script
#' developed by Jon Carey. Maintains DELETE then append pattern,
#' avoiding possibly slow rewrite of entire FisheryScalers
#' in a project mdb with many runs. Also left as single pairwise RunIDs
#' and fixed FisheryIDs rather than passing as args.
#'
#' @param db string, file path to database
#' @param run_from numeric, "donor" run
#' @param run_to numeric, "recipient" run
#'
#' @return Nothing, but database tables are altered.
#'
rep_ocean_opt <- function(db, run_from, run_to){

  #filter condition below, in addition to 17 in t2&3
  fisheries <- c(16,18,20,21,22,26,27,30,31,32,33,34,35)

  #open a connection to a FRAM project file database
  db_con <- DBI::dbConnect(
    drv = odbc::odbc(),
    .connection_string = paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=",db,";")
  )

  #confirm passed run IDs are valid
  run_id <- dplyr::tbl(db_con, "RunID") |> dplyr::collect()
  stopifnot("run_from not in RunIDs" = run_from %in% run_id$RunID)
  stopifnot("run_to not in RunIDs" = run_to %in% run_id$RunID)

  #get donor FisheryScaler rows
  fs_from <- dplyr::tbl(db_con, "FisheryScalers") |>
    dplyr::filter(
      RunID == run_from,
      FisheryID %in% fisheries | (FisheryID == 17 & dplyr::between(TimeStep, 2, 3))
    ) |>
    dplyr::collect()
  print(paste0("Read ", nrow(fs_from), " rows from RunID ", run_from))

  #get recipient rows PrimaryKey
  fs_to <- dplyr::tbl(db_con, "FisheryScalers") |>
    dplyr::filter(
      RunID == run_to,
      FisheryID %in% fisheries | (FisheryID == 17 & between(TimeStep, 2, 3))
    ) |>
    dplyr::select(PrimaryKey, RunID, FisheryID, TimeStep) |>
    dplyr::collect() |>
    dplyr::left_join(
      dplyr::select(fs_from, -PrimaryKey, -RunID),
      by = c("FisheryID", "TimeStep")
      )

  #delete target run rows
  DBI::dbGetQuery(db_con,
                  paste0("DELETE FisheryScalers.* FROM FisheryScalers WHERE RunID = ", run_to,
                         " AND ( (FisheryID In (16,18,20,21,22,26,27,30,31,32,33,34,35)) OR (FisheryID = 17 AND (TimeStep In (2,3))));")
  )

  #add back donor rows and close connection
  DBI::dbAppendTable(db_con, name = "FisheryScalers", value = fs_to, batch_rows = 1)
  DBI::dbDisconnect(db_con)

}
