% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataprep_get_data.R
\name{get_data}
\alias{get_data}
\alias{get_con}
\alias{get_con_list}
\alias{get_df}
\alias{get_df_list}
\alias{access_restricted_table}
\alias{access_prejoined_data}
\title{Access and download tables from Pandora}
\usage{
get_con(tab = sidora.core::pandora_tables, con)

get_con_list(tab = sidora.core::pandora_tables, con)

get_df(
  tab = sidora.core::pandora_tables,
  con,
  cache = T,
  cache_dir = tempdir(),
  cache_max_age = 24 * 60 * 60
)

get_df_list(
  tab = sidora.core::pandora_tables,
  con,
  cache = T,
  cache_dir = tempdir(),
  cache_max_age = 24 * 60 * 60
)

access_restricted_table(tab, con)

access_prejoined_data(tab, con)
}
\arguments{
\item{tab}{character vector. Names of tables}

\item{con}{database connection object}

\item{cache}{logical. Should data be cached?}

\item{cache_dir}{character. Path to cache directory}

\item{cache_max_age}{numeric. Maximum age of cache in seconds}
}
\value{
connection, list of connections, data.frame or list of data.frames
}
\description{
You can access individual tables either by establishing a DBI connection 
(\code{get_con()}) to them or by downloading them as a data.frame (\code{get_df()}). 
You'll probably not need the former, which is only relevant if you want to 
interact with the database server directly. \code{get_df()} does three additional 
things: It transforms the columns of the downloaded table to the correct data 
type (with \code{enforce_types()}), it adds a table name prefix to each column name
and it caches the downloaded table locally. The default is a per-R-session 
cache, but you can cache more permanently by changing the \code{cache_dir} 
and \code{cache_max_age} parameters.\cr\cr
You can download multiple tables at once with \code{get_con_list()} and 
\code{get_df_list()}, which return a named list of objects. The latter again 
includes the additional transformation and caching features. \cr\cr
Some tables are restricted, i.e. the Pandora read user does not have access 
to certain columns. \code{access_restricted_table()} allows you to get the open
(non-restricted) columns of these tables.
TAB_Analysis is stored a little awkwardly in Pandora and we do a pre-joining operation
with \code{access_prejoined_data()} to access its content. 
Both \code{access_restricted_table()} and \code{access_prejoined_data()} are called 
automatically if you try to access the relevant tables with \code{get_con()} or 
\code{get_df()}, so you usually do not have to call them explicitly.
}
