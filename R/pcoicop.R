#' Philippine Classification of Individual Consumption According to Purpose (PCOICOP)
#'
#' @param ... See \code{?dplyr::filter}. Expressions that return a logical value, and are defined in terms of the variables in returned data. If multiple expressions are included, they are combined with the & operator. Only rows for which all conditions evaluate to TRUE are kept.
#' @param token Character. API access token.
#' @param version Character. Version of the PCOICOP to retrieve. Default is \code{NULL}. If \code{NULL}, the latest version is used.
#' @param level Character. Level of detail to retrieve. Options are \code{"all"}, \code{"divisions"}, \code{"groups"}, \code{"class"}, \code{"sub-class"}, \code{"item"}, and \code{"subitem"}.
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' @return A tibble containing the requested PCOICOP data.
#' @export
#'
#' @references \url{https://psa.gov.ph/classification/pcoicop}
#'
#' @examples
#' \dontrun{
#' get_pcoicop(token = "your_api_token")
#' }
#' # If token is not provided, the function will fetch from local cache or
#' # download the latest version from remote repo
#' pcoicop <- get_pcoicop()
#'
#' # Get specific level
#' pcoicop_filtered <- get_pcoicop(level = "divisions")
#' pcoicop_filtered


get_pcoicop <- function(..., token = NULL, version = NULL, level = NULL, harmonize = TRUE, minimal = TRUE, cols = NULL) {

  level_default <- "all"

  arg <- eval_args(
    what = "pcoicop",
    version = version,
    level = level,
    level_default
  )

  get_data(
    what = "pcoicop",
    version = arg$version,
    level = arg$level,
    ...,
    token = token,
    harmonize = harmonize & level == level_default,
    minimal = minimal,
    cols = cols
  )

}


parse_pcoicop <- function(data, minimal = FALSE, col = NULL) {

  data |>
    dplyr::transmute(
      id,
      division__value = clean_text(division),
      division__label = division_title |>
        clean_text() |>
        stringr::str_to_sentence() |>
        stringr::str_remove_all("\\(npishs\\)") |>
        clean_text(),
      division__description = divisiondesc |>
        clean_text(),
      group__value = clean_text(group),
      group__label = group_title |>
        clean_text() |>
        stringr::str_to_sentence() |>
        stringr::str_replace(" \\(s\\)$", ""),
      group__description = clean_text(groupdesc),
      class__value = clean_text(class_code),
      class__label = clean_text(class_title),
      class__description = clean_text(classdesc),
      sub_class__value = clean_text(subclass),
      sub_class__label = clean_text(subclass_title),
      sub_class__description = clean_text(subclassdesc),
      item__value = clean_text(item),
      item__label = clean_text(item_title),
      item__description = clean_text(itemdesc)
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
        level == "division" ~ 1L,
        level == "group" ~ 2L,
        level == "class" ~ 3L,
        level == "sub_class" ~ 4L,
        level == "item" ~ 5L,
        level == "sub_item" ~ 6L,
        TRUE ~ NA_integer_
      ),
      description = clean_text(description) |>
        stringr::str_remove_all('^\\"|\\"$') |>
        clean_text()
    ) |>
    dplyr::arrange(level) |>
    dplyr::select(
      level,
      value,
      label,
      dplyr::any_of(cols)
    )

}


get_tidy_pcoicop <- function(data, level, minimal, cols = NULL) {

  if(level == "divisions") {
    data <- dplyr::filter(data, level == 1L)
  } else if(level == "groups") {
    data <- dplyr::filter(data, level == 2L)
  } else if(level == "class") {
    data <- dplyr::filter(data, level == 3L)
  } else if(level == "sub-class" | level == "sub_class") {
    data <- dplyr::filter(data, level == 4L)
  } else if(level == "item") {
    data <- dplyr::filter(data, level == 5L)
  } else if(level == "sub_item" | level == "subitem") {
    data <- dplyr::filter(data, level == 6L)
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
