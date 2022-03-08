#' Extract values from coho TAMM sheet NT-Tsummary
#' @export
#'
#' @param tamm string, file path to TAMM workbook
#'
#' @return a of mortality and ER values by fishery and stock regions,
#' for "hat", "nat" (labeled "wild" in TAMM) and "tot" groupings.
#' NOTE the formulas in this sheet for "US OCEAN" include Alaskan fisheries,
#' and the "all" columns for these fisheries include non-WA stocks;
#' these values are typically hidden in sheet "2". See example below
#' for an exclude filter example.
#'
#' @examples
#' \dontrun{
#'
#' read_coho_tamm_nttr("path/to/TAMM/file.xlsx") |>
#'  #dropping queets_sup and "all_um/all_m" cols that include non-WA stocks in the AK catches
#'  filter(!is.na(origin), stk_type != "all_tot")
#'
#' }
#'
read_coho_tamm_nttr <- function(tamm){
  rows_dropped_ps <- c("-", "TOTAL MORTALITY:", "U.S. Ocean",
                       "PS Preterminal Net&Troll", "PS Terminal & FW Net", "PS Sport",
                       "subtotal", "TOTAL")
  rows_dropped_cst <- c("-", "U.S. OCEAN:", "PS Net&Troll&Sport", "Coastal Terminal", "TOTAL")

  dplyr::bind_rows(
    suppressWarnings(readxl::read_excel(
      path = tamm, range = "NT-Tsummary!A9:AB36",
      col_names = c("fishery",
                    "all_m", "all_um", "all_tot",
                    "skagit_nat", "skagit_hat", "skagit_tot",
                    "stilly_nat", "snohom_nat", "stsno_hat", "stsno_tot",
                    "hood_nat", "hood_hat", "hood_tot",
                    "jdf_nat", "jdf_hat", "jdf_tot",
                    "sps_nat", "sps_hat", "sps_tot",
                    "nksam_nat", "nksam_hat", "nksam_tot"),
      col_types = c("text", rep("numeric", 10), "skip",
                    "skip", rep("numeric", 6),
                    rep("skip", 3), rep("numeric", 6))
    )) |>
      dplyr::filter(
        !is.na(fishery),
        !(fishery %in% rows_dropped_ps)
      ) |>
      dplyr::mutate(
        region = "ps",
        fishery = c("er_tot", "er_nt", "er_tr",
                    "sus_ocn_nt", "sus_ocn_tr",
                    "ps_pt_nt", "ps_pt_tr",
                    "ps_trmfw_nt", "ps_trmfw_tr",
                    "ps_spt_a5_nt", "ps_spt_a6_nt", "ps_spt_a7_nt",
                    "ps_spt_a8-13&fw_nt",
                    "tot_nt", "tot_tr", "escp")
      ) |>
      tidyr::pivot_longer(names_to = "stk_type", values_to = "val", cols = -c(fishery, region))
    ,
    suppressWarnings(readxl::read_excel(
      path = tamm, range = "NT-Tsummary!AD10:AO39",
      col_names = c("fishery",
                    "quilfall_nat", "hoh_nat", "quilfall_hat", "quilfall_tot",
                    "queets_nat", "queets_sup", "queets_hat", "queets_tot",
                    "gh_nat", "gh_hat", "gh_tot"),
      col_types = c("text", rep("numeric", 11))
    )) |>
      dplyr::filter(
        !is.na(fishery),
        !(fishery %in% rows_dropped_cst)
      ) |>
      dplyr::mutate(
        region = "cst",
        fishery = c("er_nt", "er_tr", "sus_ocn_nt", "sus_ocn_tr",
                    "ps_nt", "ps_tr", "cst_trm_nt", "cst_trm_tr",
                    "tot_nt", "tot_tr", "escp")
      ) |>
      tidyr::pivot_longer(names_to = "stk_type", values_to = "val", cols = -c(fishery, region))
  ) |>
    dplyr::mutate(
      origin = stringr::str_sub(stk_type,-3,-1),
      origin = dplyr::if_else(origin %in% c("nat","hat","tot"), origin, NA_character_),
      nt_tr = stringr::str_sub(fishery,-2,-1),
      nt_tr = dplyr::if_else(nt_tr %in% c("nt","tr"), nt_tr, NA_character_),
      run = readxl::read_excel(tamm, range = "NT-Tsummary!B3", col_names = "run")$run,
      tamm = tools::file_path_sans_ext(basename(tamm))
    ) |>
    dplyr::filter(!is.na(val)) |>
    dplyr::select(run, tamm, region, nt_tr, origin, everything())

}
