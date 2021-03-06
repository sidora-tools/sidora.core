% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataprep_lookup_in_pandora.R
\name{convert_all_ids_to_values}
\alias{convert_all_ids_to_values}
\title{convert_all_ids_to_values}
\usage{
convert_all_ids_to_values(df, con)
}
\arguments{
\item{df}{data.frame. A Sidora/Pandora-Dataframe with sidora column names.}

\item{con}{a pandora connection}
}
\value{
The converted dataframe with lookup-columns replaced by the actual values.
}
\description{
A convenience function which simply transforms a given Pandora-Dataframe using all
defined default lookups. Typically will convert a pandora back-end numeric ID to a 'human readable string' actually displayed on the pandora webpage.
}
