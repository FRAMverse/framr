#' Lookup of Coho FRAM commercial fisheries in TOCAS
#'
#' Maps NWIFC TOCAS data to Coho FRAM FisheryIDs.
#'
#' @docType data
#'
#' @format data frame (tbl_df) with 264 rows and 7 cols:
#' \describe{
#'   \item{Fishery}{integer 1|2 flag for nontreaty|treaty}
#'   \item{TribeName}{string}
#'   \item{Gear_type}{string designating Net, Troll, Hook&Line}
#'   \item{Disposition}{string indicating test, C&S, etc.}
#'   \item{Catch_Area}{string designating location of catch}
#'   \item{FisheryID}{integer associated FRAM FisheryID}
#'   \item{name_drop}{string for ease of reference, drop in joins}
#' }
#'
#' @source unexported lu_coho.xlsx
#' lu_coho_tocas_fram <- readxl::read_excel("xlsx/lu_coho.xlsx", sheet = "TOCAS_FRAM") |>
#'  dplyr::mutate(dplyr::across(dplyr::starts_with('Fishery'), as.integer))
#' save(lu_coho_tocas_fram, file = 'data/lu_coho_tocas_fram.rda')
#'
"lu_coho_tocas_fram"
