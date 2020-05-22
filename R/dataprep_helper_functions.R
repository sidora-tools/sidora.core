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
    stop("[sidora.core] error: no entity type supplied.")
  }
    
  entity_map <- c(
    site = "TAB_Site",
    individual = "TAB_Individual",
    sample = "TAB_Sample",
    extract = "TAB_Extract",
    library = "TAB_Library",
    capture = "TAB_Capture",
    sequencing = "TAB_Sequencing_Sequencer",
    raw_data = "TAB_Raw_Data",
    sequencer = "TAB_Sequencer",
    tag = "TAB_Tag",
    project = "TAB_Project"
    worker = "TAB_Worker"
  )
  
  if (length(entity_type) > 0) {
    
    if (any(!entity_type %in% names(entity_map))) {
      stop(paste(
        "[sidora.core] error: at least one of your supplied names is not recognised. Options:", 
        paste(names(entity_map), collapse = ", "),
        sep = "\n"
      ))
    }
    
    return(unname(entity_map[entity_type]))
  }
  
  if (length(table_name) > 0) {
    
    if (any(!table_name %in% entity_map)) {
      stop(paste(
        "[sidora.core] error: at least one of your supplied names is not recognised. Options:", 
        paste(entity_map, collapse = ", "),
        sep = "\n"
      ))
    }
    
    return(names(entity_map)[entity_map %in% table_name])
  }
  
  return(result)
  
}

#' id2string
#'
#' Given a requested table and a 'Id' name, will get the requested corresponding 'Full_*_ID' string.
#'
#' @param con
#' @param entity_type a sidora table name (e.g. 'site', 'individual' etc.)
#' @param id the ID in the current table for which the 'string' version is requested
#' @param cache_dir
#'
#' @export

id2string <- function(con, entity_type, id, cache_dir){
  
  tab_info <- table2entity(entity_type)
  
  selected_table <- sidora.core::get_df(con, 
                                        tab = tab_info$pandora_table, 
                                        cache_dir = cache_dir)
  
  selected_table %>% dplyr::filter(Id = .data$id)
  
}
