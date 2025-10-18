#' Retrieve Philippine Standard Classification of Education (PSCED)
#'
#' @param token Character. API access token.
#' @param version Character. Version of the PSCED dataset. Default is \code{"2017"}.
#' @param level Character. Classification level. Default is \code{"detailedfield"}.
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' @return A data frame of PSCED classifications.
#' @export
#'
#' @examples
#' \dontrun{
#' get_psced(token = "your_api_token")
#' }

get_psced <- function(token = NULL, version = NULL, level = NULL, harmonize = TRUE, minimal = TRUE, cols = NULL) {

  level_default <- "detailedfield"

  arg <- eval_args(
    version = version,
    level = level,
    versions = "2017",
    levels = c("all", "levels", "broadfield", "narrowfield", "detailedfield"),
    level_default
  )

  get_data(
    what = "psced",
    token = token,
    version = arg$version,
    level = arg$level,
    harmonize = harmonize & level == level_default,
    minimal = minimal,
    cols = cols
  )

}


parse_psced <- function(data, minimal, cols = NULL) {

  data <- dplyr::tibble(
    dplyr::transmute(
      data,
      level,
      code = paste0(broadfield, detailedfield),
      broad_field = broadfield,
      narrow_field = narrowfield,
      detailed_field = detailedfield,
      title = stringr::str_trim(detailedfield_title),
      description = stringr::str_trim(detailedfielddesc),
      version
    )
  )

  if(minimal) {
    data <- dplyr::transmute(
      data,
      code,
      label = title
    )
  }

  data

}
