library(magrittr)

#### establish connection to the Pandora database server ####

creds <- readLines("playground/.credentials")
con <- DBI::dbConnect(
  RMariaDB::MariaDB(), 
  host = creds[1],
  user = creds[2],
  password = creds[3],
  db = "pandora"
)

#### get tables ####

# as DBI connection
get_con("TAB_Site", con)
# as a local data.frame (data is cached in a tempdir by default)
get_df("TAB_Site", con)

#### get multiple tables ####

# as list of DBI connections
get_con_list(c(
  "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", "TAB_Library"
), con = con)

# as list of data.frames
df_list <- get_df_list(c(
  "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", "TAB_Library"
), con = con)

#### join tables ####

jt <- join_pandora_tables(df_list)

get_df_list(c(
  "TAB_Site", "TAB_Individual"
), con = con) %>% join_pandora_tables()
