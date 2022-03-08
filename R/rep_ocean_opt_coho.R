#' Convenience function to replicate fishery inputs across FRAM RunIDs
#' @export
#'
#' @description This transfers FisheryScalers and NonRetention table
#' values from one to another run, as is necessary during PFMC STT
#' examination of multiple ocean options.
#' Maintains DELETE then append pattern originally developed by Jon Carey,
#' avoiding possibly slow rewrite of entire FisheryScalers
#' in a project mdb with many runs.
#'
#' @param db string, file path to database
#' @param run_from numeric, "donor" run
#' @param run_to numeric, "recipient" run
#'
#' @return Nothing, but database tables are altered.
#'
rep_ocean_opt_coho <- function(
  db, run_from, run_to
  ){

  #all TS for these, plus fishery 43 in ts 1:4
  #kept hard coded to avoid faffing with additional args
  fisheries <- c(1,2,3,4,5,6,7,8,9,10,
                11,12,13,14,15,16,17,18,19,20,
                21,22,23,24,25,26,27,28,29,30,
                31,32,33,34,35,36,37,38,39,40,
                41,42)

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
      FisheryID %in% fisheries | (FisheryID == 43 & dplyr::between(TimeStep, 1, 4))
    ) |>
    dplyr::collect()
  print(paste0("Read ", nrow(fs_from), " FisheryScaler rows from RunID ", run_from))

  #get recipient rows PrimaryKey
  fs_to <- dplyr::tbl(db_con, "FisheryScalers") |>
    dplyr::filter(
      RunID == run_to,
      FisheryID %in% fisheries | (FisheryID == 43 & dplyr::between(TimeStep, 1, 4))
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
                         " AND ( (FisheryID In (",
                         paste0(fisheries, collapse = ","),
                         ")) OR (FisheryID = 43 AND (TimeStep In (1,2,3,4))));"
                         )
  )

  #add back donor rows and close connection
  DBI::dbAppendTable(db_con, name = "FisheryScalers", value = fs_to, batch_rows = 1)

  #now do the same for NonRetention
  #left non-functionalized in case of table idiosyncrasies

  nr_from <- dplyr::tbl(db_con, "NonRetention") |>
    dplyr::filter(
      RunID == run_from,
      FisheryID %in% fisheries | (FisheryID == 43 & dplyr::between(TimeStep, 1, 4))
    ) |>
    dplyr::collect()
  print(paste0("Read ", nrow(nr_from), " NonRetention rows from RunID ", run_from))

  #get recipient rows PrimaryKey
  nr_to <- dplyr::tbl(db_con, "NonRetention") |>
    dplyr::filter(
      RunID == run_to,
      FisheryID %in% fisheries | (FisheryID == 43 & dplyr::between(TimeStep, 1, 4))
    ) |>
    dplyr::select(PrimaryKey, RunID, FisheryID, TimeStep) |>
    dplyr::collect() |>
    dplyr::left_join(
      dplyr::select(nr_from, -PrimaryKey, -RunID),
      by = c("FisheryID", "TimeStep")
    )

  #delete target run rows
  DBI::dbGetQuery(db_con,
                  paste0("DELETE NonRetention.* FROM NonRetention WHERE RunID = ", run_to,
                         " AND ( (FisheryID In (",
                         paste0(fisheries, collapse = ","),
                         ")) OR (FisheryID = 43 AND (TimeStep In (1,2,3,4))));"
                  )
  )

  #add back donor rows and close connection
  DBI::dbAppendTable(db_con, name = "NonRetention", value = nr_to, batch_rows = 1)
  DBI::dbDisconnect(db_con)

}
