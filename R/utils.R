eval_args <- function(what, version, level, level_default) {

  options <- getOption("phscs.options")
  versions <- options$versions[[what]]
  levels <- options$levels[[what]]

  if(is.null(version)) { version <- versions[1] }
  if(tolower(version) == "latest") { version <- versions[1] }
  if(is.null(level)) { level <- level_default }

  match.arg(version, versions)
  match.arg(level, levels)

  list(
    version = version,
    level = level
  )

}

fill_with_previous_value <- function(data, col, replacer, col_name = "new_indicator",  indicator = NULL) {

  value <- dplyr::pull(dplyr::select(data, {{col}}))

  with_value <- which(!is.na(value))
  if(!is.null(indicator)) {
    with_value <- which(value == indicator)
  }

  value_to_replace <- dplyr::pull(dplyr::select(data, {{replacer}}))

  if(with_value[1] > 1) {
    rep_n <- with_value[1] - 1
    value_to_replace <- c(
      rep(NA_character_, rep_n),
      value_to_replace[(with_value[1]):length(value)]
    )
    with_value <- c(1L, with_value)
  }

  new_value <- list()

  with_value <- unique(c(with_value, length(value)))
  with_value_offset <- with_value[1:(length(with_value) - 1)]

  for(i in seq_along(with_value_offset)) {

    from <- with_value[i]
    to <- with_value[i + 1] - 1
    if(i == length(with_value_offset)) {
      to <- to + 1
    }

    new_value[[i]] <- rep(
      value_to_replace[from],
      length(from:to)
    )
  }

  data[[col_name]] <- unlist(new_value)

  data

}


clean_text <- function(x) {
  x <- stringr::str_squish(stringr::str_trim(x))
  dplyr::if_else(x == "", NA_character_, x)
}
