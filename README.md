# YFUtil

Personal R utility package for analysis setup, plotting presets, data wrangling helpers, and small convenience functions.

## Install from GitHub

```r
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
remotes::install_github("yfu-caredx/YFUtil", ref = "dev")
```

## Quick start

```r
library(YFUtil)

init_environment()
init_ggplot()
```

## Main exported helpers

- `init_environment()`: install/load common packages and set global options.
- `init_ggplot()`: apply `cowplot`-based ggplot defaults.
- `match_in_window()`: match extreme values in a time window between two tables.
- `stats_count_pct()`: one-way frequency table with percentages.
- `num2chr_r1()` / `num2chr_r2()`: round and convert numerics to character.
- `%w/%` / `%w/o%`: intersection and asymmetric difference helpers.

## Notes

- `init_DLM()` and DLM helpers rely on `dynamicLM`, which is installed from GitHub when needed.
- This package is intended for personal workflows rather than CRAN submission.
