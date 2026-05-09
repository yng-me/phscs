#' Philippine Standard Industrial Classification (PSIC)
#'
#' @param version Character. Version of the PSIC dataset. Default is the
#'   latest available (\code{"2019"}).
#' @param level Character. Classification level: \code{"all"},
#'   \code{"sections"}, \code{"divisions"}, \code{"groups"}, \code{"classes"},
#'   or \code{"sub-classes"} (default).
#' @param minimal Logical. If \code{TRUE} (default), returns only \code{value}
#'   and \code{label} columns.
#' @param cols Optional character vector of additional columns to include
#'   (\code{"description"} is the only extra column available).
#'
#' @return A data frame of PSIC classifications.
#' @export
#'
#' @references \url{https://psa.gov.ph/classification/psic}
#'
#' @examples
#' psic <- get_psic()
#' psic_sections <- get_psic(level = "sections")

get_psic <- function(version = NULL, level = NULL, minimal = TRUE, cols = NULL) {
  arg  <- eval_args("psic", version, level, "sub-classes")
  data <- get_cache("psic", arg$version)
  get_tidy(data, arg$level, .psic_level_map, minimal, cols)
}

.psic_level_map <- list(
  "sections"    = 1L,
  "divisions"   = 2L,
  "groups"      = 3L,
  "classes"     = 4L,
  "sub-classes" = 5L,
  "sub_classes" = 5L
)

