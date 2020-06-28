#' Conversion and lookup functions
#' 
#' These functions convert names and allow to look up specific columns.
#' 
#' @param entity_type character. An entity type (e.g. site, sample, individual etc.)
#' @param table_name character. A table name (e.g. TAB_Site, TAB_Sample etc.)
#' @param col_name character. A pandora table column name (e.g. Full_Site_Id, Id, etc.)
#' @param sidora_col_name character. A sidora table column name that includes the entity_type
#' (e.g. site.Full_Site_Id, batch.Id, etc.)
#'
#' @rdname conversion_and_lookup
#' @export
entity_type_to_table_name <- function(entity_type) {
  
  if (length(entity_type) == 0) {
    stop("[sidora.core] error: no entity type supplied.")
  }
  
  if (any(!entity_type %in% hash::keys(hash_entity_type_table_name))) {
    stop(paste(
      "[sidora.core] error: at least one of your supplied names is not recognised. Options:", 
      paste(hash::keys(hash_entity_type_table_name), collapse = ", "),
      sep = "\n"
    ))
  }
  
  hash::values(hash_entity_type_table_name, entity_type)
  
}

#' @rdname conversion_and_lookup
#' @export
table_name_to_entity_type <- function(table_name) {
  
  if (length(table_name) == 0) {
    stop("[sidora.core] error: no entity type supplied.")
  }
  
  if (any(!table_name %in% hash::keys(hash_table_name_entity_type))) {
    stop(paste(
      "[sidora.core] error: at least one of your supplied names is not recognised. Options:", 
      paste(hash::keys(hash_table_name_entity_type), collapse = ", "),
      sep = "\n"
    ))
  }
  
  hash::values(hash_table_name_entity_type, table_name)
  
}

#' @rdname conversion_and_lookup
#' @export
namecol_for_entity_type <- function(entity_type) {
  
  if (length(entity_type) == 0) {
    stop("[sidora.core] error: no entity type supplied.")
  }
  
  if (any(!entity_type %in% hash::keys(hash_entity_type_namecol))) {
    stop(paste(
      "[sidora.core] error: at least one of your supplied names is not recognised. Options:", 
      paste(hash::keys(hash_entity_type_namecol), collapse = ", "),
      sep = "\n"
    ))
  }
  
  hash::values(hash_entity_type_namecol, entity_type)
  
}

#' @rdname conversion_and_lookup
#' @export
idcol_for_entity_type <- function(entity_type) {
  
  if (length(entity_type) == 0) {
    stop("[sidora.core] error: no entity type supplied.")
  }
  
  if (any(!entity_type %in% hash::keys(hash_entity_type_idcol))) {
    stop(paste(
      "[sidora.core] error: at least one of your supplied names is not recognised. Options:", 
      paste(hash::keys(hash_entity_type_idcol), collapse = ", "),
      sep = "\n"
    ))
  }
  
  hash::values(hash_entity_type_idcol, entity_type)
  
}

#' @rdname conversion_and_lookup
#' @export
col_name_has_aux <- function(entity_type, col_name) {
  sidora_col_name_has_aux(col_name_to_sidora_col_name(entity_type, col_name))
}

#' @rdname conversion_and_lookup
#' @export
sidora_col_name_has_aux <- function(sidora_col_name) {
  sidora_col_name %in% hash::keys(hash_sidora_col_name_auxiliary_table)
}




