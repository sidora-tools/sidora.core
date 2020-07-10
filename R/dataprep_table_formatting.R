#' as_update_existing
#' 
#' Converts a sidora table to a format that can be use with pandora table upload
#' interface
#' 
#' @examples
#' \dontrun{
#' sidora_table <- get_df("TAB_Site", con)
#' format_as_update_existing(sidora_table,)
#' }
#' 
#' @param sidora_table a sidora table
#' 
#' @rdname format_as_update_existing
#' @export
format_as_update_existing <- function(sidora_table) {
  
  ## Find valid columns for uploading existing tables
  valid_cols_table_clean <- valid_cols_table <- hash::values(hash_pandora_col_name_update_type, colnames(sidora_table))
  names(valid_cols_table_clean) <- sidora_col_name_to_update_col_name(names(valid_cols_table_clean))
  valid_cols_table_clean_mandatory <- names(valid_cols_table_clean[valid_cols_table_clean %in% "mandatory"])
  
  ## For upload 'Full_*_Id' column isn't used, but just '_Id', which here is a 
  ## numeric value . We will replace the latter with the former here for export
  ## QUESTION maybe put as data object? But will never be used other than here
  name_map <- c(individual.Full_Individual_Id = "individual.Individual_Id", 
                sample.Full_Sample_Id = "sample.Sample_Id", 
                extract.Full_Extract_Id = "extract.Extract_Id", 
                library.Full_Library_Id = "library.Library_Id", 
                capture.Full_Capture_Id = "capture.Capture_Id", 
                sequencing.Full_Sequencing_Id = "sequencing.Sequencing_Id", 
                raw_data.Full_Raw_Data_Id = "raw_data.Raw_Data_Id"
                )
  
  string_col <- name_map[names(sidora_table)[names(sidora_table) %in% names(name_map)]]
  sidora_table[string_col] <- sidora_table[names(string_col)]
  
  ## Clean up tables, subsetting and fixing column types when necessary
  result <- sidora_table[, !is.na(valid_cols_table)] %>% fix_logical_update_existing()
  colnames(result) <- sidora_col_name_to_update_col_name(names(result))
  
  # Add formatting for mandatory upload columns and ensure all columns written
  # as displayed (particularly to prevent datetime saving with TZ info)
  result %>% 
    dplyr::rename_with(make_column_mandatory, valid_cols_table_clean_mandatory) %>%
    dplyr::mutate(dplyr::across(tidyselect::everything(), as.character))
}

#' make_column_mandatory
#' 
#' For 'batch' uploading to update entries using the Pandora webpage, certain 
#' columns are mandatory. These are indicated in the header with asterisks. 
#' This function wraps a column name in the asterisks.
#' 
#' e.g. \*Sample_Id\* ,Archaeological ID,<...> where the first column must be 
#' supplied and the second not.
#'
#' @param x column name to wrap with asterisks
make_column_mandatory <- function(x){
  gsub("^", "\\*", x) %>% gsub("$", "\\*", .)
}

#' fix_logical_update_existing
#' 
#' Sidora converts on data download 'Yes/No' columns to logical column types 
#' for faster R processing. This converts these back, and also replaces 
#' non-Sample level ethically sensitive columns back to the dummy '0' data.
#' 
#' @param sidora_table column name to wrap with asterisks

fix_logical_update_existing <- function(sidora_table){
  
  if (any(grepl("Robot", colnames(sidora_table)))) {
    sidora_table <- sidora_table %>% dplyr::mutate(dplyr::across(dplyr::contains(".Robot"), function(x) gsub(F, "No", x) %>% gsub(T, "Yes", .)))
  }
  
  if ("sample.Ethically_culturally_sensitive" %in% names(sidora_table)) {
    result <- sidora_table %>% 
      dplyr::mutate(dplyr::across(dplyr::contains(c("sample", ".Ethically_culturally_sensitive")), function(x) gsub(F, "No", x) %>% gsub(T, "Yes", .)))
  } else {
    result <- sidora_table %>%
      dplyr::mutate(dplyr::across(dplyr::contains(c(".Ethically_culturally_sensitive")), function(x){return(0)}))
  }
  return(result)
}

#' sidora_col_name_to_update_col_name
#'
#' Reverts sidora-added underscores to spaces ni column names for pandora 
#' updating
#'
#' @param x sidora column name to be converted to Pandora upload existing data column
sidora_col_name_to_update_col_name <- function(x){
  sidora.core::sidora_col_name_to_col_name(x) %>% gsub("_", " ", .)
}

