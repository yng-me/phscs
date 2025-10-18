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

get_pcpc <- function(token = NULL, version = NULL, level = NULL, harmonize = TRUE, minimal = TRUE, cols = NULL) {

  level_default <- "all"

  arg <- eval_args(
    version = version,
    level = level,
    versions = "2022",
    levels = c("all", "sections", "divisions", "groups", "classes", "sub-classes", "item"),
    level_default
  )

  get_data(
    what = "pcpc",
    token = token,
    version = arg$version,
    level = arg$level,
    harmonize = harmonize & level == level_default,
    minimal = minimal,
    cols = cols
  )

}


parse_pcpc <- function(data, minimal, col = NULL) {

  data <- dplyr::tibble(
    dplyr::rename(
      data,
      division_code = divisioncode,
      division_description = division_desc,
      group_code = groupcode,
      group_description = groupdesc,
      class_code = classcode,
      class_description = classdesc,
      subclasscode = subclasscode,
      sub_class_title = subclass_title,
      sub_classdesc = subclassdesc,
      item_code = itemcode,
      item_description = itemdesc
    )
  )

  if(minimal) {
    data <- dplyr::select(
      data,
      code = item_code,
      label = item_title
    )
  }

  data

}
