#' Rounding and converting to characters
#'
#' Rounding a number to the 1st decimal place, then convert it to characters
#'
#' @param x A numeric number.
#' @return A charator string
#' @export
num2chr_r1 <- \(x) as.character(round(x, 1))

#' Rounding and converting to characters
#'
#' Rounding a number to the 2nd decimal place, then convert it to characters
#'
#' @param x A numeric number.
#' @return A charator string
#' @export
num2chr_r2 <- \(x) as.character(round(x, 2))


#' Label percentages
#'
#' @name label_percent
#' @rdname label_percent
#' @keywords internal
#' @importFrom scales label_percent
#' @export
NULL


#' Label percentages from rounded 0.1 accuracy
#'
#' @name label_pct_round1
#' @rdname label_pct_round1
#' @keywords internal
#' @importFrom scales label_percent
#' @export
label_pct_round1 <- function(x) {
  scales::label_percent(accuracy = 0.1)(x)
}
