#' Philippine Classification of Individual Consumption According to Purpose (PCOICOP)
#'
#' @param token Character. API access token.
#' @param version Character. Version of the PCOICOP to retrieve. Default is "2020".
#' @param level Character. Level of detail to retrieve. Options are "all", "divisions", "groups", "class", "sub-class", "item", "subitem". Default is "all".
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' @return A tibble containing the requested PCOICOP data.
#' @export
#'
#' @examples
#' \dontrun{
#' get_pcoicop(token = "your_api_token")
#' }

get_pcoicop <- function(token = NULL, version = "2020", level = "all", harmonize = TRUE, minimal = TRUE, cols = NULL) {

  level_default <- "all"

  arg <- eval_args(
    version = version,
    level = level,
    versions = c("2020", "2009"),
    levels = c( "all", "divisions", "groups", "class", "sub-class", "item", "subitem"),
    level_default
  )

  get_data(
    what = "pcoicop",
    token = token,
    version = arg$version,
    level = arg$level,
    harmonize = harmonize & level == level_default,
    minimal = minimal,
    cols = cols
  )

}


parse_pcoicop <- function(data, minimal, col = NULL) {

  data <- dplyr::tibble(
    dplyr::rename(
      data,
      division_title = division_title,
      division_description = divisiondesc,
      group_description = groupdesc,
      class_description = classdesc,
      sub_class = subclass,
      sub_class_title = subclass_title,
      sub_class_description = subclassdesc,
      item_description = itemdesc,
      sub_item = subitem,
      sub_item_description = subitemdesc
    )
  )

  if(minimal) {
    data <- dplyr::select(
      data,
      code = sub_item,
      label = sub_item_description
    )
  }

  data

}
