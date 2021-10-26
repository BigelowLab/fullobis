#' Retrieve the most recent parquet filename in the root path
#'
#' @export
#' @param root character, the root path to the dataset
#' @param pattern the filename pattern to search, by default we use the equivalent of the glob \code{obis_*.parquet}
#' @return the fully qualified filename and path or "" if none found
get_current <- function(root = get_root(),
                        pattern = "^obis_.*\\.parquet$"){
  ff <- list.files(root, pattern = pattern[1], full.names = TRUE)
  ff[length(ff)]
}

#' Retrieve the root directory from options
#'
#' @export
#' @param default character, if the option is not set then return this as the default
#' @return charcater path to the root directory
get_root <- function(default = "."){
  opt <- getOption("fullobis")
  if (!is.null(opt)){
    if ("root" %in% names(opt)) root <- opt[['root']]
  } else {
    root <- default[1]
  }
  root
}

#' Set the root directory in session options
#'
#' @export
#' @param path character, the root path to setthe root directory
#' @return see \code{options}
set_root <- function(path = "."){
  opt <- getOption("fullobis")
  if (!is.null(opt)){
    opt[['root']] <- path[1]
  } else {
    opt <- c(
      root = path[1],
      useragent = "")
  }
  options(fullobis = opt)
}


#' Retrieve the useragent from options
#'
#' @export
#' @param default character, if the option is not set then return this as the default
#' @return charcater user agent for \code{\link[httr]{user_agent}}
get_useragent <- function(default = ""){
  opt <- getOption("fullobis")
  if (!is.null(opt)){
    if ("useragent" %in% names(opt)) useragent <- opt[['useragent']]
  } else {
    useragent <- default[1]
  }
  useragent
}

#' Set the useragent in session options
#'
#' @export
#' @param useragent character, the useragent to set
#' @return see \code{options}
set_useragent <- function(useragent = ""){
  opt <- getOption("fullobis")
  if (!is.null(opt)){
    opt[['useragent']] <- useragent[1]
  } else {
    opt <- c(
      root = ".",
      useragent = useragent[1])
  }
  options(fullobis = opt)
}
