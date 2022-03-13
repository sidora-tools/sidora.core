[![R-CMD-check](https://github.com/sidora-tools/sidora.core/actions/workflows/check-release.yaml/badge.svg?style=for-the-badge&logo=appveyor)](https://github.com/sidora-tools/sidora.core/actions/workflows/check-release.yaml)
[![Coverage Status](https://img.shields.io/codecov/c/github/sidora-tools/sidora.core/master.svg?style=for-the-badge&logo=appveyor)](https://codecov.io/github/sidora-tools/sidora.core?branch=master)
![GitHub R package version](https://img.shields.io/github/r-package/v/sidora-tools/sidora.core)

# sidora.core

Functions to access and download tables of the MPI-EVA DAG Pandora database using R. Serves as back-end for all sidora applications.

## Install

### Development

You can install the development version from github:

```r
if(!require('remotes')) install.packages('remotes')
remotes::install_github("sidora-tools/sidora.core")
```

### Conda

If you wish to set up a conda environment for using `sidora.core`, instructions are as follows:

1. Either clone the repository and change into it, or download the file `environmental.yml`.
2. Create an environment using the file

    ```bash
    conda env create -f environmental.yml
    ```

3. Once created, activate the environment

   ```bash
   conda activate sidora.core
   ```

4. Open `R` and install the `sidora.core` package

    ```r                                                                            
    if(!require('remotes')) install.packages('remotes')                             
    remotes::install_github("sidora-tools/sidora.core")                             
    ``` 

## Quickstart guide

To use this package you have to follow these steps:

1. Install the sidora.core package in R (see above)
2. Create a `.credentials` file\*
3. Connect to the institutes subnet via VPN (see the instructions in kbase)
4. If working locally, establish an ssh tunnel to the pandora database server with

    ```bash
    ssh -L 10001:pandora.eva.mpg.de:3306 <your username>@daghead1
    ```

    > You must make a new tunnel each time you want to connect (e.g. after you log out or reboot your machine).  
    > ⚠️ This step is not necessary when working on the EVA servers directly.

5. Run this in R to establish a connection to the database: 

    ```r
    con <- sidora.core::get_pandora_connection("<path to your .credentials file>")
    ```

\* The `.credentials` file must have the following content and structure:

```
<host name of the database server>
<port of the database server>
<database username>
<database password>
```

Only one specific account has the right read permissions to access the Pandora database directly. Please contact Stephan Schiffels, James Fellows Yates, or Clemens Schmid to obtain the relevant username and password.

If all of that worked, then you can acccess Pandora with sidora.core. For example load a specific Pandora table:

```r
library(sidora.core)

sites <- get_df("TAB_Site", con)
```

Each column will have the table name and Pandora entry column name, e.g. `sample.Type`

You can also load multiple tables with:

```r
df_list <- get_df_list(c(
  "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", "TAB_Library"
), con = con)
```

This produces a list of tables.
If you want to join these together into a single table, you can do:

```r
join_pandora_tables(df_list)
```

> :warning: you cannot join non-adjacent tables. You must follow the Pandora hierarchy. E.g. You cannot join `TAB_Site` and `TAB_Sample` without `TAB_Individual`.
> You can automatically get all intermediate tables using the helper function `make_complete_table_list(c("TAB_Site", "TAB_Capture"))`.

Many columns in Pandora displayed as dropdown menus on the Pandora webpage actually use internal numerical IDs. Examples are: workers, protocols, capture probe sets and other finite sets of identifiers.

We have added the function `convert_all_ids_to_values()` to automatically convert all numerical IDs to the actual strings.

```r
convert_all_ids_to_values(sites, con)
```

If you wish to filter a table by project or tag, there is a special function to allow you to 'include' and 'exclude' certain tags from your filtering operation.

```r
samples <- get_df("TAB_Sample", con)
sidora.core::filter_pr_tag(samples, "sample.Tags", ins = c("Oral_Microbiome"), outs = c("Deep_Evolution"))
```

If you want to programmatically update a single Pandora table (e.g. with `dplyr::mutate`), you can convert the table to a Pandora webpage compatible upload sheet.

As in example, to add tags of `Calculus` samples of the previously untagged site `ALA`:

```r
library(magrittr)
library(sidora.core)
library(dplyr)

samples <- get_df("TAB_Sample", con)

# filter
samples_raw <- samples %>%
  filter(grepl("^ALA", sample.Full_Sample_Id)) %>%
  convert_all_ids_to_values(con) %>%
  filter(sample.Type_Group == "Calculus")

# update tag and convert for update existing entries format
samples_updated <- samples_raw %>%
  mutate(sample.Tags = "FoodTransforms") %>%
  sidora.core::format_as_update_existing()

# save for upload
write_csv(samples_updated, "Sample.csv")
```

For all other functions, please check the sidora.core R package documentation.

## Behind the scenes

Individual tables are accessed either by establishing a DBI connection (`get_con()`) to them or by downloading them as a data.frame (`get_df()`). You'll probably not need the former, which is only relevant if you want to interact with the database server directly.

`get_df()` does three additional things: It transforms the columns of the downloaded table to the correct data type (with `enforce_types()`), it adds a table name prefix to each column name and it caches the downloaded table locally. The default is a per-R-session cache, but you can cache more permanently by changing the `cache_dir` and `cache_max_age` parameters.

```r
# get DBI connection
get_con("TAB_Site", con)

# or

# get a local data.frame
sites <- get_df("TAB_Site", con)
```

Many columns in Pandora have numerical IDs to refer to workers, Protocols, Capture Probe sets and other finite sets of identifiers. This information usually has be looked up in helper tables. We have added the function `convert_all_ids_to_values()` to automatically convert all numerical IDs to the actual strings.

```r
convert_all_ids_to_values(sites, con)
```

You can download multiple tables at once with `get_con_list()` and `get_df_list()`, which return a named list of objects. The latter again includes the additional transformation and caching features.

```r
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

```r
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

A small semantic exception is the capture table, which **does** contain entries even for samples that did not go through a capture step (i.e. those that went to shotgun sequencing). That is done to maintain the clean database hierarchy.

This architecture has the consequence that you will need intermediate tables to connect information from not directly neighbouring tables. The helper function `make_complete_table_list()` simplifies the step of collecting the relevant intermediate tables in order.

```r
# get "complete"" list of data.frames
get_df_list(c(
  make_complete_table_list(c("TAB_Site", "TAB_Capture"))
), con = con)
```

A special hint concerning `TAB_Analysis`: It is formatted differently from the other tabs in sidora. Instead of a "wide" format where each analysis method is represented by one column, there are only 2 columns `analysis.Table` and `analysis.Results`. The analysis methods (i.e. Initial reads, Failed reads, etc) and their values are collected as rows of these 2 columns. This "long" data format can be transformed to a "wide" one for example with [`tidyr::pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html).

## How do I load the 'development environment'

1. Clone this repository.
2. Next you will need to create the `.credentials` file - please speak to the repository contributors for details.
3. Open Rstudio and go to File > Open Project and select the file 'sidora.core.Rproj' in the repository.
4. Press <kbd>Ctrl</kbd> + <kbd>shift</kbd> + <kbd>b</kbd> to build the package and load the library. (alternatively, in the top right pane go to the 'Build' tab and press Install and Restart)

Additionally, if you've made a modification it's recommended to run build-validation before rebuilding. This can typically be accessed in Rstudio with  <kbd>Ctrl</kbd> + <kbd>shift</kbd> + <kbd>e</kbd>

If you need to update any field names or add new tables for Pandora, make sure to update the TSV in `data-raw`, and run the `data_prep.R` script. The .tsv files can be edited in a spreadsheet tool like [LibreOffice](https://www.libreoffice.org).

A great introduction to R package development is available [here](http://r-pkgs.had.co.nz/).
