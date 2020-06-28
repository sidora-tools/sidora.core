#' col_conversion
#' 
#' Simple helper functions to transform colnames and get around NSE issues with R. 
#' 
#' @param entity_type character. An entity type (e.g. site, sample, individual etc.)
#' @param col_name character. A pandora table column name (e.g. Full_Site_Id, Id, etc.)
#' @param sidora_col_name character. A sidora table column name that includes the entity_type
#' (e.g. site.Full_Site_Id, batch.Id, etc.)
#' @param x character
#' @param prefix character
#' 
#' @name col_conversion
NULL

#' @rdname col_conversion
#' @export
sidora_col_name_to_col_name <- function(sidora_col_name) {
  gsub("^.*\\.", "", sidora_col_name)
}

#' @rdname col_conversion
#' @export
col_name_to_sidora_col_name <- function(entity_type, col_name) {
  paste0(entity_type, ".", col_name)
}

#' @rdname col_conversion
#' @export
sidora_col_name_to_name <- function(sidora_col_name) { 
  as.name(sidora_col_name) 
}

#' @rdname col_conversion
#' @export
col_name_to_name <- function(entity_type, col_name) { 
  as.name(col_name_to_sidora_col_name(entity_type, col_name)) 
}

#' @rdname col_conversion
#' @export
add_prefix_to_colnames <- function(x, prefix) {
  colnames(x) <- paste0(prefix, ".", colnames(x))
  return(x)
}
