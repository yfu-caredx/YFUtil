#' Print a styled message
#'
#' @param msg The message to print.
#' @export
fancy_message <- \(msg) cat(paste0("\u2728 ", msg, "\n"))

#' Get File Name Without Path And File Extension
#'
#' Get the file name without leading directory path and without file extensions
#' @param filepath The full file path, or a file name
#' @export
filename_sans_ext <- \(filepath) tools::file_path_sans_ext(basename(filepath))
