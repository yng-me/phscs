#' Philippine Standard Commodity Classification (PSCC)
#'
#' @param token Character. API access token.
#' @param version Character. Version of the PSCC to retrieve. Default is "2022".
#' @param level Character. Level of detail to retrieve. Options are "all", "sections", "chapters", "headings", "commodity". Default is "all".
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' @return A tibble containing the requested PSCC data.
#' @export
#'
#' @examples
#' \dontrun{
#' get_pscc(token = "your_api_token")
#' }

get_pscc <- function(token = NULL, version = NULL, level = NULL, harmonize = TRUE, minimal = TRUE, cols = NULL) {

  level_default <- "commodity"

  arg <- eval_args(
    version = version,
    level = level,
    versions = "2022",
    levels = c("sections", "chapters", "headings", "commodity"),
    level_default
  )

  get_data(
    what = "pscc",
    token = token,
    version = arg$version,
    level = arg$level,
    harmonize = harmonize & level == level_default,
    minimal = minimal,
    cols = cols
  )

}


parse_pscc <- function(data, minimal, col = NULL) {

  clean_text <- function(x) {
    x <- stringr::str_squish(stringr::str_trim(x))
    stringr::str_trim(stringr::str_remove_all(x, "\\-\\s"))
  }

  data <- dplyr::tibble(
    dplyr::transmute(
      data,
      section = section,
      chapter = chapter,
      heading = heading,
      parent_heading_description = clean_text(parent_heading_desc),
      commodity_heading_description = clean_text(commodity_heading_desc),
      commodity = commodity,
      commodity_description = clean_text(commoditydesc),
      version
    )
  )

  if(minimal) {
    data <- dplyr::select(
      data,
      code = commodity,
      label = commodity_description
    )
  }

  data

}
