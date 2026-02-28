#' Initiate DLM environment
#'
#' @name init_DLM
#' @rdname init_DLM
#' @keywords internal
#' @importFrom utils installed.packages
#' @importFrom devtools install_github
#' @export
init_DLM <- function() {
  pkg_install(Cs(tictoc, pROC, survminer))
  if (!"dynamicLM" %in% rownames(utils::installed.packages())) {
    devtools::install_github("thehanlab/dynamicLM")
  }
  set.seed(42)

  ## params
  day_1yr <<- 365.25
  day_1mo <<- day_1yr / 12
  outcome <<- list(time = "time", status = "status")
}

#' Generate DLM formula from selected variables
#'
#' @name dlm_mk_fm
#' @rdname dlm_mk_fm
#' @keywords internal
#' @export
dlm_mk_fm <- function(var = NULL) {
  glue::glue(
    "{LHS} ~ {RHS}",
    LHS = "Hist(time, status, LM)",
    RHS1 = paste(var, collapse = " + "),
    RHS2 = paste(c("LM1", "LM2", "cluster(subject_id)"), collapse = " + "),
    RHS = paste(RHS1, RHS2, sep = " + "),
  ) |>
  stats::as.formula()
}

#' Generate stacked LM data
#'
#' @name dlm_mk_lmdata
#' @rdname dlm_mk_lmdata
#' @keywords internal
#' @export
dlm_mk_lmdata <- function(df = NULL,
                          lms = NULL,
                          w = 90,
                          cov_list = NULL,
                          cov_interact = NULL,
                          id = "subject_id",
                          rtime = "ah_dpt",
                          func_covars = "linear",
                          func_lms = c("linear", "quadratic")
                          ) {
  df |>
    dynamicLM::stack_data(
      outcome,
      lms,
      w,
      cov_list,
      format = "long",
      id = id,
      rtime = rtime
    ) |>
    dynamicLM::add_interactions(
      cov_interact,
      func_covars = func_covars,
      func_lms = func_lms
    )
}
