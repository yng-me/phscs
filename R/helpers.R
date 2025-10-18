get_base_uri <- function(which) {
  base_uri <- getOption('phscs.options')$classification_base_uri
  paste0(base_uri, "/", which)
}

get_uri <- function(which, version = NULL, level, token) {
  uri <- get_base_uri(which)
  if(is.null(version)) {
    glue::glue("{uri}/{level}?token={token}")
  } else {
    glue::glue("{uri}/{version}/{level}?token={token}")
  }
}


get_data <- function(
  what,
  version,
  level,
  ...,
  token = NULL,
  harmonize = TRUE,
  minimal = TRUE,
  cols = NULL
) {

  if(is.null(token)) {

    data <- get_data_from_cache(
      what = what,
      version = version,
      level = level,
      ...
    )

    parse_tidy_fn <- eval(parse(text = paste0("get_tidy_", what)))

    data <- parse_tidy_fn(data, level = level, minimal = minimal, cols = cols)

    return(data)

  }

  uri <- get_uri(what, version, level, token)

  df_res <- jsonlite::read_json(uri, simplifyVector = T)
  df_next <- df_res[['next']]
  df <- df_res$results
  df_n <- nrow(df)
  df_counter <- 1

  parse_fn <- eval(parse(text = paste0("parse_", what)))

  if(harmonize) { df <- parse_fn(df, minimal, cols) }

  while (!is.null(df_next)) {

    df_counter <- df_counter + 1
    cli::cli_status("Fetching {(df_n * (df_counter - 1)) + 1}-{df_n * df_counter} record...")

    df_i_res <- jsonlite::read_json(df_next, simplifyVector = T)
    df_i <- df_i_res$results
    if(harmonize) { df_i <- parse_fn(df_i, minimal, cols) }
    df <- dplyr::bind_rows(df, df_i)
    df_n <- nrow(df_i)
    df_next <- df_i_res[['next']]
  }

  cli::cli_status_clear()

  df

}


get_data_from_cache <- function(what, version, level, ...) {

  filename <- glue::glue("{what}_{tolower(version)}.parquet")

  path <- system.file(package = "phscs")
  if(!grepl("inst", path)) {
    path <- file.path(path, "inst", "extdata")
  } else {
    path <- file.path(path, "extdata")
  }

  if(!dir.exists(path)) { dir.create(path, recursive = TRUE) }
  file <- file.path(path, filename)

  if(file.exists(file)) {
    data <- arrow::open_dataset(file)
  } else {
    data <- get_data_from_remote(path = file, filename = filename)
  }

  dplyr::collect(dplyr::filter(data, ...))

}


get_data_from_remote <- function(path, filename, ...) {
  url <- glue::glue("https://github.com/yng-me/phscs/raw/refs/heads/main/parquet/{filename}")
  utils::download.file(url, path, quiet = TRUE)

  arrow::open_dataset(path)

}
