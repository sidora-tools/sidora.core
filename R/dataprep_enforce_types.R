#' Enforce column types in a \strong{PANDORA table}
#'
#' @param x data.frame (PANDORA table)
#' @param suppress_na_introduced_warnings logical. Suppress warnings caused by data removal in
#' type transformation due to unrecognised columns
#'
#' @return data.frame (PANDORA table) with correct column types
#' 
#' @keywords internal
#' @noRd
enforce_types <- function(x, suppress_na_introduced_warnings = TRUE) {
  
<<<<<<< HEAD
  purrr::map2_df(
    x, 
    names(x), 
    .f = apply_col_types,
    suppress_na_introduced_warnings = suppress_na_introduced_warnings
  )
  
=======
  # define variable type lists - currently has site, sample individual, extract, library, capture, sequencing, analysis, analysis_result_string
  coltypes_integer <- c("Id", "Worker", "Files", "Protocol", "Batch", "Site", "Individual", "Individual_Id", "Organism", "C14_Uncalibrated", 
                        "C14_Uncalibrated_Variation", "C14_Calibrated_From", "C14_Calibrated_To", "Type_Group", "Type", "Location_Bone_Room",
                        "Location_Bone", "Location_Powder_Room", "Location_Powder", "Sample", "Extract", "Library_Id", "Index_Set", 
                        "Quantification_pre-Indexing_total", "Quantification_post-Indexing_total", "Post-Indexing_elution_volume",
                        "Capture", "Sequencing_Id", "Sequencer", "Setup", "Raw_Data", "Analysis", "Order", "Probe_Set", "Library")
  coltypes_date <- c("Creation_Date", "Deleted_Date", "Experiment_Date")
  coltypes_character <- c("Notes", "Tags", "Projects", "Contact_Person", "Position_on_Plate", "Location_Room", "Location", "Site_Id", 
                          "Full_Site_Id", "Name", "Locality", "Province", "Country", "Full_Individual_Id", "Owning_Institution", "Provenience",
                          "Archaeological_ID", "C14_Info", "C14_Id", "Ethics", "Individual", "Sample_Id", "Extract_Id", "Full_Extract_Id",
                          "Full_Library_Id", "P7_Barcode_Sequence", "P5_Barcode_Sequence", "P7_Index_Sequence", "P5_Index_Sequence", 
                          "P7_Index_Id", "P5_Index_Id", "External_Library_Id", "Position_on_Plate", "Capture_Id", "Full_Capture_Id",
                          "Full_Sequencing_Id", "Run_Id", "Single_Stranded", "Analysis_Id", "Full_Analysis_Id", "Result_Directory")
  coltypes_logical <- c("Deleted", "Title") ## Skipping Analysis String 'Result' as should be numeric but includes mixed cells
  coltypes_yesno_logical <- c("Ethically_culturally_sensitive", "Robot")
  coltypes_double <- c("Latitude", "Longitude", "Sampled_Quantity", "Quantity_Sample", "Quantity_Lysate", "Sampled_Quantity", 
                       "Quantity_Extract", "Efficiency_Factor", "Weight_Lane_1-4", "Weight_Lane_1", "Weight_Lane_2", "Weight_Lane_3",
                       "Weight_Lane_4", "Weight_Lane_5", "Weight_Lane_6", "Weight_Lange_7", "Weight_Lane_8")
  
  ## convert known Yes/No columns to logical because R doesn't recognise former, 
  ## then enforce types for faster filtering. Invalid values become NA.
  if (suppress_na_introduced_warnings) {
    withCallingHandlers({
      x <- x %>%
        dplyr::mutate_if(colnames(.) %in% coltypes_character, as.character) %>%
        dplyr::mutate_if(colnames(.) %in% coltypes_integer, as.integer) %>%
        dplyr::mutate_if(colnames(.) %in% coltypes_double, as.double) %>%
        dplyr::mutate_if(colnames(.) %in% coltypes_date, as.Date) %>%
        dplyr::mutate_if(colnames(.) %in% coltypes_logical, as.logical) %>%
        dplyr::mutate_if(colnames(.) %in% coltypes_yesno_logical, as.yesno_logical)
    },
    warning = na_introduced_warning_handler
    )
  } else {
    x <- x %>%
      dplyr::mutate_if(colnames(.) %in% coltypes_character, as.character) %>%
      dplyr::mutate_if(colnames(.) %in% coltypes_integer, as.integer) %>%
      dplyr::mutate_if(colnames(.) %in% coltypes_double, as.double) %>%
      dplyr::mutate_if(colnames(.) %in% coltypes_date, as.Date) %>%
      dplyr::mutate_if(colnames(.) %in% coltypes_logical, as.logical) %>%
      dplyr::mutate_if(colnames(.) %in% coltypes_yesno_logical, as.yesno_logical)
  }
  
  return(x)
>>>>>>> master
}

#### helpers ####

apply_col_types <- function(col_data, col_name, suppress_na_introduced_warnings) {
  res <- col_data
  # lookup type for variable in hash
  col_type <- lookup_col_types(col_name)
  # get trans function
  col_trans_function <- string_to_as(col_type)
  # transform variable, if trans function is available
  if (!is.null(col_trans_function)) {
    if (suppress_na_introduced_warnings) {
      withCallingHandlers({
        res <- col_trans_function(res) 
      }, warning = na_introduced_warning_handler
      )
    } else 
      res <- col_trans_function(res) 
  }
  return(res)
}

lookup_col_types <- function(col_names) {
  col_type <- rep(NA, length(col_names))
  # check which variables can be looked up
  col_in_hash <- col_names %in% hash::keys(hash_sidora_col_name_col_type)
  # lookup type for variable in hash
  col_type[col_in_hash] <- hash::values(hash_sidora_col_name_col_type, col_names[col_in_hash])
  return(unlist(col_type))
}

string_to_as <- function(x) {
  switch(
    x,
    "integer" = as.integer,
    "double" = as.numeric,
    "factor" = as.factor,
    "logical" = as.logical,
    "character" = as.character,
    NA
  )
}

na_introduced_warning_handler <- function(x) {
  if (any(
    grepl("NAs introduced by coercion", x)
  )) {
    invokeRestart("muffleWarning")
  }
}

as.yesno_logical <- function(x) {
  x == "Yes"
}
