#' Query the api for the complete datasets
#'
#' @param uri character, the URL to query
#' @param data_uri character, the root URL to where data resides
#' @param what character, one of 'recent' (default) or 'all'.
#'        OBIS returns list of all posted complete datasets, so this just get the
#'        the most recent.
#' @param source_fmt as of Oct 2021 the choices are "csv" or "parquet"  If you don't choose
#'   one or the other than what is applied to the jumble.
#' @param useragent character the identity of the user
#' @param form character, either "path" or "list"  to determine the returned value format
#' @return the URL to the requested data
query_obis <- function(uri = "https://api.obis.org/export?complete=true",
                       data_uri = "https://obis-datasets.ams3.digitaloceanspaces.com",
                       what = c("recent", "all")[1],
                       source_fmt = c("csv", "parquet")[2],
                       useragent = httr::user_agent(get_useragent()),
                       form = c("list", "path")[2]){
  if (FALSE){
    uri = "https://api.obis.org/export?complete=true"
    data_uri = "https://obis-datasets.ams3.digitaloceanspaces.com"
    what = c("recent", "all")[1]
    source_fmt = c("csv", "parquet")[2]
    useragent = httr::user_agent(get_useragent())
    form = c("list", "path")[2]
  }
  resp <- httr::GET(uri, useragent)
  # see API vignette for httr package
  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "Query failure [%s]\nstatus_code:%s",
        uri,
        httr::status_code(resp),
      ),
      call. = FALSE
    )
  }

  if (httr::status_code(resp) != 200) {
    stop(
      sprintf(
        "Query failure [%s]\nstatus_code:%s",
        uri,
        httr::status_code(resp),
      ),
      call. = FALSE
    )
  }

  xx <- resp %>%
    httr::content() %>%
    `[[`('results')

  if (any(source_fmt %in% c("csv", "parquet"))){
    fmt <- sapply(xx, "[[", "type")
    xx <- xx[fmt %in% source_fmt]
  }

  if (tolower(what[1]) == 'recent'){
    dates <- sapply(xx, function(x) {as.POSIXct(x$created,
                                                format = "%Y-%m-%dT%H:%M:%OSZ",
                                                tz = 'UTC')})
    ix <- which.max(dates)
    xx <- xx[ix]
  }

  if (form == "path"){
    s3path <- sapply(xx, function(x) x$s3path)
    xx <- file.path(data_uri, s3path)
  }
  xx
}


#' Fetch the complete OBIS dataset
#'
#' @param uri charcater, the URL of the file to fetch - see \code{query_obis}
#' @param path character, the path (directory to save data to)
#' @param timeout integer, the timeout to set (system default is 60s, but
#'   we set default here to 600s)
#' @param unpack logical, if TRUE unzip the file which will overwrite prior
#'   instances of 'occurrence.csv'
#' @param ... other arguments for \code{download.file}
#' @return named integer, 0 for success, name is of the output file
fetch_obis <- function(uri = query_obis(),
                       path = get_root(),
                       timeout = 600,
                       unpack = TRUE,
                       ...){
  filename <- file.path(path, basename(uri))
  orig_timeout <- options("timeout")
  options(timeout = timeout)
  ok <- utils::download.file(uri, filename, mode = "wb", timeout = timeout, ...) %>%
    rlang::set_names(filename)
  options(timeout = orig_timeout)
  ok
}
