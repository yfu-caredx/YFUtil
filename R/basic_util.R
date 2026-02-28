#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
NULL

#' Enhanced list function
#'
#' @name list2
#' @rdname list2
#' @keywords internal
#' @importFrom rlang list2
#' @export
NULL

#' Enhanced base::c function
#'
#' @name c_
#' @rdname c_
#' @keywords internal
#' @export
c_ <- \(...) unlist(rlang::list2(...))

#' Character strings from unquoted names
#' same as Hmisc::Cs()
#' @param ... Unquoted names to be converted to a character vector.
#' @importFrom rlang list2
#' @return character string vector.
#' @export
Cs <- function(...) {
  vals <- substitute(rlang::list2(...)) |>
    purrr::discard(~ .x == "") |>
    as.character()
  vals[-1]
}

#' Intersection of on two vectors. Similar to base::intersect
#'
#' Calculates the mean while removing NA values.
#'
#' @param x A vector.
#' @param y A vector.
#' @return A vector consist of the interaction elements shared in both x and y
#' @export
"%w/%" <- \(x, y) x[x %in% y]

#'  Difference on a vector to another vector. Similar to base::setdiff
#'
#' Calculates the mean while removing NA values.
#'
#' @param x A vector.
#' @param y A vector.
#' @return A vector consist of the (asymmetric) difference of x to y
#' @export
"%w/o%" <- \(x, y) x[!x %in% y]




