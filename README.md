[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Travis-CI Build Status](https://travis-ci.com/sidora-tools/sidora.core.svg?branch=master)](https://travis-ci.com/sidora-tools/sidora.core) [![Coverage Status](https://img.shields.io/codecov/c/github/sidora-tools/sidora.core/master.svg)](https://codecov.io/github/sidora-tools/sidora.core?branch=master)

# sidora.core

Functions to access and download tables of the MPI-SHH DAG Pandora database. Serves as backend for all sidora applications. 

## Basic functions 

```
library(magrittr)
library(sidora.core)

#### establish connection to the Pandora database server ####

con <- DBI::dbConnect(
  RMariaDB::MariaDB(), 
  host = "host", user = "user", password = "password", db = "pandora"
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
```

## How do I load the 'development environment'

1. Clone this repository. 
2. Next you will need to create the `.credentials` file - please speak to the repository contributors for details.
3. Open Rstudio and go to File > Open Project and select the file 'sidora.core.Rproj' in the repository. 
4. Press `Ctrl` + `shift` + `b` to build the package and load the library. (alternatively, in the top right pane go to the 'Build' tab and press Install and Restart)
4. Now you can start your own, or open the file `playground/test.R` to test out the core functions.

