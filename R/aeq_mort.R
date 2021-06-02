#' Extract AEQ mortality from Chinook FRAM database
#' @export
#'
#' @param db string, file path to database
#' @param runs numeric, RunID(s) as ID or ID:ID
#' @param stocks numeric, StockID(s) as ID or ID:ID
#' @param drop_t1 logical, should timestep 1 be excluded?
#' @param sum_ages logical, should ages 2:5 be summed? (per run-s-f-t)
#'
#' @return a tibble of AEQ'd mortality, possibly aggregated over ages to
#'  the per run-stock-fishery-timestep total
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#'
#' #showing M&UM for a given stock across runs
#' #with ages 2:5 summed for timesteps 2:4
#' aeq_mort("path/to/Chinook_FRAM_Database.mdb",
#'  runs = 1:4, stocks = 31:32, drop_t1 = T, sum_ages = T)
#'
#' }
aeq_mort <- function(db, runs = NULL, stocks = NULL, drop_t1 = T, sum_ages = F){

  cols_to_aeq <- c("LandedCatch", "NonRetention", "Shaker", "DropOff",
                   "MSFLandedCatch", "MSFNonRetention", "MSFShaker", "MSFDropOff")

  #open a connection to a FRAM project file database
  db_con <- DBI::dbConnect(
    drv = odbc::odbc(),
    .connection_string = paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=",db,";")
    )

  #first build a lazy query conditioned on passed args
  m <- dplyr::tbl(db_con, "Mortality") %>%
    dplyr::select(-PrimaryKey)
  if(drop_t1) { m <- dplyr::filter(m, TimeStep > 1) }
  if(!is.null(runs)) { m <- dplyr::filter(m, RunID %in% runs) }
  if(!is.null(stocks)) { m <- dplyr::filter(m, StockID %in% stocks) }

  #now execute and bring into memory
  m <- m %>%
    dplyr::left_join(x = .,
      y = dplyr::tbl(db_con, "RunID") %>% dplyr::select(RunID, RunYear, RunName, BasePeriodID),
      by = "RunID") %>%
    dplyr::left_join(x = .,
      y = dplyr::tbl(db_con, "AEQ"),
      by = c("BasePeriodID", "StockID", "Age", "TimeStep")) %>%
    dplyr::left_join(x = .,
      y = dplyr::tbl(db_con, "TerminalFisheryFlag"),
      by = c("BasePeriodID", "FisheryID", "TimeStep")) %>%
    dplyr::right_join(
      x = dplyr::tbl(db_con, "Stock") %>%
        dplyr::filter(Species == "CHINOOK") %>%
        dplyr::select(StockID, StockName),
      y = .,
      by = "StockID") %>%
    dplyr::right_join(
      x = dplyr::tbl(db_con, "Fishery") %>%
        dplyr::filter(Species == "CHINOOK") %>%
        dplyr::select(FisheryID, FisheryName),
      y = .,
      by = "FisheryID") %>%
    dplyr::collect()

  #close the connection
  DBI::dbDisconnect(db_con)

  #calc the AEQ
  m <- m %>%
    dplyr::mutate(
      TerminalFlag = tidyr::replace_na(TerminalFlag, as.integer(0)),
      dplyr::across(dplyr::all_of(cols_to_aeq), ~dplyr::if_else(TerminalFlag == 1, ., . * AEQ)),
      mort_aeq_ns = LandedCatch + NonRetention + Shaker + DropOff,
      mort_aeq_msf = MSFLandedCatch + MSFNonRetention + MSFShaker + MSFDropOff,
      mort_aeq_tot = mort_aeq_ns + mort_aeq_msf
    ) %>%
    dplyr::select(BasePeriodID, RunID, RunYear, RunName,
           FisheryID, FisheryName, TimeStep, StockID, StockName, Age,
           dplyr::all_of(cols_to_aeq), dplyr::starts_with("mort_aeq"))

  #aggregate across ages per stock, timestep, fishery and run/year
  if(sum_ages){
    m <- m %>%
      dplyr::group_by(BasePeriodID, RunID, RunYear, RunName, FisheryID, FisheryName, TimeStep, StockID, StockName) %>%
      dplyr::summarise(dplyr::across(c(dplyr::all_of(cols_to_aeq), dplyr::starts_with("mort_aeq")), sum, na.rm = T), .groups = "drop")
  }

  m <- m %>% dplyr::arrange(RunID, FisheryID, TimeStep, StockID)

  return(m)

}
