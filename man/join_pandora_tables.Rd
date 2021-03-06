% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataprep_join_data.R
\name{join_pandora_tables}
\alias{join_pandora_tables}
\title{Join multiple \strong{PANDORA table}s}
\usage{
join_pandora_tables(x)
}
\arguments{
\item{x}{named list of data.frames or connections (\strong{PANDORA table}s) as returned by 
\code{get_con_list} or \code{get_df_list}}
}
\value{
data.frame (joined from multiple data.frames)
}
\description{
Some Pandora tables can be merged following a hierarchical, pair-wise logic 
of primary and foreign keys. \code{join_pandora_tables()} is a join function 
which is aware of this logic and automatically combines lists of data.frames 
with Pandora tables (as produced by \code{get_con_list()} or \code{get_df_list()}) 
to long data.frames.
}
