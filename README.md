[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Travis-CI Build Status](https://travis-ci.com/sidora-tools/sidora.core.svg?branch=master)](https://travis-ci.com/sidora-tools/sidora.core) [![Coverage Status](https://img.shields.io/codecov/c/github/sidora-tools/sidora.core/master.svg)](https://codecov.io/github/sidora-tools/sidora.core?branch=master)

# sidora.core

Functions to access and download tables of the MPI-SHH DAG Pandora database. Serves as back-end for all sidora applications. 

## Install

You can install the development version from github:

```
if(!require('remotes')) install.packages('remotes')
remotes::install_github("sidora-tools/sidora.core")
```

## For users: Quickstart guide

Load the package and establish a database connection to Pandora. To do so you need the right `.credentials` file. Contact Stephan Schiffels, James Fellows Yates or Clemens Schmid to obtain it. You also have to be in the institute's subnet. 

```
library(magrittr)
library(sidora.core)

con <- get_pandora_connection(".credentials")
```

You can access individual tables either by establishing a DBI connection (`get_con()`) to them or by downloading them as a data.frame (`get_df()`). You'll probably not need the former, which is only relevant if you want to interact with the database server directly.

`get_df()` does three additional things: It transforms the columns of the downloaded table to the correct data type (with `enforce_types()`), it adds a table name prefix to each column name and it caches the downloaded table locally. The default is a per-R-session cache, but you can cache more permanently by changing the `cache_dir` and `cache_max_age` parameters.

```
# get DBI connection
get_con("TAB_Site", con)
# get a local data.frame 
sites <- get_df("TAB_Site", con)
```

Many columns in Pandora have numerical IDs to refer to workers, Protocols, Capture Probe sets and other finite sets of identifiers. This information usually has be looked up in helper tables. We have added the function `convert_all_ids_to_values()` to automatically convert all numerical IDs to the actual strings.

```
convert_all_ids_to_values(sites)
```

You can download multiple tables at once with `get_con_list()` and `get_df_list()`, which return a named list of objects. The latter again includes the additional transformation and caching features.

```
# get list of DBI connections
get_con_list(c(
  "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", "TAB_Library"
), con = con)
# get list of data.frames
df_list <- get_df_list(c(
  "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", "TAB_Library"
), con = con)
```

The main Pandora tables follow a hierarchical, pair-wise logic of primary and foreign keys that represents the real hierarchy of classification, attribution and processing to which a typical aDNA sample is subject. That means there is a defined order of tables:

```
TAB_Site >
  TAB_Individual >
    TAB_Sample > 
      TAB_Extract > 
        TAB_Library >
          TAB_Capture > 
            TAB_Sequencing >
              TAB_Raw_Data >
                TAB_Analysis
```

A small semantic exception is the capture table, which DOES contain entries even for samples that did not go through a capture step. That is done to maintain the clean database hierarchy.

This architecture has the consequence that you will need intermediate tables to connect information from not directly neighbouring tables. The helper function `make_complete_table_list()` simplifies the step of collecting the relevant intermediate tables in order.

```
# get "complete"" list of data.frames
get_df_list(c(
  make_complete_table_list(c("TAB_Site", "TAB_Capture"))
), con = con)
```

`join_pandora_tables()` now is a join function aware of Pandora's hierarchical logic. It automatically combines lists of data.frames (as produced by `get_con_list()` or `get_df_list()`) to long data.frames.

```
join_pandora_tables(df_list)
```

A special hint concerning `TAB_Analysis`: It is formatted differently from the other tabs in sidora. Instead of a "wide" format where each analysis method is represented by one column, there are only 2 columns `analysis.Table` and `analysis.Results`. The analysis methods (i.e. Initial reads, Failed reads, etc) and their values are collected as rows of these 2 columns. This "long" data format can be transformed to a "wide" one for example with [`tidyr::pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html). 

## For developers: How do I load the 'development environment'

1. Clone this repository. 
2. Next you will need to create the `.credentials` file - please speak to the repository contributors for details.
3. Open Rstudio and go to File > Open Project and select the file 'sidora.core.Rproj' in the repository. 
4. Press `Ctrl` + `shift` + `b` to build the package and load the library. (alternatively, in the top right pane go to the 'Build' tab and press Install and Restart)

A great introduction to R package development is available [here](http://r-pkgs.had.co.nz/).
