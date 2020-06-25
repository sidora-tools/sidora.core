#' Enforce column types in a \strong{PANDORA table}
#'
#' See readme for more information.
#'
#' @param x data.frame (PANDORA table)
#' @param suppress_na_introduced_warnings logical. Suppress warnings caused by data removal in
#' type transformation due to unrecognised columns
#'
#' @return data.frame (PANDORA table) with correct column types
#' @export
enforce_types <- function(x, suppress_na_introduced_warnings = TRUE) {
  
  purrr::map2_df(
    x, 
    names(x), 
    .f = apply_var_types,
    suppress_na_introduced_warnings = suppress_na_introduced_warnings
  )
  
  return(x)
}

#### helpers ####

apply_var_types <- function(var_data, var_name, suppress_na_introduced_warnings) {
  res <- var_data
  # lookup type for variable in hash
  var_type <- lookup_var_types(var_name)
  # get trans function
  var_trans_function <- string_to_as(var_type)
  # transform variable, if trans function is available
  if (!is.null(var_trans_function)) {
    if (suppress_na_introduced_warnings) {
      withCallingHandlers({
        res <- var_trans_function(res) 
      }, warning = na_introduced_warning_handler
      )
    } else 
      res <- var_trans_function(res) 
  }
  return(res)
}

lookup_var_types <- function(var_names) {
  var_type <- rep(NA, length(var_names))
  # check which variables can be looked up
  var_in_hash <- var_names %in% hash::keys(hash_var_type)
  # lookup type for variable in hash
  var_type[var_in_hash] <- hash::values(hash_var_type, var_names[var_in_hash])
  return(unlist(var_type))
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
