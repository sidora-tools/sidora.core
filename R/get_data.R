#' Establish connection to database table
#'
#' @param tab Name of table that should be downloaded
#' @param con Database connection
#'
#' @return A table connection
#' @export
get_raw_con <- function(
  tab = c(
    "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", 
    "TAB_Library", "TAB_Capture", "TAB_Sequencing", 
    "TAB_Raw_Data", "TAB_Sequencing_Sequencer", "TAB_Tag", "TAB_Project"
  ), con) {
  if (length(tab) != 1) {
    stop("Select one table.")
  }
  dplyr::tbl(con, tab)
}

#' Download table from database
#'
#' @param tab Name of table that should be downloaded
#' @param con Database connection
#' @param cache Should data be cached?
#' @param cache_dir Path to cache directory
#' @param cache_max_age Maximum age of cache in seconds
#'
#' @return A dataframe
#' @export
get_raw_df <- function(
  tab = c(
    "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", 
    "TAB_Library", "TAB_Capture", "TAB_Sequencing", 
    "TAB_Raw_Data", "TAB_Sequencing_Sequencer", "TAB_Tag", "TAB_Project"
  ), 
  con, 
  cache = T, cache_dir = tempdir(), cache_max_age = 24 * 60 * 60) {
  if (length(tab) != 1) {
    stop("Select one table.")
  }
  # caching is activated
  if (cache) {
    tab_cache_file <- file.path(cache_dir, paste0(tab, ".RData"))
    if (file.exists(tab_cache_file) & file.mtime(tab_cache_file) > (Sys.time() - cache_max_age)) {
      load(tab_cache_file)
    } else {
      this_tab <- get_raw_con(tab, con) %>% tibble::as_tibble()
      save(this_tab, file = tab_cache_file)
    }
  # caching is not activated
  } else {
    this_tab <- get_raw_con(tab, con) %>% tibble::as_tibble()
  }
  return(this_tab) 
}
