#' Access and download tables from Pandora
#'
#' See readme for more information.
#'
#' @param tab character vector. Names of tables
#' @param con database connection
#' @param cache logical. Should data be cached?
#' @param cache_dir character. Path to cache directory
#' @param cache_max_age numeric. Maximum age of cache in seconds
#'
#' @return connection, list of connections, data.frame or list of data.frames
#' 
#' @name get_data
NULL

#' @rdname get_data
#' @export
get_con <- function(tab = sidora.core::pandora_tables, con) {
  
  if (length(tab) != 1) {
    stop("[sidora.core] error: Select one valid PANDORA SQL table.")
  }
  
  # establish data connection
  if (tab %in% sidora.core::pandora_tables_restricted)
    my_con <- access_restricted_table(con, tab)
  else {
    my_con <- dplyr::tbl(con, tab)
  }

  # remove deleted objects  
  if ("Deleted" %in% colnames(my_con)) {
    my_con <- my_con %>%
      dplyr::filter(!!as.symbol("Deleted") == "false")
  }
  
  return(my_con)
}

#' @rdname get_data
#' @export
get_con_list <- function(tab = sidora.core::pandora_tables, con) {
  
  raw_list <- lapply(
    tab, function(cur_tab) {
      get_con(cur_tab, con)
    }
  )
  names(raw_list) <- tab
  
  return(raw_list)
}

#' @rdname get_data
#' @export
get_df <- function(
  tab = sidora.core::pandora_tables, con, 
  cache = T, cache_dir = tempdir(), cache_max_age = 24 * 60 * 60) {
  
  if (length(tab) != 1) {
    stop("[sidora.core] error: Select one valid PANDORA SQL table.")
  }
  
  # caching is activated
  if (cache) {
    if (!dir.exists(cache_dir)) { dir.create(cache_dir) }
    tab_cache_file <- file.path(cache_dir, paste0(tab, ".RData"))
    if (file.exists(tab_cache_file) & file.mtime(tab_cache_file) > (Sys.time() - cache_max_age)) {
      load(tab_cache_file)
    } else {
      this_tab <- core_tab_download(tab, con)
      save(this_tab, file = tab_cache_file)
    }
  # caching is not activated
  } else {
    this_tab <- core_tab_download(tab, con)
  }
  
  return(this_tab) 
}

#' @rdname get_data
#' @export
add_prefix_to_colnames <- function(x, prefix) {
  colnames(x) <- paste0(prefix, ".", colnames(x))
  return(x)
}

core_tab_download <- function(tab, con) {
  get_con(tab, con) %>% tibble::as_tibble() %>% enforce_types() %>% add_prefix_to_colnames(table2entity(tab))
}

#' @rdname get_data
#' @export
get_df_list <- function(
  tab = sidora.core::pandora_tables, con, 
  cache = T, cache_dir = tempdir(), cache_max_age = 24 * 60 * 60) {
  
  raw_list <- lapply(
    tab, function(cur_tab) {
      get_df(cur_tab, con, cache, cache_dir, cache_max_age)
    }
  )
  names(raw_list) <- tab
  
  return(raw_list)
}

#' access_restricted_table
#'
#' Some tables are restricted, e.g. the pandora_read user does not have access 
#' to certain columns. This function will use custom SQL queries to get all
#' useful (non-restricted) columns.
#'
#' @param con database connection
#' @param entity_id sidora table name of restricted tables (e.g. 'worker' etc.)
#'
#' @export
access_restricted_table <- function(con, entity_id){
  
  if ( !entity_id %in% sidora.core::pandora_tables_restricted )
    stop(paste0("[sidora.core] error: entity_id not found in restricted table list. Options: ",
               paste(sidora.core::pandora_tables_restricted, collapse = ","),
               ". Your selection: ", entity_id))
  
  ## Assumes con already generated
  if ( entity_id == "TAB_User" )
    dplyr::tbl(con, dbplyr::build_sql("SELECT Id, Name, Username FROM TAB_User", 
                                      con = con)) %>%
    dplyr::as_tibble() %>%
    add_prefix_to_colnames(table2entity(entity_id))
  
}
