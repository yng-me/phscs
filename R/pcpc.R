#' Philippine Central Product Classification (PCPC)
#'
#' @param token Character. API access token.
#' @param version Character. Version of the PCPC to retrieve. Default is "2002".
#' @param level Character. Level of detail to retrieve. Options are "all", "sections", "divisions", "groups", "classes", "sub-classes", "item". Default is "all".
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' @return A tibble containing the requested PCPC data.
#' @export
#'
#' @examples
#' \dontrun{
#' get_pcpc(token = "your_api_token")
#' }

get_pcpc <- function(..., token = NULL, version = NULL, level = NULL, harmonize = TRUE, minimal = TRUE, cols = NULL) {

  level_default <- "all"

  arg <- eval_args(
    what = "pcpc",
    version = version,
    level = level,
    level_default
  )

  get_data(
    what = "pcpc",
    version = arg$version,
    level = arg$level,
    ...,
    token = token,
    harmonize = harmonize & level == level_default,
    minimal = minimal,
    cols = cols
  )

}


parse_pcpc <- function(data, minimal = TRUE, col = NULL) {

  data |>
    dplyr::transmute(
      id,
      section__value = clean_text(section),
      section__label = stringr::str_to_sentence(clean_text(section_title)),
      division__value = clean_text(divisioncode),
      division__label = stringr::str_to_sentence(clean_text(division_title)),
      division__description = clean_text(division_desc),
      group__value = clean_text(groupcode),
      group__label = clean_text(group_title),
      group__description = clean_text(groupdesc),
      class__value = clean_text(classcode),
      class__label = clean_text(class_title),
      class__description = clean_text(classdesc),
      sub_class__value = clean_text(subclasscode),
      sub_class__label = clean_text(subclass_title),
      subclass__description = clean_text(subclassdesc),
      item__value = clean_text(itemcode),
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
        level == "section" ~ 1L,
        level == "division" ~ 2L,
        level == "group" ~ 3L,
        level == "class" ~ 4L,
        level == "sub_class" ~ 5L,
        level == "item" ~ 6L,
        TRUE ~ NA_integer_
      )
    ) |>
    dplyr::filter(!is.na(level)) |>
    dplyr::arrange(level)

}


get_tidy_pcpc <- function(data, level, minimal, cols = NULL) {

  if(level == "sections") {
    data <- dplyr::filter(data, level == 1L)
  } else if(level == "divisions") {
    data <- dplyr::filter(data, level == 2L)
  } else if(level == "groups") {
    data <- dplyr::filter(data, level == 3L)
  } else if(level == "classes") {
    data <- dplyr::filter(data, level == 4L)
  } else if(level == "sub-classes") {
    data <- dplyr::filter(data, level == 5L)
  } else if(level == "item") {
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


