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
namecol_value_from_id <- function(sidora_col_name, query_id, con, cache_dir = tempdir()) {

  if (!any(is.integer(query_id))) {
    stop(paste("[sidora.core] error in function namecol_value_from_id()! query_id parameter must be an integer. Sidora column:", sidora_col_name))
  }
  
  # determine auxiliary table and auxiliary id and auxiliary namecol given the lookup column
  aux_table <- hash::values(hash_sidora_col_name_auxiliary_table, sidora_col_name)
  id_column <- hash::values(hash_entity_type_idcol, table_name_to_entity_type(aux_table))
  name_column <- hash::values(hash_sidora_col_name_auxiliary_namecol, sidora_col_name)
  
  # download the auxiliary table
  lookup_table <- get_df(aux_table, con = con, cache_dir = cache_dir)
  
  # do the lookup of the name column value given the id column value in the auxiliary table
  res_vector <- lookup_table[[name_column]][match(query_id, lookup_table[[id_column]])]
  
  # if lookup yields empty character then return input
  res_vector[is.na(res_vector)] <- query_id[is.na(res_vector)]
  
  return(res_vector)
  
}

#' convert_all_ids_to_values
#'
#' A convenience function which simply transforms a given Pandora-Dataframe using all
#' defined default lookups. Typically will convert a pandora back-end numeric ID to a 'human readable string' actually displayed on the pandora webpage.
#' 
#' @param df data.frame. A Sidora/Pandora-Dataframe with sidora column names.
#' 
#' @return The converted dataframe with lookup-columns replaced by the actual values.
#'
#'
#' @export
convert_all_ids_to_values <- function(df) {
  cols2update <- names(df[sidora.core::sidora_col_name_has_aux(names(df))])
  return (df %>% 
            dplyr::mutate(
              dplyr::across(tidyselect::all_of(cols2update),
                            ~namecol_value_from_id(con = con, sidora_col_name = dplyr::cur_column(), query_id = .x)
              )
            )
  )
}
