#' Generate a 1-way frequency table
#'
#' Generate a 1-way frequency table with HTML format
#'
#' @param df a data.frame containing the variables you wish to count..
#' @param x the column name of the counting variable.
#' @return Returns a data.frame with frequencies and percentages of the tabulated variable.
#' @export
stats_count_pct <- function(df, x) {
  suppressMessages(suppressWarnings(
    return(
      df |>
        janitor::tabyl({{x}}) |>
        janitor::adorn_pct_formatting() |>
        knitr::kable(format = "html", color = "black")
    )
  ))
}
