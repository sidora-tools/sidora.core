creds <- readLines("playground/.credentials")
con <- DBI::dbConnect(
  RMySQL::MySQL(), 
  host = creds[1],
  user = creds[2],
  password = creds[3],
  db = "pandora"
)

site_con <- get_con("TAB_Site", con)
site_tibble <- get_df("TAB_Site", con)


site_con %>% dplyr::filter(
  Latitude > 5
)

site_tibble %>% dplyr::filter(
  Latitude > 5
)

filter_by_tag <- function(x, include = c(), exclude = c()) {
  tags_down <- x %>% dplyr::select("Tags") %>% dplyr::collect() %>% dplyr::pull("Tags")
  include_all <- unname(sapply(tags_down, function(y) {all(sapply(include, function(z) {grepl(z, y)}))}))
  exlude_any <- unname(sapply(tags_down, function(y) {any(sapply(exclude, function(z) {grepl(z, y)}))}))
  filter_condition <- include_all & !exlude_any
  filter_id <- which(filter_condition)
  x %>% dplyr::filter(Id %in% filter_id)
}

filter_by_tag(site_con, include = c("DFG_Spain_KWA_legacy", "Wolfgang Haak"), exclude =  c("James Fellows Yates"))
filter_by_tag(site_tibble, include = c("DFG_Spain_KWA_legacy", "Wolfgang Haak"), exclude =  c("James Fellows Yates"))

#### joining ####

df_list <- get_df_list(c(
  "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", "TAB_Library"
), con = con)

jt <- join_df_list(df_list)

jt$Latitude

colnames(jt)
