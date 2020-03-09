#### enforce variable types ####

#' @name enforce_types
#' @title Enforce column types in a \strong{PANDORA table}
#'
#' @description Enforce variable types in a \strong{PANDORA table}
#'
#' @param x an object a PANDORA table
#' @param suppress_na_introduced_warnings suppress warnings caused by data removal in
#' type transformation due to unrecognised columns
#'
#' @return a PANDORA table
#' @export
#'
#' @examples
#' # initial situation
#'\dontrun{
#' ex <- get_df("TAB_Site", con)
#' 
#' # fix type with enforce_types()
# 'ex <- enforce_types(ex)
#'} 
#'

#' @rdname enforce_types
#' @export
enforce_types <- function(x, suppress_na_introduced_warnings = TRUE) {
  
  # define variable type lists - currently has site, sample individual, extract, library, capture, sequencing, analysis, analysis_result_string
  coltypes_integer <- c("Id", "Worker", "Files", "Protocol", "Batch", "Site", "Individual", "Individual_Id", "Organism", "C14_Uncalibrated", 
                        "C14_Uncalibrated_Variation", "C14_Calibrated_From", "C14_Calibrated_To", "Type_Group", "Type", "Location_Bone_Room",
                        "Location_Bone", "Location_Powder_Room", "Location_Powder", "Sample", "Extract", "Library_Id", "Index_Set", 
                        "Quantification_pre-Indexing_total", "Quantification_post-Indexing_total", "Post-Indexing_elution_volume",
                        "Capture", "Sequencing_Id", "Sequencer", "Setup", "Raw_Data", "Analysis", "Order")
  coltypes_date <- c("Creation_Date", "Deleted_Date", "Experiment_Date", "Library", "Probe_Set")
  coltypes_character <- c("Notes", "Tags", "Projects", "Contact_Person", "Position_on_Plate", "Location_Room", "Location", "Site_Id", 
                          "Full_Site_Id", "Name", "Locality", "Province", "Country", "Full_Individual_Id", "Owning_Institution", "Provenience",
                          "Archaeological_ID", "C14_Info", "C14_Id", "Ethics", "Individual", "Sample_Id", "Extract_Id", "Full_Extract_Id",
                          "Full_Library_Id", "P7_Barcode_Sequence", "P5_Barcode_Sequence", "P7_Index_Sequence", "P5_Index_Sequence", 
                          "P7_Index_Id", "P5_Index_Id", "External_Library_Id", "Position_on_Plate", "Capture_Id", "Full_Capture_Id",
                          "Full_Sequencing_Id", "Run_Id", "Single_Stranded", "Analysis_Id", "Full_Analysis_Id", "Result_Directory") ## single stranded is yes/no, can't force as logical
  coltypes_logical <- c("Deleted", "Ethically_culturally_sensitive", "Robot", "Title") ## Skipping Analysis String 'Result' as should be numeric but includes mixed cells
  coltypes_double <- c("Latitude", "Longitude", "Sampled_Quantity", "Quantity_Sample", "Quantity_Lysate", "Sampled_Quantity", 
                       "Quantity_Extract", "Efficiency_Factor", "Weight_Lane_1-4", "Weight_Lane_1", "Weight_Lane_2", "Weight_Lane_3",
                       "Weight_Lane_4", "Weight_Lane_5", "Weight_Lane_6", "Weight_Lange_7", "Weight_Lane_8")
  
  
  # transform (invalid values become NA)
  if (suppress_na_introduced_warnings) {
    withCallingHandlers({
      x <- x %>%
        dplyr::mutate_if(colnames(.) %in% coltypes_character, as.character) %>%
        dplyr::mutate_if(colnames(.) %in% coltypes_integer, as.integer) %>%
        dplyr::mutate_if(colnames(.) %in% coltypes_double, as.double) %>%
        dplyr::mutate_if(colnames(.) %in% coltypes_date, as.Date) %>%
        dplyr::mutate_if(colnames(.) %in% coltypes_logical, as.logical)
    },
    warning = na_introduced_warning_handler
    )
  } else {
    x <- x %>%
      dplyr::mutate_if(colnames(.) %in% coltypes_character, as.character) %>%
      dplyr::mutate_if(colnames(.) %in% coltypes_integer, as.integer) %>%
      dplyr::mutate_if(colnames(.) %in% coltypes_double, as.double) %>%
      dplyr::mutate_if(colnames(.) %in% coltypes_date, as.Date) %>%
      dplyr::mutate_if(colnames(.) %in% coltypes_logical, as.logical)
  }
  
  return(x)
}

#### helpers ####

na_introduced_warning_handler <- function(x) {
  if (any(
    grepl("NAs introduced by coercion", x)
  )) {
    invokeRestart("muffleWarning")
  }
}
