creds <- readLines("playground/.credentials")
con <- DBI::dbConnect(
  RMySQL::MySQL(), 
  host = creds[1],
  user = creds[2],
  password = creds[3],
  db = "pandora"
)

get_raw_con <- function(tab, con) {
  dplyr::tbl(con, tab)
}

get_raw_df <- function(tab, con, cache = T, cache_dir = tempdir(), cache_max_age = Sys.time() - 24 * 60 * 60) {
  
  # caching is activated
  if (cache) {
    # cache file path
    tab_cache_file <- file.path(cache_dir, paste0(tab, ".RData"))
    # check if cache file exists and is not too old
    if (file.exists(tab_cache_file) & file.mtime(tab_cache_file) > cache_max_age) {
      # load cache file
      load(tab_cache_file)
    } else {
      # download and cache file
      this_tab <- get_raw_con(tab, con) %>% tibble::as_tibble()
      save(this_tab, file = tab_cache_file)
    }
  # caching is not activated
  } else {
    this_tab <- get_raw_con(tab, con) %>% tibble::as_tibble()
  }
  
  return(this_tab) 
}

site_con <- get_raw_con("TAB_Site", con)
site_tibble <- get_raw_df("TAB_Site", con)


site_con %>% dplyr::filter(
  Latitude > 5
)

site_tibble %>% dplyr::filter(
  Latitude > 5
)
W