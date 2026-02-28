#'  Load Required Packages, Set Global Options
#'
#' Install pacman and other dependent libraries. Sets global options.
#' Note: dynamic loading is not intended to be used for CRAN submission
#' @importFrom utils installed.packages
#' @importFrom utils install.packages
#' @export
init_environment <- function() {
  # Check if pacman is installed; install if necessary
  if (!"pacman" %in% installed.packages()) {
    install.packages("pacman")
  }

  # Install but not load required packages
  Cs(
    "devtools",
    "tools", "glue", "rlang",
    # "ggprism", "labelled",
    "scales",
    # "dataReporter", "xml2", "rvest",
    # "logger",
  ) |>
    pkg_install()

  # Use pacman to load (and install if missing) required packages
  pacman::p_load(
    tidyverse,
    here,
    janitor,
    conflicted,
    logger
  )

  ## random seed initiation
  set.seed(42)

  ## ggplot initiation
  init_ggplot()

  conflict_prefer_all("rlang", quiet = T)
  conflict_prefer_all("readr", quiet = T)
  conflict_prefer_all("dplyr", quiet = T)
  suppressMessages(conflicts_prefer(here::here))

  options(digits = 6)
  options(readr.show_col_types = F)
  options(dplyr.summarise.inform = F)
}

#' Install Without Loading Required Packages
#'
#' Install some dependent libraries without loading into namespace
#' @param packages The names of packages to be installed.
#' @importFrom utils installed.packages
#' @export
pkg_install <- function(packages) {
  packages %w/o% installed.packages() |>
    lapply(\(.) pacman::p_install(., character.only = T))
}
