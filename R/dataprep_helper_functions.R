#' get_namecol_from_entity
#'
#' @param entity_type a valid entity type (e.g. site, sample, individual etc.)
#'
#' @export
get_namecol_from_entity <- function(entity_type) {
  
  selected_tables <- entity2table(entity_type)

  
    
  return(paste0(entity_type, ".", unname(sidora.core::id_2_name_map[selected_tables])))
  
}

#' name_conversion
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
    
  entity_map <- sidora.core::entity_map
  
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
  
}

#' id2string
#'
#' Given a requested table and a 'Id' name, will get the requested corresponding 'Full_*_ID' string.
#'
#' @param con a pandora connection
#' @param entity_type a sidora table name (e.g. 'site', 'individual' etc.)
#' @param id the ID in the current table for which the 'string' version is requested
#' @param cache_dir a cache directory
#'
#' @export

id2string <- function(con, entity_type, id, cache_dir){
  
  tab_info <- convert_entity_table_name(entity_type)
  
  selected_table <- sidora.core::get_df(con, 
                                        tab = tab_info, 
                                        cache_dir = cache_dir)
  
  selected_table %>% dplyr::filter(!!str_to_colname(entity_type, "Id") == id) %>%
    dplyr::select(get_namecol_from_entity(entity_type)) %>%
    dplyr::pull(.)
}

#' col_conversion
#' 
#' Simple helper function to get around NSE issues with R.
#'  
#' Converts a table/column selection into a usable Sidora column object for
#' selecting columns by column name in a tibble.
#' 
#' @param entity_type the table name in sidora format the requested column is derived from 
#' @param col the column name to be selected
#' 
#' @rdname col_conversion
#' @export
str_to_colname <- function(entity_type, col) { 
  as.name(paste0(entity_type, ".", col)) 
  }

#' 