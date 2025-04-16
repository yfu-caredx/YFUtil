#' Intersection of on two vectors. Similar to intersect(x, y)
#'
#' Calculates the mean while removing NA values.
#'
#' @param x A vector.
#' @param y A vector.
#' @return A vector consist of the interaction elements shared in both x and y
#' @export
"%w/%" <- \(x, y) x[x %in% y]

#'  Difference on a vector to another vector. Similar to setdiff(x, y)
#'
#' Calculates the mean while removing NA values.
#'
#' @param x A vector.
#' @param y A vector.
#' @return A vector consist of the (asymmetric) difference of x to y
#' @export
"%w/o%" <- \(x, y) x[!x %in% y]
