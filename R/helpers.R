eval_args <- function(what, version, level, level_default) {
  opts     <- getOption("phscs.options")
  versions <- opts$versions[[what]]
  levels   <- opts$levels[[what]]

  if (is.null(version) || tolower(version) == "latest") version <- versions[[1]]
  if (is.null(level)) level <- level_default

  version <- match.arg(version, versions)
  level   <- match.arg(level, levels)

  list(version = version, level = level)
}


get_cache <- function(what, version) {
  data_list <- get(paste0("phscs_", what), envir = asNamespace("phscs"))
  data_list[[version]]
}


get_tidy <- function(data, level, level_map, minimal, cols) {
  if (level != "all") {
    level_int <- level_map[[level]]
    if (!is.null(level_int)) {
      data <- data[data[["level"]] == level_int, , drop = FALSE]
    }
  }
  if (minimal) {
    keep <- c("value", "label", intersect(cols, names(data)))
    data <- data[, keep, drop = FALSE]
  }
  rownames(data) <- NULL
  data
}

