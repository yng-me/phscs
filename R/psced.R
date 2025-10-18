#' Philippine Standard Classification of Education (PSCED)
#'
#' @param ... See \code{?dplyr::filter}. Expressions that return a logical value, and are defined in terms of the variables in returned data. If multiple expressions are included, they are combined with the & operator. Only rows for which all conditions evaluate to TRUE are kept.
#' @param token Character. API access token.
#' @param version Character. Version of the PSCED dataset. Default is \code{NULL}. If \code{NULL}, the latest version is used.
#' @param level Character. Classification levels such as \code{"all"}, \code{"levels"}, \code{"broadfield"}, \code{"narrowfield"}, and \code{"detailedfield"}. Default is \code{"detailedfield"}.
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' @return A data frame of PSCED classifications.
#' @export
#'
#' @references \url{https://psa.gov.ph/classification/psced}
#'
#' @examples
#' \dontrun{
#' get_psced(token = "your_api_token")
#' }
#' # If token is not provided, the function will fetch from local cache or
#' # download the latest version from remote repo
#' psced <- get_psced()
#'
#' # Get specific level
#' psced_filtered <- get_psced(level = "levels")
#' psced_filtered


get_psced <- function(..., token = NULL, version = NULL, level = NULL, harmonize = TRUE, minimal = TRUE, cols = NULL) {

  level_default <- "detailedfield"

  arg <- eval_args(
    what = "psced",
    version = version,
    level = level,
    level_default
  )

  get_data(
    what = "psced",
    version = arg$version,
    level = arg$level,
    ...,
    token = token,
    harmonize = harmonize & level == level_default,
    minimal = minimal,
    cols = cols
  )

}


parse_psced <- function(data, minimal = TRUE, cols = NULL) {

  data |>
    dplyr::transmute(
      id,
      level__value = clean_text(level),
      level__label = clean_text(level_title),
      broad_field__value = clean_text(broadfield),
      broad_field__label = clean_text(broadfield_title),
      broad_field__description = clean_text(broadfielddesc),
      narrow_field__value = clean_text(narrowfield),
      narrow_field__label = clean_text(narrowfield_title),
      narrow_field__description = clean_text(narrowfielddesc),
      detailed_field__value = clean_text(detailedfield),
      detailed_field__label = clean_text(detailedfield_title),
      detailed_field__description = clean_text(detailedfielddesc)
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
        level == "level" ~ 1L,
        level == "broad_field" ~ 2L,
        level == "narrow_field" ~ 3L,
        level == "detailed_field" ~ 4L,
        TRUE ~ NA_integer_
      )
    ) |>
    dplyr::filter(!is.na(level)) |>
    dplyr::arrange(level)

}


get_tidy_psced <- function(data, level, minimal, cols = NULL) {

  if(level == "levels") {
    data <- dplyr::filter(data, level == 1L)
  } else if(level == "broadfield") {
    data <- dplyr::filter(data, level == 2L)
  } else if(level == "narrowfield") {
    data <- dplyr::filter(data, level == 3L)
  } else if(level == "detailedfield") {
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
