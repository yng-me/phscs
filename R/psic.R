#' Retrieve Philippine Standard Industrial Classification (PSIC)
#'
#' @param token Character. API access token.
#' @param version Character. Version of the PSIC dataset. Default is \code{"2019"}.
#' @param level Character. Classification level (e.g., \code{"sub-classes"}).
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' @return A data frame of PSIC classifications.
#' @export
#'
#' @examples
#' \dontrun{
#' get_psic(token = "your_api_token")
#' }

get_psic <- function(token = NULL, version = NULL, level = NULL, harmonize = TRUE, minimal = TRUE, cols = NULL) {

  level_default <- "sub-classes"

  arg <- eval_args(
    version = version,
    level = level,
    versions = "2019",
    levels = c("all", "sections", "divisions", "groups", "classes", "sub-classes"),
    level_default
  )

  get_data(
    what = "psic",
    token = token,
    version = arg$version,
    level = arg$level,
    harmonize = harmonize & level == level_default,
    minimal = minimal,
    cols = cols
  )

}

parse_psic <- function(data, minimal, col = NULL) {

  data <- dplyr::tibble(
    dplyr::transmute(
      data,
      id,
      section_code = section,
      division_code = division,
      group_code = groupcode,
      class_code = class_code,
      sub_class_code = subclass,
      title = stringr::str_trim(title),
      description = stringr::str_trim(subclassdesc),
      version
    )
  )

  if(minimal) {
    data <- dplyr::select(
      data,
      code = sub_class_code,
      label = title,
      dplyr::any_of(col)
    )
  }

  data

}
