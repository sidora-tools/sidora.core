#' get_namecol_from_entity
#'
#' This gets the column of a given table, that contains the human-readable 'name' 
#' columns that will correspond to a numeric PANDORA ID.
#'  
#'
#' @param entity_type a valid entity type (e.g. site, sample, individual etc.)
#'
#' @export
get_namecol_from_entity <- function(entity_type) {
  
  selected_tables <- entity2table(entity_type)
  
  if ( !selected_tables %in% names(sidora.core::id_2_name_map) ) {
    stop(paste(
      "[sidora.core] error: supplied PANDORA table name not recognised Options:", 
      paste(names(id_2_name_map), collapse = ", "),
      sep = "\n"
    ))  
  }
  
  paste0(entity_type, ".", unname(sidora.core::id_2_name_map[selected_tables]))
  
}

#' name_conversion
#' 
#' These functions converts a sidora entity type (e.g. site) to the 
#' corresponding PANDORA API table name (e.g. 'TAB_Site') and vice versa.
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

#' get_name_from_id
#'
#' Given a requested table, 'Id' column and a 'Id' integer will get the 
#' requested corresponding 'human readable' string version of the Id.
#' 
#' For example, given the.Batch ID 37 from the 'extract' sidora table, would 
#' result in Ex06_KE_2015-11-19
#'
#' @param con a pandora connection
#' @param query_tab a sidora table name (e.g. 'site', 'individual' etc.)
#' @param query_col the column that that a pandora numeric Id to be converted is in
#' @param query_id a vector of pandora numeric Id(s) to be converted to the human readable 'string' version
#' @param cache_dir a cache directory
#'
#' @examples
#' 
#' get_name_from_id(con = con, query_tab = "extract", query_col = "extract.Batch", query_id = 37)
#'
#' @export

get_name_from_id <- function(con, query_tab, query_col, query_id, cache_dir) {
  
  ## Find which auxilary table 'col' is from, and sidora entity_types and id/name cols
  aux_tab <- sidora.core::auxtablelookup[sub(paste0(query_tab, "."), "", query_col)]
  aux_entity <- sidora.core::table2entity(aux_tab)
  aux_id_col <- sidora.core::str_to_colname(aux_entity, "Id")
  aux_name_col <- sidora.core::get_namecol_from_entity(aux_entity)
  query_id <- as.numeric(query_id)
  
  ## Now filter this to the requested ID number, and extract corresponding na(query_id)me
  selected_tab <- sidora.core::get_df(con = con, aux_tab, cache_dir = cache_dir)
  
  if (length(aux_name_col) > 1 || is.na(aux_name_col) ) {
    stop(paste0("[sidora.core] error: Two or no possible columns for name string look up were not found. Please report to the sidora-tools team. Cols:", aux_name_col))
  }

  ## Report names in order
  result <- selected_tab[[as.character(aux_name_col)]][match(query_id, selected_tab[[as.character(aux_id_col)]])]

  ## Check the ID(s) actually exists
  if (length(result) == 0) {
    stop(paste0("[sidora.core] error: Requested Id from ", query_col," was not found. Name string could not be resolved"))
  } else {
    return(result)
  }
}

#' is_sidoracol_auxid
#' 
#' Provides logical value whether a given sidora column name is a valid
#' 'Id' column that can be used for look-up in auxiliary tables 
#' 
#' @param entity_type a given sidora table of the column to be searched
#' @param col_name a sidora table column to be checked whether it is an numeric 'Id' column can be looked up in auxilary tables 
#' 
#' @export

is_sidoracol_auxid <- function(entity_type, col_name) {
  cleaned_col <- gsub(paste0(entity_type, "."), "", as.character(col_name))
  cleaned_col %in% names(sidora.core::auxtablelookup)
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