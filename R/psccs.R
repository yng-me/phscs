#' Philippine Standard Classification of Crime for Statistical Purposes (PSCCS)
#'
#' @param token Character. API access token.
#' @param version Character. Version of the PSCCS to retrieve. Default is "2018".
#' @param level Character. Level of detail to retrieve. Options are "all", "section", "divisions", "groups", "classes", "sub-classes". Default is "all".
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' @return A tibble containing the requested PSCCS data.
#' @export
#'
#' @examples
#' \dontrun{
#' get_psccs(token = "your_api_token")
#' }

get_psccs <- function(token = NULL, version = NULL, level = NULL, harmonize = TRUE, minimal = TRUE, cols = NULL) {

  level_default <- "all"

  arg <- eval_args(
    version = version,
    level = level,
    versions = "2018",
    levels = c("all", "section", "divisions", "groups", "classes", "sub-classes"),
    level_default
  )

  get_data(
    what = "psccs",
    token = token,
    version = arg$version,
    level = arg$level,
    harmonize = harmonize & level == level_default,
    minimal = minimal,
    cols = cols
  )

}


parse_psccs <- function(data, minimal, col = NULL) {

  data <- dplyr::tibble(
    dplyr::rename(
      data,
      section_code = sectioncode,
      section_description = sectiondesc,
      division_code = divisioncode,
      division_description = divisiondesc,
      group_code = groupcode,
      group_description = groupdesc,
      class_code = classcode,
      class_description = classdesc,
      sub_class_code = subclasscode,
      sub_class_title = subclass_title,
      subclassdesc = subclassdesc
    )
  )

  if(minimal) {
    data <- dplyr::select(
      data,
      code = sub_class_code,
      label = sub_class_title
    )
  }

  data

}
