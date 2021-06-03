#' Convenience function to perform in-workbook SPS iterations
#' @export
#'
#' @param tamm_file_paths character vector of path(s)
#'
#' @description This function iterates the copy/paste process
#' in a Chinook TAMM, leaving the actual calculations to the Excel
#' formulas. It is fundamentally unchanged from older work by
#' Jon Carey (NOAA) and Derek Dapp (WDFW).
#'
#' @return Nothing, but xlsx files outside of R/Rstudio should be altered
#'
#' @importFrom magrittr %>%
#' @import RDCOMClient
#'
sps <- function(tamm_file_paths) {

  for (i in tamm_file_paths){

    xlApp <- COMCreate("Excel.Application")
    wb    <- xlApp[["Workbooks"]]$Open(i)
    xlApp[["Visible"]] <- TRUE
    xlApp[["DisplayAlerts"]] <-FALSE

    #worksheet you're interested in
    Iter_Page <- wb$Worksheets("SPS Abundance Iterations")
    Input_Page <- wb$Worksheets("Input Page")
    SPSmrkd_Page <- wb$Worksheets("SPSmrkd")
    SPSunmrkd_Page <- wb$Worksheets("SPSUnmrkd")

    #Initializes by taking values from SPS Iter Page
    CarrMintHatHM<-Iter_Page$Cells(21,2)[["Value"]]
    CarrMintHatHU<-Iter_Page$Cells(21,3)[["Value"]]
    CarrMintHatNM<-Iter_Page$Cells(21,4)[["Value"]]
    CarrMintHatNU<-Iter_Page$Cells(21,5)[["Value"]]
    CarrMintNatHM<-Iter_Page$Cells(22,2)[["Value"]]
    CarrMintNatHU<-Iter_Page$Cells(22,3)[["Value"]]
    CarrMintNatNM<-Iter_Page$Cells(22,4)[["Value"]]
    CarrMintNatNU<-Iter_Page$Cells(22,5)[["Value"]]
    ChambersHatHM<-Iter_Page$Cells(23,2)[["Value"]]
    ChambersHatHU<-Iter_Page$Cells(23,3)[["Value"]]
    ChambersHatNM<-Iter_Page$Cells(23,4)[["Value"]]
    ChambersHatNU<-Iter_Page$Cells(23,5)[["Value"]]
    NisqHatHM<-Iter_Page$Cells(24,2)[["Value"]]
    NisqHatHU<-Iter_Page$Cells(24,3)[["Value"]]
    NisqHatNM<-Iter_Page$Cells(24,4)[["Value"]]
    NisqHatNU<-Iter_Page$Cells(24,5)[["Value"]]
    NisqNatHM<-Iter_Page$Cells(25,2)[["Value"]]
    NisqNatHU<-Iter_Page$Cells(25,3)[["Value"]]
    NisqNatNM<-Iter_Page$Cells(25,4)[["Value"]]
    NisqNatNU<-Iter_Page$Cells(25,5)[["Value"]]
    McAllHatHM<-Iter_Page$Cells(26,2)[["Value"]]
    McAllHatHU<-Iter_Page$Cells(26,3)[["Value"]]
    McAllHatNM<-Iter_Page$Cells(26,4)[["Value"]]
    McAllHatNU<-Iter_Page$Cells(26,5)[["Value"]]
    McAllNatHM<-Iter_Page$Cells(27,2)[["Value"]]
    McAllNatHU<-Iter_Page$Cells(27,3)[["Value"]]
    McAllNatNM<-Iter_Page$Cells(27,4)[["Value"]]
    McAllNatNU<-Iter_Page$Cells(27,5)[["Value"]]
    DescHatHM<-Iter_Page$Cells(28,2)[["Value"]]
    DescHatHU<-Iter_Page$Cells(28,3)[["Value"]]
    DescHatNM<-Iter_Page$Cells(28,4)[["Value"]]
    DescHatNU<-Iter_Page$Cells(28,5)[["Value"]]
    Misc13HatHM<-Iter_Page$Cells(29,2)[["Value"]]
    Misc13HatHU<-Iter_Page$Cells(29,3)[["Value"]]
    Misc13HatNM<-Iter_Page$Cells(29,4)[["Value"]]
    Misc13HatNU<-Iter_Page$Cells(29,5)[["Value"]]

    #Initial Redistribution
    CarrMintHat13PlusRedistM<-SPSmrkd_Page$Cells(20,45)[["Value"]]
    CarrMintHat13PlusRedistUM<-SPSunmrkd_Page$Cells(20,45)[["Value"]]
    CarrMintHat13ARedistM<-SPSmrkd_Page$Cells(20,46)[["Value"]]
    CarrMintHat13ARedistUM<-SPSunmrkd_Page$Cells(20,46)[["Value"]]
    CarrMintNat13PlusRedistM<-SPSmrkd_Page$Cells(21,45)[["Value"]]
    CarrMintNat13PlusRedistUM<-SPSunmrkd_Page$Cells(21,45)[["Value"]]
    CarrMintNat13ARedistM<-SPSmrkd_Page$Cells(21,46)[["Value"]]
    CarrMintNat13ARedistUM<-SPSunmrkd_Page$Cells(21,46)[["Value"]]
    ChambersHat13PlusRedistM<-SPSmrkd_Page$Cells(22,45)[["Value"]]
    ChambersHat13PlusRedistUM<-SPSunmrkd_Page$Cells(22,45)[["Value"]]
    ChambersHat13ARedistM<-SPSmrkd_Page$Cells(22,46)[["Value"]]
    ChambersHat13ARedistUM<-SPSunmrkd_Page$Cells(22,46)[["Value"]]
    NisqHat13PlusRedistM<-SPSmrkd_Page$Cells(23,45)[["Value"]]
    NisqHat13PlusRedistUM<-SPSunmrkd_Page$Cells(23,45)[["Value"]]
    NisqHat13ARedistM<-SPSmrkd_Page$Cells(23,46)[["Value"]]
    NisqHat13ARedistUM<-SPSunmrkd_Page$Cells(23,46)[["Value"]]
    NisqNat13PlusRedistM<-SPSmrkd_Page$Cells(24,45)[["Value"]]
    NisqNat13PlusRedistUM<-SPSunmrkd_Page$Cells(24,45)[["Value"]]
    NisqNat13ARedistM<-SPSmrkd_Page$Cells(24,46)[["Value"]]
    NisqNat13ARedistUM<-SPSunmrkd_Page$Cells(24,46)[["Value"]]
    McAllHat13PlusRedistM<-SPSmrkd_Page$Cells(25,45)[["Value"]]
    McAllHat13PlusRedistUM<-SPSunmrkd_Page$Cells(25,45)[["Value"]]
    McAllHat13ARedistM<-SPSmrkd_Page$Cells(25,46)[["Value"]]
    McAllHat13ARedistUM<-SPSunmrkd_Page$Cells(25,46)[["Value"]]
    McAllNat13PlusRedistM<-SPSmrkd_Page$Cells(26,45)[["Value"]]
    McAllNat13PlusRedistUM<-SPSunmrkd_Page$Cells(26,45)[["Value"]]
    McAllNat13ARedistM<-SPSmrkd_Page$Cells(26,46)[["Value"]]
    McAllNat13ARedistUM<-SPSunmrkd_Page$Cells(26,46)[["Value"]]
    DescHat13PlusRedistM<-SPSmrkd_Page$Cells(27,45)[["Value"]]
    DescHat13PlusRedistUM<-SPSunmrkd_Page$Cells(27,45)[["Value"]]
    DescHat13ARedistM<-SPSmrkd_Page$Cells(27,46)[["Value"]]
    DescHat13ARedistUM<-SPSunmrkd_Page$Cells(27,46)[["Value"]]
    Misc13Hat13PlusRedistM<-SPSmrkd_Page$Cells(28,45)[["Value"]]
    Misc13Hat13PlusRedistUM<-SPSunmrkd_Page$Cells(28,45)[["Value"]]
    Misc13Hat13ARedistM<-SPSmrkd_Page$Cells(28,46)[["Value"]]
    Misc13Hat13ARedistUM<-SPSunmrkd_Page$Cells(28,46)[["Value"]]

    CarrMintHat13ARedistMInits<-(CarrMintHat13ARedistM+CarrMintHat13ARedistUM+CarrMintNat13ARedistM+CarrMintNat13ARedistUM+ChambersHat13ARedistM+ChambersHat13ARedistUM+NisqHat13ARedistM+NisqHat13ARedistUM+NisqNat13ARedistM+NisqNat13ARedistUM+McAllHat13ARedistM+McAllHat13ARedistUM+McAllNat13ARedistM+McAllNat13ARedistUM+DescHat13ARedistM+DescHat13ARedistUM+Misc13Hat13ARedistM+Misc13Hat13ARedistUM)*(CarrMintHatHM/(CarrMintHatHM+CarrMintHatHU))
    CarrMintHat13ARedistUMInits<-(CarrMintHat13ARedistM+CarrMintHat13ARedistUM+CarrMintNat13ARedistM+CarrMintNat13ARedistUM+ChambersHat13ARedistM+ChambersHat13ARedistUM+NisqHat13ARedistM+NisqHat13ARedistUM+NisqNat13ARedistM+NisqNat13ARedistUM+McAllHat13ARedistM+McAllHat13ARedistUM+McAllNat13ARedistM+McAllNat13ARedistUM+DescHat13ARedistM+DescHat13ARedistUM+Misc13Hat13ARedistM+Misc13Hat13ARedistUM)*(CarrMintHatHU/(CarrMintHatHM+CarrMintHatHU))

    DescYRLMarked <- Input_Page$Cells(69,17)[["Value"]]
    DescYRLUnmarked <- Input_Page$Cells(69,18)[["Value"]]

    DescHat13PlusRedistMInits<-(CarrMintHat13PlusRedistM+CarrMintHat13PlusRedistUM+CarrMintNat13PlusRedistM+CarrMintNat13PlusRedistUM+ChambersHat13PlusRedistM+ChambersHat13PlusRedistUM+NisqHat13PlusRedistM+NisqHat13PlusRedistUM+NisqNat13PlusRedistM+NisqNat13PlusRedistUM+McAllHat13PlusRedistM+McAllHat13PlusRedistUM+McAllNat13PlusRedistM+McAllNat13PlusRedistUM+DescHat13PlusRedistM+DescHat13PlusRedistUM+Misc13Hat13PlusRedistM+Misc13Hat13PlusRedistUM)*((DescHatHM-DescYRLMarked)/(DescHatHM+DescHatHU-DescYRLMarked-DescYRLUnmarked))
    DescHat13PlusRedistUMInits<-(CarrMintHat13PlusRedistM+CarrMintHat13PlusRedistUM+CarrMintNat13PlusRedistM+CarrMintNat13PlusRedistUM+ChambersHat13PlusRedistM+ChambersHat13PlusRedistUM+NisqHat13PlusRedistM+NisqHat13PlusRedistUM+NisqNat13PlusRedistM+NisqNat13PlusRedistUM+McAllHat13PlusRedistM+McAllHat13PlusRedistUM+McAllNat13PlusRedistM+McAllNat13PlusRedistUM+DescHat13PlusRedistM+DescHat13PlusRedistUM+Misc13Hat13PlusRedistM+Misc13Hat13PlusRedistUM)-DescHat13PlusRedistMInits

    CarrMintHat13PlusRedistMInits<-0
    CarrMintHat13PlusRedistUMInits<-0
    CarrMintNat13PlusRedistMInits<-0
    CarrMintNat13PlusRedistUMInits<-0
    CarrMintNat13ARedistMInits<-0
    CarrMintNat13ARedistUMInits<-0
    ChambersHat13PlusRedistMInits<-0
    ChambersHat13PlusRedistUMInits<-0
    ChambersHat13ARedistMInits<-0
    ChambersHat13ARedistUMInits<-0
    NisqHat13PlusRedistMInits<-0
    NisqHat13PlusRedistUMInits<-0
    NisqHat13ARedistMInits<-0
    NisqHat13ARedistUMInits<-0
    NisqNat13PlusRedistMInits<-0
    NisqNat13PlusRedistUMInits<-0
    NisqNat13ARedistMInits<-0
    NisqNat13ARedistUMInits<-0
    McAllHat13PlusRedistMInits<-0
    McAllHat13PlusRedistUMInits<-0
    McAllHat13ARedistMInits<-0
    McAllHat13ARedistUMInits<-0
    McAllNat13PlusRedistMInits<-0
    McAllNat13PlusRedistUMInits<-0
    McAllNat13ARedistMInits<-0
    McAllNat13ARedistUMInits<-0
    DescHat13ARedistMInits<-0
    DescHat13ARedistUMInits<-0
    Misc13Hat13PlusRedistMInits<-0
    Misc13Hat13PlusRedistUMInits<-0
    Misc13Hat13ARedistMInits<-0
    Misc13Hat13ARedistUMInits<-0

    CarrMintHatHMNextStep<-CarrMintHatHM-CarrMintHat13PlusRedistMInits-CarrMintHat13ARedistMInits+CarrMintHat13PlusRedistM+CarrMintHat13ARedistM
    CarrMintHatHUNextStep<-CarrMintHatHU-CarrMintHat13PlusRedistUMInits-CarrMintHat13ARedistUMInits+CarrMintHat13PlusRedistUM+CarrMintHat13ARedistUM
    CarrMintHatNMNextStep<-0
    CarrMintHatNUNextStep<-0
    CarrMintNatHMNextStep<-0
    CarrMintNatHUNextStep<-0
    CarrMintNatNMNextStep<-0
    CarrMintNatNUNextStep<-0
    ChambersHatHMNextStep<-ChambersHatHM-ChambersHat13PlusRedistMInits-ChambersHat13ARedistMInits+ChambersHat13PlusRedistM+ChambersHat13ARedistM
    ChambersHatHUNextStep<-ChambersHatHU-ChambersHat13PlusRedistUMInits-ChambersHat13ARedistUMInits+ChambersHat13PlusRedistUM+ChambersHat13ARedistUM
    ChambersHatNMNextStep<-0
    ChambersHatNUNextStep<-0
    NisqHatHMNextStep<-NisqHatHM-NisqHat13PlusRedistMInits-NisqHat13ARedistMInits+NisqHat13PlusRedistM+NisqHat13ARedistM
    NisqHatHUNextStep<-NisqHatHU-NisqHat13PlusRedistUMInits-NisqHat13ARedistUMInits+NisqHat13PlusRedistUM+NisqHat13ARedistUM
    NisqHatNMNextStep<-0
    NisqHatNUNextStep<-0
    NisqNatHMNextStep<-0
    NisqNatHUNextStep<-0
    NisqNatNMNextStep<-0
    NisqNatNUNextStep<-NisqNatNU-NisqNat13PlusRedistUMInits-NisqNat13ARedistUMInits+NisqNat13PlusRedistUM+NisqNat13ARedistUM
    McAllHatHMNextStep<-McAllHatHM-McAllHat13PlusRedistMInits-McAllHat13ARedistMInits+McAllHat13PlusRedistM+McAllHat13ARedistM
    McAllHatHUNextStep<-McAllHatHU-McAllHat13PlusRedistUMInits-McAllHat13ARedistUMInits+McAllHat13PlusRedistUM+McAllHat13ARedistUM
    McAllHatNMNextStep<-0
    McAllHatNUNextStep<-0
    McAllNatHMNextStep<-0
    McAllNatHUNextStep<-0
    McAllNatNMNextStep<-0
    McAllNatNUNextStep<-0
    DescHatHMNextStep<-DescHatHM-DescHat13PlusRedistMInits-DescHat13ARedistMInits+DescHat13PlusRedistM+DescHat13ARedistM
    DescHatHUNextStep<-DescHatHU-DescHat13PlusRedistUMInits-DescHat13ARedistUMInits+DescHat13PlusRedistUM+DescHat13ARedistUM
    DescHatNMNextStep<-0
    DescHatNUNextStep<-0
    Misc13HatHMNextStep<-Misc13HatHM-Misc13Hat13PlusRedistMInits-Misc13Hat13ARedistMInits+Misc13Hat13PlusRedistM+Misc13Hat13ARedistM
    Misc13HatHUNextStep<-Misc13HatHU-Misc13Hat13PlusRedistUMInits-Misc13Hat13ARedistUMInits+Misc13Hat13PlusRedistUM+Misc13Hat13ARedistUM
    Misc13HatNMNextStep<-0
    Misc13HatNUNextStep<-0


    NextStepList <- c(CarrMintHatHMNextStep,CarrMintHatHUNextStep,CarrMintHatNMNextStep,CarrMintHatNUNextStep,CarrMintNatHMNextStep,CarrMintNatHUNextStep,CarrMintNatNMNextStep,CarrMintNatNUNextStep,ChambersHatHMNextStep,ChambersHatHUNextStep,ChambersHatNMNextStep,ChambersHatNUNextStep,NisqHatHMNextStep,NisqHatHUNextStep,NisqHatNMNextStep,NisqHatNUNextStep,NisqNatHMNextStep,NisqNatHUNextStep,NisqNatNMNextStep,NisqNatNUNextStep,McAllHatHMNextStep,McAllHatHUNextStep,McAllHatNMNextStep,McAllHatNUNextStep,McAllNatHMNextStep,McAllNatHUNextStep,McAllNatNMNextStep,McAllNatNUNextStep,DescHatHMNextStep,DescHatHUNextStep,DescHatNMNextStep,DescHatNUNextStep,Misc13HatHMNextStep,Misc13HatHUNextStep,Misc13HatNMNextStep,Misc13HatNUNextStep)
    CurrentStepList <- c(CarrMintHatHM,CarrMintHatHU,CarrMintHatNM,CarrMintHatNU,CarrMintNatHM,CarrMintNatHU,CarrMintNatNM,CarrMintNatNU,ChambersHatHM,ChambersHatHU,ChambersHatNM,ChambersHatNU,NisqHatHM,NisqHatHU,NisqHatNM,NisqHatNU,NisqNatHM,NisqNatHU,NisqNatNM,NisqNatNU,McAllHatHM,McAllHatHU,McAllHatNM,McAllHatNU,McAllNatHM,McAllNatHU,McAllNatNM,McAllNatNU,DescHatHM,DescHatHU,DescHatNM,DescHatNU,Misc13HatHM,Misc13HatHU,Misc13HatNM,Misc13HatNU)

    MaxDiff <- 0
    for (j in 1:length(NextStepList)){
      Diff <- 1-(NextStepList[j]/CurrentStepList[j])
      if(is.na(abs(Diff))==FALSE){
        if (abs(Diff)>MaxDiff){
          MaxDiff <- abs(Diff)
        }
      }
    }

    while (MaxDiff > .01){
      #Sets a new previous iteration for comparative purposes
      CarrMintHatHM<-CarrMintHatHMNextStep
      CarrMintHatHU<-CarrMintHatHUNextStep
      CarrMintHatNM<-CarrMintHatNMNextStep
      CarrMintHatNU<-CarrMintHatNUNextStep
      CarrMintNatHM<-CarrMintNatHMNextStep
      CarrMintNatHU<-CarrMintNatHUNextStep
      CarrMintNatNM<-CarrMintNatNMNextStep
      CarrMintNatNU<-CarrMintNatNUNextStep
      ChambersHatHM<-ChambersHatHMNextStep
      ChambersHatHU<-ChambersHatHUNextStep
      ChambersHatNM<-ChambersHatNMNextStep
      ChambersHatNU<-ChambersHatNUNextStep
      NisqHatHM<-NisqHatHMNextStep
      NisqHatHU<-NisqHatHUNextStep
      NisqHatNM<-NisqHatNMNextStep
      NisqHatNU<-NisqHatNUNextStep
      NisqNatHM<-NisqNatHMNextStep
      NisqNatHU<-NisqNatHUNextStep
      NisqNatNM<-NisqNatNMNextStep
      NisqNatNU<-NisqNatNUNextStep
      McAllHatHM<-McAllHatHMNextStep
      McAllHatHU<-McAllHatHUNextStep
      McAllHatNM<-McAllHatNMNextStep
      McAllHatNU<-McAllHatNUNextStep
      McAllNatHM<-McAllNatHMNextStep
      McAllNatHU<-McAllNatHUNextStep
      McAllNatNM<-McAllNatNMNextStep
      McAllNatNU<-McAllNatNUNextStep
      DescHatHM<-DescHatHMNextStep
      DescHatHU<-DescHatHUNextStep
      DescHatNM<-DescHatNMNextStep
      DescHatNU<-DescHatNUNextStep
      Misc13HatHM<-Misc13HatHMNextStep
      Misc13HatHU<-Misc13HatHUNextStep
      Misc13HatNM<-Misc13HatNMNextStep
      Misc13HatNU<-Misc13HatNUNextStep

      #Sets redistributions to previous iterations...
      CarrMintHat13PlusRedistMInits<-CarrMintHat13PlusRedistM
      CarrMintHat13PlusRedistUMInits<-CarrMintHat13PlusRedistUM
      CarrMintHat13ARedistMInits<-CarrMintHat13ARedistM
      CarrMintHat13ARedistUMInits<-CarrMintHat13ARedistUM
      CarrMintNat13PlusRedistMInits<-CarrMintNat13PlusRedistM
      CarrMintNat13PlusRedistUMInits<-CarrMintNat13PlusRedistUM
      CarrMintNat13ARedistMInits<-CarrMintNat13ARedistM
      CarrMintNat13ARedistUMInits<-CarrMintNat13ARedistUM
      ChambersHat13PlusRedistMInits<-ChambersHat13PlusRedistM
      ChambersHat13PlusRedistUMInits<-ChambersHat13PlusRedistUM
      ChambersHat13ARedistMInits<-ChambersHat13ARedistM
      ChambersHat13ARedistUMInits<-ChambersHat13ARedistUM
      NisqHat13PlusRedistMInits<-NisqHat13PlusRedistM
      NisqHat13PlusRedistUMInits<-NisqHat13PlusRedistUM
      NisqHat13ARedistMInits<-NisqHat13ARedistM
      NisqHat13ARedistUMInits<-NisqHat13ARedistUM
      NisqNat13PlusRedistMInits<-NisqNat13PlusRedistM
      NisqNat13PlusRedistUMInits<-NisqNat13PlusRedistUM
      NisqNat13ARedistMInits<-NisqNat13ARedistM
      NisqNat13ARedistUMInits<-NisqNat13ARedistUM
      McAllHat13PlusRedistMInits<-McAllHat13PlusRedistM
      McAllHat13PlusRedistUMInits<-McAllHat13PlusRedistUM
      McAllHat13ARedistMInits<-McAllHat13ARedistM
      McAllHat13ARedistUMInits<-McAllHat13ARedistUM
      McAllNat13PlusRedistMInits<-McAllNat13PlusRedistM
      McAllNat13PlusRedistUMInits<-McAllNat13PlusRedistUM
      McAllNat13ARedistMInits<-McAllNat13ARedistM
      McAllNat13ARedistUMInits<-McAllNat13ARedistUM
      DescHat13PlusRedistMInits<-DescHat13PlusRedistM
      DescHat13PlusRedistUMInits<-DescHat13PlusRedistUM
      DescHat13ARedistMInits<-DescHat13ARedistM
      DescHat13ARedistUMInits<-DescHat13ARedistUM
      Misc13Hat13PlusRedistMInits<-Misc13Hat13PlusRedistM
      Misc13Hat13PlusRedistUMInits<-Misc13Hat13PlusRedistUM
      Misc13Hat13ARedistMInits<-Misc13Hat13ARedistM
      Misc13Hat13ARedistUMInits<-Misc13Hat13ARedistUM

      #Write in input page
      TempNm<-Input_Page$Cells(62,11);TempNm[["Value"]] <-CarrMintHatHM
      TempNm<-Input_Page$Cells(62,12);TempNm[["Value"]] <-CarrMintHatHU
      TempNm<-Input_Page$Cells(62,13);TempNm[["Value"]] <-CarrMintHatNM
      TempNm<-Input_Page$Cells(62,14);TempNm[["Value"]] <-CarrMintHatNU
      TempNm<-Input_Page$Cells(63,11);TempNm[["Value"]] <-CarrMintNatHM
      TempNm<-Input_Page$Cells(63,12);TempNm[["Value"]] <-CarrMintNatHU
      TempNm<-Input_Page$Cells(63,13);TempNm[["Value"]] <-CarrMintNatNM
      TempNm<-Input_Page$Cells(63,14);TempNm[["Value"]] <-CarrMintNatNU
      TempNm<-Input_Page$Cells(64,11);TempNm[["Value"]] <-ChambersHatHM
      TempNm<-Input_Page$Cells(64,12);TempNm[["Value"]] <-ChambersHatHU
      TempNm<-Input_Page$Cells(64,13);TempNm[["Value"]] <-ChambersHatNM
      TempNm<-Input_Page$Cells(64,14);TempNm[["Value"]] <-ChambersHatNU
      TempNm<-Input_Page$Cells(65,11);TempNm[["Value"]] <-NisqHatHM
      TempNm<-Input_Page$Cells(65,12);TempNm[["Value"]] <-NisqHatHU
      TempNm<-Input_Page$Cells(65,13);TempNm[["Value"]] <-NisqHatNM
      TempNm<-Input_Page$Cells(65,14);TempNm[["Value"]] <-NisqHatNU
      TempNm<-Input_Page$Cells(66,11);TempNm[["Value"]] <-NisqNatHM
      TempNm<-Input_Page$Cells(66,12);TempNm[["Value"]] <-NisqNatHU
      TempNm<-Input_Page$Cells(66,13);TempNm[["Value"]] <-NisqNatNM
      TempNm<-Input_Page$Cells(66,14);TempNm[["Value"]] <-NisqNatNU
      TempNm<-Input_Page$Cells(67,11);TempNm[["Value"]] <-McAllHatHM
      TempNm<-Input_Page$Cells(67,12);TempNm[["Value"]] <-McAllHatHU
      TempNm<-Input_Page$Cells(67,13);TempNm[["Value"]] <-McAllHatNM
      TempNm<-Input_Page$Cells(67,14);TempNm[["Value"]] <-McAllHatNU
      TempNm<-Input_Page$Cells(68,11);TempNm[["Value"]] <-McAllNatHM
      TempNm<-Input_Page$Cells(68,12);TempNm[["Value"]] <-McAllNatHU
      TempNm<-Input_Page$Cells(68,13);TempNm[["Value"]] <-McAllNatNM
      TempNm<-Input_Page$Cells(68,14);TempNm[["Value"]] <-McAllNatNU
      TempNm<-Input_Page$Cells(69,11);TempNm[["Value"]] <-DescHatHM
      TempNm<-Input_Page$Cells(69,12);TempNm[["Value"]] <-DescHatHU
      TempNm<-Input_Page$Cells(69,13);TempNm[["Value"]] <-DescHatNM
      TempNm<-Input_Page$Cells(69,14);TempNm[["Value"]] <-DescHatNU
      TempNm<-Input_Page$Cells(70,11);TempNm[["Value"]] <-Misc13HatHM
      TempNm<-Input_Page$Cells(70,12);TempNm[["Value"]] <-Misc13HatHU
      TempNm<-Input_Page$Cells(70,13);TempNm[["Value"]] <-Misc13HatNM
      TempNm<-Input_Page$Cells(70,14);TempNm[["Value"]] <-Misc13HatNU

      #Grab from SPS pages
      CarrMintHat13PlusRedistM<-SPSmrkd_Page$Cells(20,45)[["Value"]]
      CarrMintHat13PlusRedistUM<-SPSunmrkd_Page$Cells(20,45)[["Value"]]
      CarrMintHat13ARedistM<-SPSmrkd_Page$Cells(20,46)[["Value"]]
      CarrMintHat13ARedistUM<-SPSunmrkd_Page$Cells(20,46)[["Value"]]
      CarrMintNat13PlusRedistM<-SPSmrkd_Page$Cells(21,45)[["Value"]]
      CarrMintNat13PlusRedistUM<-SPSunmrkd_Page$Cells(21,45)[["Value"]]
      CarrMintNat13ARedistM<-SPSmrkd_Page$Cells(21,46)[["Value"]]
      CarrMintNat13ARedistUM<-SPSunmrkd_Page$Cells(21,46)[["Value"]]
      ChambersHat13PlusRedistM<-SPSmrkd_Page$Cells(22,45)[["Value"]]
      ChambersHat13PlusRedistUM<-SPSunmrkd_Page$Cells(22,45)[["Value"]]
      ChambersHat13ARedistM<-SPSmrkd_Page$Cells(22,46)[["Value"]]
      ChambersHat13ARedistUM<-SPSunmrkd_Page$Cells(22,46)[["Value"]]
      NisqHat13PlusRedistM<-SPSmrkd_Page$Cells(23,45)[["Value"]]
      NisqHat13PlusRedistUM<-SPSunmrkd_Page$Cells(23,45)[["Value"]]
      NisqHat13ARedistM<-SPSmrkd_Page$Cells(23,46)[["Value"]]
      NisqHat13ARedistUM<-SPSunmrkd_Page$Cells(23,46)[["Value"]]
      NisqNat13PlusRedistM<-SPSmrkd_Page$Cells(24,45)[["Value"]]
      NisqNat13PlusRedistUM<-SPSunmrkd_Page$Cells(24,45)[["Value"]]
      NisqNat13ARedistM<-SPSmrkd_Page$Cells(24,46)[["Value"]]
      NisqNat13ARedistUM<-SPSunmrkd_Page$Cells(24,46)[["Value"]]
      McAllHat13PlusRedistM<-SPSmrkd_Page$Cells(25,45)[["Value"]]
      McAllHat13PlusRedistUM<-SPSunmrkd_Page$Cells(25,45)[["Value"]]
      McAllHat13ARedistM<-SPSmrkd_Page$Cells(25,46)[["Value"]]
      McAllHat13ARedistUM<-SPSunmrkd_Page$Cells(25,46)[["Value"]]
      McAllNat13PlusRedistM<-SPSmrkd_Page$Cells(26,45)[["Value"]]
      McAllNat13PlusRedistUM<-SPSunmrkd_Page$Cells(26,45)[["Value"]]
      McAllNat13ARedistM<-SPSmrkd_Page$Cells(26,46)[["Value"]]
      McAllNat13ARedistUM<-SPSunmrkd_Page$Cells(26,46)[["Value"]]
      DescHat13PlusRedistM<-SPSmrkd_Page$Cells(27,45)[["Value"]]
      DescHat13PlusRedistUM<-SPSunmrkd_Page$Cells(27,45)[["Value"]]
      DescHat13ARedistM<-SPSmrkd_Page$Cells(27,46)[["Value"]]
      DescHat13ARedistUM<-SPSunmrkd_Page$Cells(27,46)[["Value"]]
      Misc13Hat13PlusRedistM<-SPSmrkd_Page$Cells(28,45)[["Value"]]
      Misc13Hat13PlusRedistUM<-SPSunmrkd_Page$Cells(28,45)[["Value"]]
      Misc13Hat13ARedistM<-SPSmrkd_Page$Cells(28,46)[["Value"]]
      Misc13Hat13ARedistUM<-SPSunmrkd_Page$Cells(28,46)[["Value"]]

      #Recalc the abunds
      CarrMintHatHMNextStep<-CarrMintHatHM-CarrMintHat13PlusRedistMInits-CarrMintHat13ARedistMInits+CarrMintHat13PlusRedistM+CarrMintHat13ARedistM
      CarrMintHatHUNextStep<-CarrMintHatHU-CarrMintHat13PlusRedistUMInits-CarrMintHat13ARedistUMInits+CarrMintHat13PlusRedistUM+CarrMintHat13ARedistUM
      CarrMintHatNMNextStep<-0
      CarrMintHatNUNextStep<-0
      CarrMintNatHMNextStep<-0
      CarrMintNatHUNextStep<-0
      CarrMintNatNMNextStep<-0
      CarrMintNatNUNextStep<-0
      ChambersHatHMNextStep<-ChambersHatHM-ChambersHat13PlusRedistMInits-ChambersHat13ARedistMInits+ChambersHat13PlusRedistM+ChambersHat13ARedistM
      ChambersHatHUNextStep<-ChambersHatHU-ChambersHat13PlusRedistUMInits-ChambersHat13ARedistUMInits+ChambersHat13PlusRedistUM+ChambersHat13ARedistUM
      ChambersHatNMNextStep<-0
      ChambersHatNUNextStep<-0
      NisqHatHMNextStep<-NisqHatHM-NisqHat13PlusRedistMInits-NisqHat13ARedistMInits+NisqHat13PlusRedistM+NisqHat13ARedistM
      NisqHatHUNextStep<-NisqHatHU-NisqHat13PlusRedistUMInits-NisqHat13ARedistUMInits+NisqHat13PlusRedistUM+NisqHat13ARedistUM
      NisqHatNMNextStep<-0
      NisqHatNUNextStep<-0
      NisqNatHMNextStep<-0
      NisqNatHUNextStep<-0
      NisqNatNMNextStep<-0
      NisqNatNUNextStep<-NisqNatNU-NisqNat13PlusRedistUMInits-NisqNat13ARedistUMInits+NisqNat13PlusRedistUM+NisqNat13ARedistUM
      McAllHatHMNextStep<-McAllHatHM-McAllHat13PlusRedistMInits-McAllHat13ARedistMInits+McAllHat13PlusRedistM+McAllHat13ARedistM
      McAllHatHUNextStep<-McAllHatHU-McAllHat13PlusRedistUMInits-McAllHat13ARedistUMInits+McAllHat13PlusRedistUM+McAllHat13ARedistUM
      McAllHatNMNextStep<-0
      McAllHatNUNextStep<-0
      McAllNatHMNextStep<-0
      McAllNatHUNextStep<-0
      McAllNatNMNextStep<-0
      McAllNatNUNextStep<-0
      DescHatHMNextStep<-DescHatHM-DescHat13PlusRedistMInits-DescHat13ARedistMInits+DescHat13PlusRedistM+DescHat13ARedistM
      DescHatHUNextStep<-DescHatHU-DescHat13PlusRedistUMInits-DescHat13ARedistUMInits+DescHat13PlusRedistUM+DescHat13ARedistUM
      DescHatNMNextStep<-0
      DescHatNUNextStep<-0
      Misc13HatHMNextStep<-Misc13HatHM-Misc13Hat13PlusRedistMInits-Misc13Hat13ARedistMInits+Misc13Hat13PlusRedistM+Misc13Hat13ARedistM
      Misc13HatHUNextStep<-Misc13HatHU-Misc13Hat13PlusRedistUMInits-Misc13Hat13ARedistUMInits+Misc13Hat13PlusRedistUM+Misc13Hat13ARedistUM
      Misc13HatNMNextStep<-0
      Misc13HatNUNextStep<-0

      #Max Diff Check
      NextStepList <- c(CarrMintHatHMNextStep,CarrMintHatHUNextStep,CarrMintHatNMNextStep,CarrMintHatNUNextStep,CarrMintNatHMNextStep,CarrMintNatHUNextStep,CarrMintNatNMNextStep,CarrMintNatNUNextStep,ChambersHatHMNextStep,ChambersHatHUNextStep,ChambersHatNMNextStep,ChambersHatNUNextStep,NisqHatHMNextStep,NisqHatHUNextStep,NisqHatNMNextStep,NisqHatNUNextStep,NisqNatHMNextStep,NisqNatHUNextStep,NisqNatNMNextStep,NisqNatNUNextStep,McAllHatHMNextStep,McAllHatHUNextStep,McAllHatNMNextStep,McAllHatNUNextStep,McAllNatHMNextStep,McAllNatHUNextStep,McAllNatNMNextStep,McAllNatNUNextStep,DescHatHMNextStep,DescHatHUNextStep,DescHatNMNextStep,DescHatNUNextStep,Misc13HatHMNextStep,Misc13HatHUNextStep,Misc13HatNMNextStep,Misc13HatNUNextStep)
      CurrentStepList <- c(CarrMintHatHM,CarrMintHatHU,CarrMintHatNM,CarrMintHatNU,CarrMintNatHM,CarrMintNatHU,CarrMintNatNM,CarrMintNatNU,ChambersHatHM,ChambersHatHU,ChambersHatNM,ChambersHatNU,NisqHatHM,NisqHatHU,NisqHatNM,NisqHatNU,NisqNatHM,NisqNatHU,NisqNatNM,NisqNatNU,McAllHatHM,McAllHatHU,McAllHatNM,McAllHatNU,McAllNatHM,McAllNatHU,McAllNatNM,McAllNatNU,DescHatHM,DescHatHU,DescHatNM,DescHatNU,Misc13HatHM,Misc13HatHU,Misc13HatNM,Misc13HatNU)

      MaxDiff <- 0
      for (j in 1:length(NextStepList)){

        Diff <- 1-(NextStepList[j]/CurrentStepList[j])
        if(is.na(abs(Diff))==FALSE){
          if (abs(Diff)>MaxDiff){
            MaxDiff <- abs(Diff)
          }
        }
      }

    }

    #Updates input page values
    TempNm<-Input_Page$Cells(62,11);TempNm[["Value"]] <-CarrMintHatHMNextStep
    TempNm<-Input_Page$Cells(62,12);TempNm[["Value"]] <-CarrMintHatHUNextStep
    TempNm<-Input_Page$Cells(62,13);TempNm[["Value"]] <-CarrMintHatNMNextStep
    TempNm<-Input_Page$Cells(62,14);TempNm[["Value"]] <-CarrMintHatNUNextStep
    TempNm<-Input_Page$Cells(63,11);TempNm[["Value"]] <-CarrMintNatHMNextStep
    TempNm<-Input_Page$Cells(63,12);TempNm[["Value"]] <-CarrMintNatHUNextStep
    TempNm<-Input_Page$Cells(63,13);TempNm[["Value"]] <-CarrMintNatNMNextStep
    TempNm<-Input_Page$Cells(63,14);TempNm[["Value"]] <-CarrMintNatNUNextStep
    TempNm<-Input_Page$Cells(64,11);TempNm[["Value"]] <-ChambersHatHMNextStep
    TempNm<-Input_Page$Cells(64,12);TempNm[["Value"]] <-ChambersHatHUNextStep
    TempNm<-Input_Page$Cells(64,13);TempNm[["Value"]] <-ChambersHatNMNextStep
    TempNm<-Input_Page$Cells(64,14);TempNm[["Value"]] <-ChambersHatNUNextStep
    TempNm<-Input_Page$Cells(65,11);TempNm[["Value"]] <-NisqHatHMNextStep
    TempNm<-Input_Page$Cells(65,12);TempNm[["Value"]] <-NisqHatHUNextStep
    TempNm<-Input_Page$Cells(65,13);TempNm[["Value"]] <-NisqHatNMNextStep
    TempNm<-Input_Page$Cells(65,14);TempNm[["Value"]] <-NisqHatNUNextStep
    TempNm<-Input_Page$Cells(66,11);TempNm[["Value"]] <-NisqNatHMNextStep
    TempNm<-Input_Page$Cells(66,12);TempNm[["Value"]] <-NisqNatHUNextStep
    TempNm<-Input_Page$Cells(66,13);TempNm[["Value"]] <-NisqNatNMNextStep
    TempNm<-Input_Page$Cells(66,14);TempNm[["Value"]] <-NisqNatNUNextStep
    TempNm<-Input_Page$Cells(67,11);TempNm[["Value"]] <-McAllHatHMNextStep
    TempNm<-Input_Page$Cells(67,12);TempNm[["Value"]] <-McAllHatHUNextStep
    TempNm<-Input_Page$Cells(67,13);TempNm[["Value"]] <-McAllHatNMNextStep
    TempNm<-Input_Page$Cells(67,14);TempNm[["Value"]] <-McAllHatNUNextStep
    TempNm<-Input_Page$Cells(68,11);TempNm[["Value"]] <-McAllNatHMNextStep
    TempNm<-Input_Page$Cells(68,12);TempNm[["Value"]] <-McAllNatHUNextStep
    TempNm<-Input_Page$Cells(68,13);TempNm[["Value"]] <-McAllNatNMNextStep
    TempNm<-Input_Page$Cells(68,14);TempNm[["Value"]] <-McAllNatNUNextStep
    TempNm<-Input_Page$Cells(69,11);TempNm[["Value"]] <-DescHatHMNextStep
    TempNm<-Input_Page$Cells(69,12);TempNm[["Value"]] <-DescHatHUNextStep
    TempNm<-Input_Page$Cells(69,13);TempNm[["Value"]] <-DescHatNMNextStep
    TempNm<-Input_Page$Cells(69,14);TempNm[["Value"]] <-DescHatNUNextStep
    TempNm<-Input_Page$Cells(70,11);TempNm[["Value"]] <-Misc13HatHMNextStep
    TempNm<-Input_Page$Cells(70,12);TempNm[["Value"]] <-Misc13HatHUNextStep
    TempNm<-Input_Page$Cells(70,13);TempNm[["Value"]] <-Misc13HatNMNextStep
    TempNm<-Input_Page$Cells(70,14);TempNm[["Value"]] <-Misc13HatNUNextStep

    wb$Save()
    xlApp$Quit()
  } #end outer per-file for-loop

} #end function
