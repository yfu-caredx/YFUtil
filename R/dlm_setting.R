#' Initiate DLM environment
#'
#' @name init_DLM
#' @rdname init_DLM
#' @keywords internal
#' @importFrom utils installed.packages
#' @importFrom devtools install_github
#' @export
init_DLM <- function() {
  pkg_install(c("tictoc", "pROC", "survminer"))
  if (!"dynamicLM" %in% rownames(utils::installed.packages())) {
    devtools::install_github("thehanlab/dynamicLM")
  }
  set.seed(42)

  ## params
  assign("day_1yr", 365.25, envir = .GlobalEnv)
  assign("day_1mo", get("day_1yr", envir = .GlobalEnv) / 12, envir = .GlobalEnv)
  assign("outcome", list(time = "time", status = "status"), envir = .GlobalEnv)
}

#' Generate DLM formula from selected variables
#'
#' @name dlm_mk_fm
#' @rdname dlm_mk_fm
#' @keywords internal
#' @export
dlm_mk_fm <- function(var = NULL) {
  rhs_1 <- paste(var, collapse = " + ")
  rhs_2 <- paste(c("LM1", "LM2", "cluster(subject_id)"), collapse = " + ")
  rhs <- paste(rhs_1, rhs_2, sep = " + ")
  stats::as.formula(paste("Hist(time, status, LM)", rhs, sep = " ~ "))
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
  outcome_obj <- get0(
    "outcome",
    envir = .GlobalEnv,
    ifnotfound = list(time = "time", status = "status")
  )

  df |>
    dynamicLM::stack_data(
      outcome_obj,
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
