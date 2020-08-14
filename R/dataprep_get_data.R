#' Access and download tables from Pandora
#'
#' You can access individual tables either by establishing a DBI connection 
#' (\code{get_con()}) to them or by downloading them as a data.frame (\code{get_df()}). 
#' You'll probably not need the former, which is only relevant if you want to 
#' interact with the database server directly. \code{get_df()} does three additional 
#' things: It transforms the columns of the downloaded table to the correct data 
#' type (with \code{enforce_types()}), it adds a table name prefix to each column name
#' and it caches the downloaded table locally. The default is a per-R-session 
#' cache, but you can cache more permanently by changing the \code{cache_dir} 
#' and \code{cache_max_age} parameters.\cr\cr
#' You can download multiple tables at once with \code{get_con_list()} and 
#' \code{get_df_list()}, which return a named list of objects. The latter again 
#' includes the additional transformation and caching features. \cr\cr
#' Some tables are restricted, i.e. the Pandora read user does not have access 
#' to certain columns. \code{access_restricted_table()} allows you to get the open
#' (non-restricted) columns of these tables.
#' TAB_Analysis is stored a little awkwardly in Pandora and we do a pre-joining operation
#' with \code{access_prejoined_data()} to access its content. 
#' Both \code{access_restricted_table()} and \code{access_prejoined_data()} are called 
#' automatically if you try to access the relevant tables with \code{get_con()} or 
#' \code{get_df()}, so you usually do not have to call them explicitly.
#'
#' @param tab character vector. Names of tables
#' @param con database connection object
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
  if (tab %in% sidora.core::pandora_tables_restricted) {
    my_con <- access_restricted_table(tab, con)
  } else if (tab %in% sidora.core::pandora_tables_prejoin) {
    my_con <- access_prejoined_data(tab, con)
  } else {
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
  
  if ( any(!tab %in% sidora.core::pandora_tables_all) )
    stop(paste0("[sidora.core] error: tab not found in available tables. Options: ",
                paste(sidora.core::pandora_tables_all, collapse = " ,"),
                ". Your selection: ", tab))
  
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

core_tab_download <- function(tab, con) {
  get_con(tab, con) %>% tibble::as_tibble() %>% add_prefix_to_colnames(table_name_to_entity_type(tab)) %>% enforce_types()
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

#' @rdname get_data
#' @export
access_restricted_table <- function(tab, con){

  if ( any(!tab %in% sidora.core::pandora_tables_restricted) ) {
    stop(
      paste0(
        "[sidora.core] error: tab not found in restricted table list. Options: ",
        paste(sidora.core::pandora_tables_restricted, collapse = ","),
        ". Your selection: ", tab
      )
    )
  }
  
  ## Assumes con already generated
  if ( tab == "TAB_User" ) {
    dplyr::tbl(
      con, 
      dbplyr::build_sql("SELECT Id, Name, Username FROM TAB_User", con = con)
    )
  }

}


#' @rdname get_data
#' @export
access_prejoined_data <- function(tab, con){
  
  if ( any(!tab %in% sidora.core::pandora_tables_prejoin) ) {
    stop(
      paste0(
        "[sidora.core] error: tab not found in requires prejoining table list. Options: ",
        paste(sidora.core::pandora_tables_prejoin, collapse = ","),
        ". Your selection: ", tab
      )
    )
  }
  
  ## Assumes con already generated
  if ( tab == "TAB_Analysis" ) {
    
    message("[sidora.core] loading analysis may take a while, please be patient.")
    
    # get connections to both tables
    ana_ids <- dplyr::tbl(con, tab)
    ana_res <- dplyr::tbl(con, "TAB_Analysis_Result_String")
    
    # do join operation
    dplyr::left_join(
      ana_ids, 
      ana_res, 
      by = c("Id" = "Analysis"),
    ) %>%
    # rename Id columns (after join for performance reasons!)  
    dplyr::rename(
      Id = .data[["Id.x"]],
      String_Id = .data[["Id.y"]]
    )
  }
    
}


