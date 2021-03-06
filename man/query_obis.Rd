% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fetch.R
\name{query_obis}
\alias{query_obis}
\title{Query the api for the complete datasets}
\usage{
query_obis(
  uri = "https://api.obis.org/export?complete=true",
  data_uri = "https://obis-datasets.ams3.digitaloceanspaces.com",
  what = c("recent", "all")[1],
  source_fmt = c("csv", "parquet")[2],
  useragent = httr::user_agent(get_useragent()),
  form = c("list", "path")[2]
)
}
\arguments{
\item{uri}{character, the URL to query}

\item{data_uri}{character, the root URL to where data resides}

\item{what}{character, one of 'recent' (default) or 'all'.
OBIS returns list of all posted complete datasets, so this just get the
the most recent.}

\item{source_fmt}{as of Oct 2021 the choices are "csv" or "parquet"  If you don't choose
one or the other than what is applied to the jumble.}

\item{useragent}{character the identity of the user}

\item{form}{character, either "path" or "list"  to determine the returned value format}
}
\value{
the URL to the requested data
}
\description{
Query the api for the complete datasets
}
