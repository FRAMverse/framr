#' Load FisheryScaler values into a Coho FRAM database
#' @export
#'
#' @description INCOMPLETE DO NOT YET ATTEMPT TO USE
#'
#' @param db string, file path to database
#' @param runs numeric, RunID(s) as ID or ID:ID, default NULL for all runs
#' @param fs_new tibble/data.frame, object with FisheryID, TimeStep and Flag/Scaler/Quota fields
#'
#' @return nothing
#'
#'
load_coho_fish_sclr <- function(db, runs = NULL, fs_new = NULL){
  #borrows pattern from SOF_CNR script: get max PrimaryKey, delete by runID/fisheryID, append

  #cases:
  #-only runs arg
  #-only RunID field in fs_new
  #-neither
  #-both

  #if RunIDs are in the passed object, get them
  runs_fs_new <- NULL
  if(!is.null(fs_new)) {
    if("RunID" %in% colnames(fs_new)) {
      runs_fs_new = sort(unique(fs_new$RunID))
    }
  }
  #neither provided...
  if(is.null(runs_fs_new) & is.null(runs)) {
    print("No RunIDs in fs_new object or runs argument")
    stop()
  }
  #both provided
  if(!is.null(runs_fs_new) & !is.null(runs)) {
    print("RunIDs provided in both fs_new object and runs argument. Please provide only one set.")
    stop()
  }

  if(is.null(runs)){}


  fisheries <- sort(unique(fs_new$FisheryID))

  #build SQL statement
  sql_delete <- paste0(
    "DELETE FisheryScalers.* FROM FisheryScalers WHERE RunID In (", paste0(runs, collapse = ","),
         ") AND (FisheryID In (", paste0(fisheries, collapse = ","),"));"
    )

  db_con <- DBI::dbConnect(
    drv = odbc::odbc(),
    .connection_string = paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=", db, ";"))

  fs_orig <- dplyr::collect(dplyr::tbl(db_con, "FisheryScalers"))
  pk_max <- max(fs_orig$PrimaryKey)

  fs_swap <- dplyr::filter(fs_orig, RunID %in% runs, FisheryID %in% fisheries) |>
    dplyr::select(-PrimaryKey)

  #join and overwrite from fs_new
  #NEED TO DECIDE ON RUNID HANDLING...
  #allow passed vector as argument OR field in fs_new
  full_join(fs_swap, fs_new, by = c("FisheryID", "TimeStep"))

    mutate(
      PrimaryKey = seq(pk_max+1, pk_max+nrow(fs_new)),
      FisheryScaleFactor = FisheryScaleFactor_new,
      FisheryScaleFactor_new = NULL,
      FisheryFlag = 1
    )


  DBI::dbGetQuery(db_con, sql_delete)
  DBI::dbAppendTable(db_con, name = "FisheryScalers", value = fs_new, batch_rows = 1)
  DBI::dbDisconnect(db_con)
  print("Scalers updated")
}
