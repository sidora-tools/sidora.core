<<<<<<< HEAD
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
=======
#' Name conversion functions and lookup helpers
#' 
#' Convert Pandora entity type (e.g. "site", "sample", "individual" etc.) to 
#' Pandora table names (e.g. "TAB_Site", "TAB_Sample" etc.) and vice versa with
#' \code{entity2table} and \code{table2entity}. \cr\cr
#' Also look up id/name columns of entity types with \code{get_namecol_from_entity}.
#'
#' @param entity_type character. A valid entity type (e.g. "site", "sample", "individual" etc.)
#' @param table_name character. A valid table name (e.g. "TAB_Site", "TAB_Sample" etc.)
#' 
#' @name name_conversion
NULL

#' @rdname name_conversion
>>>>>>> master
#' @export
sidora_col_name_to_name <- function(sidora_col_name) { 
  as.name(sidora_col_name) 
}

#' @rdname col_conversion
#' @export
col_name_to_name <- function(entity_type, col_name) { 
  as.name(col_name_to_sidora_col_name(entity_type, col_name)) 
}

<<<<<<< HEAD
#' @rdname col_conversion
#' @export
add_prefix_to_colnames <- function(x, prefix) {
  colnames(x) <- paste0(prefix, ".", colnames(x))
  return(x)
=======
convert_entity_table_name <- function(entity_type = c(), table_name = c()) {
  
  if (length(entity_type) == 0 & length(table_name) == 0) {
    stop("[sidora.cli] error: no entity type supplied.")
  }
    
  entity_map <- c(
    site = "TAB_Site",
    individual = "TAB_Individual",
    sample = "TAB_Sample",
    extract = "TAB_Extract",
    library = "TAB_Library",
    capture = "TAB_Capture",
    sequencing = "TAB_Sequencing",
    raw_data = "TAB_Raw_Data",
    sequencer = "TAB_Sequencer",
    tag = "TAB_Tag",
    project = "TAB_Project"
  )
  
  if (length(entity_type) > 0) {
    
    if (any(!entity_type %in% names(entity_map))) {
      stop(paste(
        "At least one of your supplied names is not recognised. Options:", 
        paste(names(entity_map), collapse = ", "),
        sep = "\n"
      ))
    }
    
    return(unname(entity_map[entity_type]))
  }
  
  if (length(table_name) > 0) {
    
    if (any(!table_name %in% entity_map)) {
      stop(paste(
        "At least one of your supplied names is not recognised. Options:", 
        paste(entity_map, collapse = ", "),
        sep = "\n"
      ))
    }
    
    return(names(entity_map)[entity_map %in% table_name])
  }
  
>>>>>>> master
}

#' @rdname name_conversion
#' @export
get_namecol_from_entity <- function(entity_type) {
  
  selected_tables <- entity2table(entity_type)
  
  id_col_map <- c(
    TAB_Site = "Full_Site_Id",
    TAB_Individual = "Full_Individual_Id",
    TAB_Sample = "Full_Sample_Id",
    TAB_Extract = "Full_Extract_Id",
    TAB_Library = "Full_Library_Id",
    TAB_Capture  = "Full_Capture_Id",
    TAB_Sequencing = "Full_Sequencing_Id",
    TAB_Raw_Data = "Full_Raw_Data_Id",
    TAB_Sequencer = "Name",
    TAB_Tag = "Name",
    TAB_Project = "Name"
  )
  
  return(paste0(entity_type, ".", unname(id_col_map[selected_tables])))
  
}
