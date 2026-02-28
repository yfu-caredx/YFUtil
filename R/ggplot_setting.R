#' Initiate ggplot environment
#'
#' @name init_ggplot
#' @rdname init_ggplot
#' @keywords internal
#' @importFrom ggpubr ggarrange
#' @export
init_ggplot <- function() {
  # pkg_install(cowplot, ggplot2)
  pacman::p_load(ggplot2, cowplot)
  ## ggplot theme setting
  # theme_set(theme_bw())
  theme_set(theme_cowplot(font_size = 12))
  theme_update(plot.title = element_text(hjust = 0.5))
  theme_update(plot.subtitle = element_text(hjust = 0.5))

  color_palette_greenred <- colorRampPalette(
    c(
      "#85af5e",
      "#DCDC30",
      "#f6e041",
      "#ff9a00",
      "#ff7400",
      "#f70a0a",
      "#a60000",
      "#520101"
    )
  )
}


#' Arrange Multiple ggplots
#'
#' @name ggarrange
#' @rdname ggarrange
#' @keywords internal
#' @importFrom ggpubr ggarrange
#' @export
NULL
