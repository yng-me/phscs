#' Philippine Standard Commodity Classification System (PSCCS)
#'
#' @param version Character. Version of the PSCCS dataset. Default is the
#'   latest available (\code{"2018"}).
#' @param level Character. Classification level: \code{"all"},
#'   \code{"section"}, \code{"divisions"}, \code{"groups"}, \code{"classes"},
#'   or \code{"sub-classes"} (default).
#' @param minimal Logical. If \code{TRUE} (default), returns only \code{value}
#'   and \code{label} columns.
#' @param cols Optional character vector of additional columns to include
#'   (\code{"description"} is the only extra column available).
#'
#' @return A data frame of PSCCS classifications.
#' @export
#'
#' @references \url{https://psa.gov.ph/classification/psccs}
#'
#' @examples
#' psccs <- get_psccs()
#' psccs_sections <- get_psccs(level = "section")

get_psccs <- function(version = NULL, level = NULL, minimal = TRUE, cols = NULL) {
  arg  <- eval_args("psccs", version, level, "all")
  data <- get_cache("psccs", arg$version)
  get_tidy(data, arg$level, .psccs_level_map, minimal, cols)
}

.psccs_level_map <- list(
  "section"     = 1L,
  "divisions"   = 2L,
  "groups"      = 3L,
  "classes"     = 4L,
  "sub-classes" = 5L,
  "sub_classes" = 5L
)
