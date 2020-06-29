#' namecol_value_from_id
#'
#' Given a sidora column name and a 'Id' integer will get the 
#' requested corresponding 'human readable' string version of the Id.
#' 
#' For example, given the ID 38 and the information that this ID was found in 
#' 'extract.Batch', would result in Ex06_KE_2015-11-19
#'
#' @param sidora_col_name character. A sidora table column name
#' @param query_id integer vector. ID(s) to be converted to the human readable 'string' version
#' @param con a pandora connection
#' @param cache_dir a cache directory
#'
#' @examples
#' \dontrun{
#' namecol_value_from_id(sidora_col_name = "extract.Batch", query_id = 38, con = con)
#' }
#'
#' @export
namecol_value_from_id <- function(sidora_col_name, query_id, con, cache_dir) {
  
  # determine auxiliary table and auxiliary id and auxiliary namecol given the lookup column
  aux_table <- hash::values(hash_sidora_col_name_auxiliary_table, sidora_col_name)
  id_column <- hash::values(hash_entity_type_idcol, table_name_to_entity_type(aux_table))
  name_column <- hash::values(hash_sidora_col_name_auxiliary_namecol, sidora_col_name)
  
  # download the auxiliary table
  lookup_table <- get_df(aux_table, con = con, cache_dir = cache_dir)
  
  # do the lookup of the name column value given the id column value in the auxiliary table
  res_vector <- lookup_table[[name_column]][match(query_id, lookup_table[[id_column]])]
  
  # if lookup yields empty character then return input
  res_vector[res_vector == "" | is.na(res_vector)] <- query_id[res_vector == "" | is.na(res_vector)]
  
  return(res_vector)
  
}
