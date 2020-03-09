#' Establish connection to database table
#'
#' @param tab Name of table
#' @param con Database connection
#'
#' @return A table connection
#' @export
get_con <- function(tab = sidora.core::pandora_tables, con) {
  
  if (length(tab) != 1) {
    stop("Select one valid PANDORA SQL table.")
  }
  
  # establish data connection
  my_con <- dplyr::tbl(con, tab)

  # remove deleted objects  
  if ("Deleted" %in% colnames(my_con)) {
    my_con <- my_con %>%
      dplyr::filter(!!as.symbol("Deleted") == "false")
  }
  
  return(my_con)
}

#' Establish connections to multiple database tables
#'
#' @param tab Names of tables
#' @param con Database connection
#'
#' @return A list of table connections
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

#' Download table from database
#'
#' @param tab Name of table
#' @param con Database connection
#' @param cache Should data be cached?
#' @param cache_dir Path to cache directory
#' @param cache_max_age Maximum age of cache in seconds
#'
#' @return A dataframe
#' @export
get_df <- function(
  tab = sidora.core::pandora_tables, con, 
  cache = T, cache_dir = tempdir(), cache_max_age = 24 * 60 * 60) {
  
  if (length(tab) != 1) {
    stop("Select one valid PANDORA SQL table.")
  }
  
  # caching is activated
  if (cache) {
    tab_cache_file <- file.path(cache_dir, paste0(tab, ".RData"))
    if (file.exists(tab_cache_file) & file.mtime(tab_cache_file) > (Sys.time() - cache_max_age)) {
      load(tab_cache_file)
    } else {
      this_tab <- get_con(tab, con) %>% tibble::as_tibble() %>% enforce_types()
      save(this_tab, file = tab_cache_file)
    }
  # caching is not activated
  } else {
    this_tab <- get_con(tab, con) %>% tibble::as_tibble() %>% enforce_types()
  }
  
  return(this_tab) 
}

#' Download multiple tables from database
#'
#' @param tab Names of tables
#' @param con Database connection
#' @param cache Should data be cached?
#' @param cache_dir Path to cache directory
#' @param cache_max_age Maximum age of cache in seconds
#'
#' @return A list of dataframes
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
