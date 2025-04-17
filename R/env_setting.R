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

  # Use pacman to load (and install if missing) required packages
  pacman::p_load(
    tidyverse,
    here,
    janitor,
    stringr,
    logger
  )

  # Install but not load required packages
  c("tools", "glue", "rlang",
    "ggprism", "labelled",
    "dataReporter", "xml2", "rvest") |>
    `%w/o%`(installed.packages()) |>
    lapply(\(.) pacman::p_install(., character.only = T))

  options(digits = 6)
  options("digits" = 6)
  options(readr.show_col_types = F)
  options(dplyr.summarise.inform = F)
  # ggplot2::theme_set(ggprism::theme_prism())
  # ggplot2::theme_update(plot.title = element_text(hjust = 0.5))
  # ggplot2::theme_update(plot.subtitle = element_text(hjust = 0.5))
}
