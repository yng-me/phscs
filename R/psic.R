#' Philippine Standard Industrial Classification (PSIC)
#'
#' @param ... See \code{?dplyr::filter}. Expressions that return a logical value, and are defined in terms of the variables in returned data. If multiple expressions are included, they are combined with the & operator. Only rows for which all conditions evaluate to TRUE are kept.
#' @param token Character. API access token.
#' @param version Character. Version of the PSIC dataset. Default is \code{NULL}. If \code{NULL}, the latest version is used.
#' @param level Character. Classification level such as \code{"all"}, \code{"sections"}, \code{"divisions"}, \code{"groups"}, \code{"classes"}, and \code{"sub-classes"}.
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' @return A data frame of PSIC classifications.
#' @export
#'
#' @references \url{https://psa.gov.ph/classification/psic}
#'
#' @examples
#' \dontrun{
#' get_psic(token = "your_api_token")
#' }
#' # If token is not provided, the function will fetch from local cache or
#' # download the latest version from remote repo
#' psic <- get_psic()
#'
#' # Get specific level
#' psic_filtered <- get_psic(level = "sections")
#' psic_filtered

get_psic <- function(..., token = NULL, version = NULL, level = NULL, harmonize = TRUE, minimal = TRUE, cols = NULL) {

  level_default <- "sub-classes"

  arg <- eval_args(
    what = "psic",
    version = version,
    level = level,
    level_default
  )

  get_data(
    what = "psic",
    version = arg$version,
    level = arg$level,
    ...,
    token = token,
    harmonize = harmonize & level == level_default,
    minimal = minimal,
    cols = cols
  )

}


parse_psic <- function(data, minimal = TRUE, col = NULL) {

  data |>
    dplyr::transmute(
      id,
      section__value = clean_text(section),
      section__label = clean_text(section_title),
      section__description = clean_text(sectiondesc),
      division__value = clean_text(division),
      division__label = clean_text(division_title),
      division__description = clean_text(division_desc),
      group__value = clean_text(groupcode),
      group__label = clean_text(group_title),
      group__description = clean_text(groupdesc),
      class__value = clean_text(classcode),
      class__label = clean_text(class_title),
      class__description = clean_text(classdesc),
      sub_class__value = clean_text(subclasscode),
      sub_class__label = clean_text(subclass_title),
      sub_class__description = clean_text(subclassdesc)
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
        level == "section" ~ 1L,
        level == "division" ~ 2L,
        level == "group" ~ 3L,
        level == "class" ~ 4L,
        level == "sub_class" ~ 5L,
        TRUE ~ NA_integer_
      )
    ) |>
    dplyr::filter(!is.na(level)) |>
    dplyr::arrange(level)

}


get_tidy_psic <- function(data, level, minimal = TRUE, cols = NULL) {

  if(level == "sections") {
    data <- dplyr::filter(data, level == 1L)
  } else if(level == "divisions") {
    data <- dplyr::filter(data, level == 2L)
  } else if(level == "groups") {
    data <- dplyr::filter(data, level == 3L)
  } else if(level == "classes") {
    data <- dplyr::filter(data, level == 4L)
  } else if(level == "sub-classes" | level == "sub_classes") {
    data <- dplyr::filter(data, level == 5L)
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
