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
  
  purrr::map2_df(
    x, 
    names(x), 
    .f = apply_col_types,
    suppress_na_introduced_warnings = suppress_na_introduced_warnings
  )
  
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
    "yesno_logical" = yesno_logical_to_logical,
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

yesno_logical_to_logical <- function(x) {
  tolower(x) == "yes"
}
