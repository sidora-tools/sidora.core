#' format_table
#' 
#' This function takes a Sidora column-named table, and will re-format in 
#' various ways for saving in different contexts.
#' 
#' @param table a sidora table
#' @param format a type of format to convert to.
#' 
#' @examples
#' \dontrun{
#' sidora_table <- get_df("TAB_Site", con)
#' format_table(sidora_table, "pandora_update_existing")
#' }
#' 
#' @name format_table
#' @export

format_table <- function(sidora_table, format) {
  
  valid_formats <- c("pandora_update_existing")
  
  if (!format %in% valid_formats)
    stop(paste("[sidora.core] error: format_table() only accepts the following conversion formats:", paste(valid_formats, collapse = ", ")))
  
  if (format == "pandora_update_existing") {
    sidora.core::as_update_existing(sidora_table)
  }
}

#' as_update_existing
#' 
#' Converts a sidora table to a format that can be use with pandora table upload
#' interface
#' 
#' @param sidora_table a sidora table
#' 
#' @rdname as_update_existing
#' @export
as_update_existing <- function(sidora_table) {
  
  ## Find valid columns for uploading existing tables
  valid_cols_table_clean <- valid_cols_table <- hash::values(hash_pandora_col_name_update_type, colnames(sidora_table))
  names(valid_cols_table_clean) <- sidora.core::sidora_col_name_to_col_name(names(valid_cols_table_clean)) %>% gsub("_", " ", .)
  valid_cols_table_clean_mandatory <- names(valid_cols_table_clean[valid_cols_table_clean %in% "mandatory"])
  
  ## Clean up tables
  result <- sidora_table[, !is.na(valid_cols_table)]
  colnames(result) <- sidora_col_name_to_update_col_name(names(result))
  
  ## Add formatting for mandatory upload columns
  result %>% dplyr::rename_with(make_column_mandatory, valid_cols_table_clean_mandatory)
}

#' make_column_mandatory
#'
#' @param x column name to wrap with asterisks
make_column_mandatory <- function(x){
  gsub("^", "\\*", x) %>% gsub("$", "\\*", .)
}

#' sidora_col_name_to_update_col_name
#'
#' @param x sidora column name to be converted to Pandora upload existing data column
sidora_col_name_to_update_col_name <- function(x){
  sidora.core::sidora_col_name_to_col_name(x) %>% gsub("_", " ", .)
}