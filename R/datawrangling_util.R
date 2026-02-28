#' Match extreme values of a secondary variable within a time window
#'
#' For each row in a primary data frame (`df_x`), this function looks up records
#' in a secondary data frame (`df_y`) for the same subject and finds the single
#' extreme (maximum or minimum) value of a target variable (`y_value`)
#' whose test time is within a specified window of the primary variable’s test time.
#'
#' @param df_x A data frame containing the primary measurements.
#' @param df_y A data frame containing the secondary measurements to match against.
#' @param id Column name identifying subjects (must be present in both data frames).
#' @param x_value Column name of the variable of interest in `df_x`.
#' @param x_time Column name of the numeric test time for the variable in `df_x`.
#' @param y_value Column name of the variable to attach from `df_y`.
#' @param y_time Column name of the numeric test time for the variable in `df_y`.
#' @param w Numeric window width. Candidate `y_time` values must be within this
#'   window relative to `x_time`.
#' @param side Character, one of `"prior"`, `"post"`, or `"both"`. Controls
#'   whether the time window is before, after, or either side of `x_time`.
#'   - `"prior"`: `y_time ∈ [x_time - w, x_time)`
#'   - `"post"`:  `y_time ∈ (x_time, x_time + w]`
#'   - `"both"`:  `y_time ∈ [x_time - w, x_time + w]`
#' @param extreme Character, `"max"` or `"min"`. Whether to select the maximum
#'   or minimum `y_value` within the window.
#'
#' @details
#' If multiple candidate records share the same extreme value, ties are broken
#' deterministically: the record closest in time to `x_time` is chosen; if still
#' tied, the earliest `y_time` is selected. If no records fall within the window,
#' the merged columns will contain `NA`.
#'
#' @return A tibble consisting of all columns of `df_x` plus:
#' - `matched_y`: the selected `y_value` (or `NA` if no match),
#' - `matched_y_time`: the corresponding `y_time`.
#'
#' @examples
#' df_x <- tibble::tibble(
#'   id  = c(1, 1, 2),
#'   x   = c(10, 20, 30),
#'   t_x = c(100, 200, 150)
#' )
#'
#' df_y <- tibble::tibble(
#'   id  = c(1, 1, 1, 2, 2),
#'   y   = c(5, 7, 7, 9, 8),
#'   t_y = c(95, 85, 110, 140, 180)
#' )
#'
#' match_in_window(
#'   df_x, df_y,
#'   id = id,
#'   x_value = x, x_time = t_x,
#'   y_value = y, y_time = t_y,
#'   w = 20,
#'   side = "both",
#'   extreme = "max"
#' )
#'
#' @export
match_in_window <- function(
    df_x, df_y,
    id,            # subject id column (present in both data frames)
    x_value,       # variable of interest (in df_x) – used only for context
    x_time,        # test time column for x (numeric, in df_x)
    y_value,       # variable to attach (in df_y)
    y_time,        # test time column for y (numeric, in df_y)
    w,             # numeric window width
    side   = c("both", "prior", "post"),
    extreme = c("max", "min")
) {
  side    <- match.arg(side)
  extreme <- match.arg(extreme)

  id      <- rlang::ensym(id)
  x_value <- rlang::ensym(x_value)
  x_time  <- rlang::ensym(x_time)
  y_value <- rlang::ensym(y_value)
  y_time  <- rlang::ensym(y_time)

  # Tag rows in df_x so we can resolve row-wise matches deterministically.
  x_tagged <- df_x |>
    dplyr::mutate(.row_id___ = dplyr::row_number())

  # Build all candidate pairs for the SAME subject id
  candidates <- x_tagged |>
    dplyr::select(.row_id___, !!id, x_val = !!x_value, x_t = !!x_time) |>
    dplyr::inner_join(
      df_y |>
        dplyr::select(!!id, y_val = !!y_value, y_t = !!y_time),
      by = rlang::as_name(id)
    ) |>
    dplyr::mutate(
      dt     = y_t - x_t,        # positive => y after x
      abs_dt = abs(dt)
    )

  # Keep only candidates within the requested window
  candidates <- {
    if (side == "prior") {
      candidates |>
        dplyr::filter(dt < 0, dt >= -w)
    } else if (side == "post") {
      candidates |>
        dplyr::filter(dt > 0, dt <=  w)
    } else {
      candidates |>
        dplyr::filter(abs_dt <= w)
    }
  }

  # Choose extreme per row of df_x
  ordered <- if (extreme == "max") {
    candidates |>
      dplyr::arrange(dplyr::desc(y_val), abs_dt, y_t)
  } else {
    candidates |>
      dplyr::arrange(y_val, abs_dt, y_t)
  }

  picked <- ordered |>
    dplyr::slice_head(n = 1, .by = .row_id___) |>
    dplyr::select(.row_id___, matched_y = y_val, matched_y_time = y_t)

  # Left-join back
  out <- x_tagged |>
    dplyr::left_join(picked, by = ".row_id___") |>
    dplyr::select(-.row_id___)

  return(out)
}
