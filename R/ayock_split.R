#' Convenience function to perform the "Ayock Splits"
#' @export
#'
#' @param db string, file path to database
#' @param tamm_file_paths character vector of path(s)
#'  to TAMM xlsx associated with `runs`
#'
#' @description This function extracts and summarizes the Chin FRAM
#'  Mortality table info for HC FF via `framr::aeq_mort`.
#'
#'  The timestep 3 AEQ'd NS and MSF mortality for HC FF
#'  (UM:31 and M:32, including 2s) in A12 sport are then written into
#'  the appropriate TAMM cells via the non-CRAN package `RDCOMClient`.
#'  This dependency can be installed with:
#'
#'  install.packages("RDCOMClient", repos = "http://www.omegahat.net/R")
#'
#' @return Nothing, but xlsx files outside of R/Rstudio should be altered,
#'  and the metadata and values are printed to the console.
#'
#' @importFrom magrittr %>%
#' @import RDCOMClient
#'
ayock_split <- function(db, tamm_file_paths){

  #duplicates db_con in aeq_mort() but avoids reading entire Mort table for join against RunName
  db_con <- DBI::dbConnect(
    drv = odbc::odbc(),
    .connection_string = paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=",db,";")
    )

  #!!!this presumes no duplicated RunNames in RunID table!!!
  rn_rid <- dplyr::left_join(
    #RunName(s) read from TAMMs as written by FRAM
    x = dplyr::tibble(tamm = tamm_file_paths) %>%
      dplyr::mutate(
        RunName = purrr::map_chr(
          tamm, ~unlist(readxl::read_excel(path = .x, range = "TAMX!B2", col_names = "RunName"))
        )
      )
    ,
    #associated RunIDs to file paths joined on RunNames
    y = dplyr::tbl(db_con, "RunID") %>%
      dplyr::select(RunID, RunYear, RunName, BasePeriodID) %>%
      dplyr::collect(),
    by = "RunName"
    )

  DBI::dbDisconnect(db_con)

  #get the timestep 3 AEQd NS and MSF morts
  #for UM (31) and M (32) HC FF in A12 sport
  #includes a2s
  m <- framr::aeq_mort(db = db, runs = rn_rid$RunID, stocks = 31:32, sum_ages = T, drop_t1 = T) %>%
    dplyr::filter(FisheryID == 64, TimeStep == 3) %>%
    dplyr::select(RunID, StockID, StockName, mort_aeq_ns, mort_aeq_msf) %>%
    tidyr::pivot_longer(c(mort_aeq_ns, mort_aeq_msf), names_to = "mort_type", values_to = "val") %>%
    dplyr::left_join(rn_rid, by = "RunID") %>% #rejoin the metadata fields for convenience
    dplyr::mutate(
      sheet = dplyr::if_else(StockID == 31, "HdCUnmrkd!", "HdCmrkd!"),
      R = dplyr::if_else(stringr::str_detect(mort_type, "_ns"), 46, 47),
      C = 15 #column "O"
    ) %>%
    dplyr::select(
      tamm, RunID, RunName, RunYear, BasePeriodID,
      StockID, StockName, mort_type, val, sheet, R, C
      )

  print(m)

  #iterate over list of tibbles per tamm (file) rows
  purrr::walk(
    .x = split(m, m$tamm),
    .f = function(f_tib){
      #set up and open the TAMM
      tamm_file <- unique(f_tib$tamm)
      print(tamm_file)
      xlApp <- RDCOMClient::COMCreate("Excel.Application")
      wb <- xlApp$Workbooks()$Open(tamm_file)
      xlApp[['Visible']] <- TRUE

      #now iterate over the 2 values per the 2 relevant sheets
      #note sheet names are hard-coded above, and should not change per f_tib
      #and RDCOMClient wants no '!'
      purrr::walk(
        .x = c("HdCUnmrkd", "HdCmrkd"),
        .f = function(sheet_name){
          wb_sheet <- wb$Worksheets(sheet_name)
          sheet_tib <- f_tib %>%
            dplyr::filter(sheet == paste0(sheet_name,"!")) %>%
            dplyr::mutate(
              wbc = purrr::map2(R, C, ~wb_sheet$Cells(.x, .y))
              )
          #and now iterate writes over each cell
          purrr::walk2(
            .x = sheet_tib$wbc,
            .y = sheet_tib$val,
            .f = function(x,y){
              #Use a string rather than the default RDCOM value 65535
              #kept here rather than if.else in mutate to avoid num/chr conflicts
              if(is.na(y)){ y <- "NA" }
              x[["Value"]] <- y
            }) #end write walk
        }) #end sheets walk

      wb$close(TRUE) # save and close excel book
      xlApp$Quit()

    }) #end walk over tamm file tibbles

}
