An R package for managing the downloading and accessing [OBIS full datasets](https://obis.org/manual/access). 

### Requirements

  + [R v4+](https://www.r-project.org/)

  + [rlang](https://CRAN.R-project.org/package=rlang)
  
  + [dplyr](https://CRAN.R-project.org/package=dpylr)

  + [httr](https://CRAN.R-project.org/package=httr)

  + [arrow](https://CRAN.R-project.org/package=arrow)
  
  + About 10GB of disk space
  
  + Patience
  
### Installation

```
remotes::install_github("BigelowLab/fullobis")
```

### Usage

## Setup

It may be helpful to setup two global options you will need: the **root** path to where you wish to store the downloaded file, and the **useragent** string you will use to identofy yourself to the OBIS server when downloading.  You have three options:

 + save these in you `~/.Rprofile` text file like as shown below, obviouysly entering your own info.
 
```
options(fullobis = c(
                     root = "/this/is/the/path/to/obis",
                     useragent = "http://github.com/put_your_username")
)
```

 + set these in each session of R
```
library(fullobis)
set_root("/this/is/the/path/to/obis")
set_useragent("http://github.com/put_your_username")
```

 + pass these as parameters when needed by functions (see `?fetch_obis` and `?query_obis`)
 
### Fetching a [parquet](https://parquet.apache.org/) formatted full database file.

These files are readable in R with the `arrow` package. They are relatively small and self-describing and they just work across all platforms.  The function `fetch_obis()` will download the most recently posted parquet formatted dataset and download to your root data directory.  It provides a progress bar.  Not that you can download the a CSV file this way, too.  See `?query_obis` for details.

```
ok <- fetch_obis()
```


### Accessing the data

You can open and read all or parts of the file... depending upon you system it could take a while.

```
col_keep = c("id",
             "decimalLongitude",
             "decimalLatitude",
             "scientificName",
             "phylum",
             "date_year",
             "individualCount")
filename <- get_current()
x <- arrow::open_dataset(filename)
y = x %>% 
  dplyr::select(all_of(col_keep)) %>% 
  dplyr::collect() %>%
  dplyr::as_tibble() %>%
  dplyr::filter(dplyr::filter(!is.na(individualCount), !is.na(date_year)))
y
# # A tibble: 24,950,921 × 7
#    id         decimalLongitude decimalLatitude scientificName   phylum date_year
#    <chr>                 <dbl>           <dbl> <chr>            <chr>      <int>
#  1 73630bc3-…             2.81            51.4 Prochromadorell… Nemat…      1999
#  2 d3b0ab96-…             2.81            51.4 Prochromadorell… Nemat…      1999
#  3 5595aab3-…             2.81            51.4 Prochromadorell… Nemat…      1999
#  4 f1df8c74-…             2.81            51.4 Prochromadorell… Nemat…      1999
#  5 18ee7e4f-…             2.81            51.4 Prochromadorell… Nemat…      1999
#  6 50bc0d79-…             2.81            51.4 Prochromadorell… Nemat…      1999
#  7 efe8ffd1-…             2.81            51.4 Prochromadorell… Nemat…      1999
#  8 e6c181f4-…             2.81            51.4 Prochromadorell… Nemat…      1999
#  9 3bf93db6-…             2.81            51.4 Prochromadorell… Nemat…      1999
# 10 1b6d7c94-…             2.81            51.4 Prochromadorell… Nemat…      1999
# # … with 24,950,911 more rows, and 1 more variable: individualCount <chr>
```

If you workflow requires it (and storage space allows it) you can save this subset as it's own file in a variety of formats: CSV, RData, parquet, feather, etc  See more about the [arrow package here](https://arrow.apache.org/docs/r/).
