#' Philippine Standard Occupational Classification (PSOC)
#'
#' @param ... See \code{?dplyr::filter}. Expressions that return a logical value, and are defined in terms of the variables in returned data. If multiple expressions are included, they are combined with the & operator. Only rows for which all conditions evaluate to TRUE are kept.
#' @param token Character. API access token.
#' @param version Character. Version of the PSOC dataset. Default is \code{NULL}. If \code{NULL}, the latest version is used.
#' @param level Character. Classification level such as \code{"all"}, \code{"major"}, \code{"sub-major"}, \code{"minor"}, and \code{"unit"}.
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' @return A data frame of PSOC classifications.
#' @export
#' @references \url{https://psa.gov.ph/classification/psoc}
#'
#' @examples
#' \dontrun{
#' get_psoc(token = "your_api_token")
#' }
#' # If token is not provided, the function will fetch from local cache or
#' # download the latest version from remote repo
#' psoc <- get_psoc()
#'
#' # Get specific level
#' psoc_filtered <- get_psoc(level = "major")
#' psoc_filtered
#'

get_psoc <- function(..., token = NULL, version = NULL, level = NULL, harmonize = TRUE, minimal = TRUE, cols = NULL) {

  level_default <- "unit"

  arg <- eval_args(
    what = "psoc",
    version = version,
    level = level,
    level_default
  )

  get_data(
    what = "psoc",
    version = arg$version,
    level = arg$level,
    ...,
    token = token,
    harmonize = harmonize & level == level_default,
    minimal = minimal,
    cols = cols
  )

}


parse_psoc <- function(data, minimal, col = NULL) {

  data |>
    dplyr::transmute(
      id,
      major__value = as.character(majorcode),
      major__label = clean_text(major_title),
      major__description = clean_text(majordesc),
      sub_major__value = as.character(submajorcode),
      sub_major__label = clean_text(submajor_title),
      sub_major__description = clean_text(submajordesc),
      minor__value = as.character(minorcode),
      minor__label = clean_text(minor_title),
      minor__description = clean_text(minor_desc),
      unit__value = as.character(unitcode),
      unit__label = clean_text(unit_title),
      unit__description = clean_text(unitdesc)
    ) |>
    tidyr::pivot_longer(-id) |>
    dplyr::mutate(
      level = stringr::str_split_i(name, '__', 1),
      col = stringr::str_split_i(name, '__', 2),
    ) |>
    dplyr::select(-name) |>
    tidyr::pivot_wider(names_from = col, values_from = value) |>
    dplyr::select(-id) |>
    dplyr::filter(!is.na(value)) |>
    dplyr::distinct(value, .keep_all = T) |>
    dplyr::mutate(
      level = dplyr::case_when(
        level == "major" ~ 1L,
        level == "sub_major" ~ 2L,
        level == "minor" ~ 3L,
        level == "unit" ~ 4L,
        TRUE ~ NA_integer_
      ),
      label = stringr::str_to_sentence(label)
    ) |>
    dplyr::filter(!is.na(level)) |>
    dplyr::arrange(level)

}


get_tidy_psoc <- function(data, level, minimal, cols = NULL) {

  if(level == "major") {
    data <- dplyr::filter(data, level == 1L)
  } else if(level == "sub-major" | level == "sub_major") {
    data <- dplyr::filter(data, level == 2L)
  } else if(level == "minor") {
    data <- dplyr::filter(data, level == 3L)
  } else if(level == "unit") {
    data <- dplyr::filter(data, level == 4L)
  }

  if(minimal) {
    data <- dplyr::select(
      data,
      value,
      label,
      dplyr::any_of(cols)
    )
  }

  data

}
