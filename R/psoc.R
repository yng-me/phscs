#' Retrieve Philippine Standard Occupational Classification (PSOC)
#'
#' @param token Character. API access token.
#' @param version Character. Version of the PSOC dataset. Default is \code{"2012"}.
#' @param level Character. Classification level (e.g., \code{"unit"}).
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' @return A data frame of PSOC classifications.
#' @export
#'
#' @examples
#' \dontrun{
#' get_psoc(token = "your_api_token")
#' }

get_psoc <- function(token = NULL, version = NULL, level = NULL, harmonize = TRUE, minimal = TRUE, cols = NULL) {

  level_default <- "unit"

  arg <- eval_args(
    version = version,
    level = level,
    versions = "2012",
    levels = c("all", "major", "sub-major", "minor", "unit"),
    level_default
  )

  get_data(
    what = "psoc",
    token = token,
    version = arg$version,
    level = arg$level,
    harmonize = harmonize & level == level_default,
    minimal = minimal,
    cols = cols
  )

}


parse_psoc <- function(data, minimal, col = NULL) {

  data <- dplyr::tibble(
    dplyr::transmute(
      data,
      code_major = majorcode,
      code_sub_major = stringr::str_pad(submajorcode, width = 2, pad = "0"),
      code_minor = stringr::str_pad(minorcode, width = 3, pad = "0"),
      code_unit = stringr::str_pad(unitcode, width = 4, pad = "0"),
      title = stringr::str_trim(title),
      description = stringr::str_trim(description),
      version
    )
  )

  if(minimal) {
    data <- dplyr::select(
      data,
      code = code_unit,
      label = title
    )
  }

  data

}
