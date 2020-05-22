#' convert_entity_table_name
#'
#' @param entity_type a valid entity type (e.g. site, sample, individual etc.)
#' @param table_name a valid table name (e.g. TAB_Site, TAB_Sample etc.)
#'
#' @rdname name_conversion
#' @export
entity2table <- function(entity_type) {
  convert_entity_table_name(entity_type = entity_type)
}

#' @rdname name_conversion
#' @export
table2entity <- function(table_name) {
  convert_entity_table_name(table_name = table_name)
}

#' @rdname name_conversion
#' @export
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
  
}
