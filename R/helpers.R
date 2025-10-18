get_base_uri <- function(which) {
  base_uri <- getOption('rcbms.options')$classification_base_uri
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
  token = NULL,
  harmonize = TRUE,
  minimal = TRUE,
  cols = NULL
) {

  if(is.null(token)) {

    get_data_from_cache(
      what = what,
      version = version,
      level = level,
      harmonize = harmonize,
      minimal = minimal,
      cols = cols
    )

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


get_data_from_cache <- function(
  what,
  version,
  level,
  token = NULL,
  harmonize = TRUE,
  minimal = TRUE,
  cols = NULL
) {

  path <- file.path(
    "extdata",
    what,
    version,
    glue::glue("{what}_{level}.parquet")
  )

  file <- system.file(path, package = "phscs")

  if(file.exists(file)) {
    dplyr::collect(arrow::open_dataset(file))
  } else {
    get_data_from_remote(
      file,
      path,
      what = what,
      version = version,
      level = level,
      token = token,
      harmonize = harmonize,
      minimal = minimal,
      cols = cols
    )
  }

}


get_data_from_remote <- function(
  file,
  path,
  what,
  version,
  level,
  token = NULL,
  harmonize = TRUE,
  minimal = TRUE,
  cols = NULL
) {

  utils::download.file(
    glue::glue("https://github.com/yng-me/rcdf/tree/main/inst/{path}"),
    file
  )

  dplyr::collect(arrow::open_dataset(file))

}



tidy_pgcs <- function(data, geographic_level, ...) {
  dplyr::transmute(
    data,
    area_code = psgc_code,
    correspondence_code = dplyr::if_else(stringr::str_trim(correspondence_code) == "", NA_character_, stringr::str_trim(correspondence_code)),
    area_name,
    area_name_old = dplyr::if_else(stringr::str_trim(old_name) == "", NA_character_, stringr::str_trim(old_name)),
    urban_rural = dplyr::if_else(stringr::str_trim(urban_rural) == "", NA_character_, stringr::str_trim(urban_rural)),
    island_region = stringr::str_trim(island_region),
    geographic_level = geographic_level,
    population_data = purrr::map(population_data, \(x) {
      jsonlite::fromJSON(x) |> dplyr::select(year, population)
    })
  )
}

