# Silence R CMD check note for dplyr-created helper column names.
if (getRversion() >= "2.15.1") {
  utils::globalVariables(c(".row_id___"))
}
