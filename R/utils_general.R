#' check_if_packages_are_available
#'
#' @param packages_ch packages that should be available
#'
#' @return NULL - called for side effect stop()
#'
#' @keywords internal
#' @noRd
check_if_packages_are_available <- function(packages_ch) {
  if (
    packages_ch %>%
    sapply(function(x) {requireNamespace(x, quietly = TRUE)}) %>%
    all %>% `!`
  ) {
    stop(
      paste0(
        "[sidora.core] error: R packages ",
        paste(packages_ch, collapse = ", "),
        " needed for this function to work. Please install with ",
        "install.packages(c('", paste(packages_ch, collapse = "', '"), "'))"
      ),
      call. = FALSE
    )
  }
}

#' Access field Pandora help tooltip information
#'
#' This functions allows you to call the 'tooltip' help/documentation message
#' present on the Pandora webpage for a given entry.
#'
#' @param tab character. Name of the table of the field of interest in
#'           "TAB_<table>" format. E.g. "TAB_Sample"
#' @param field character vector. Name of the field of interest. In Pandora
#'              format E.g. "Sampled_Quantity"
#' @param con database connection object
#'
#' @return help text of the given field
#' 
#' @name get_field_help
#' 
#' @export

get_field_help <- function(tab, field, con) {
  
  if ( !tab %in% sidora.core::pandora_tables ) {
    stop("[sidora.core] error: Select one valid PANDORA SQL table.")
    
  }
  
  if (!field %in% sidora.core::pandora_column_types$col_name ) {
    stop("[sidora.core] error: Pandora field name is not recognised.")
  }
  
  pandora_help <- sidora.core::get_df("TAB_Field_Comment", con)
  colnames(pandora_help) <- sidora_col_name_to_col_name(colnames(pandora_help))
  result <- pandora_help %>% 
    dplyr::filter(., .data$Table == tab & .data$Field == field) %>% 
    dplyr::pull(.data$Comment) 
  
  if ( length(result) < 1 ) { result = "Currently no help message for this field is available. Please complain on ~Pandora." }
    
  result
}
  
