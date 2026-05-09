#' Philippine Standard Occupational Classification (PSOC)
#'
#' @param version Character. Version of the PSOC dataset. Default is the
#'   latest available (\code{"2012"}).
#' @param level Character. Classification level: \code{"all"}, \code{"major"},
#'   \code{"sub-major"}, \code{"minor"}, or \code{"unit"} (default).
#' @param minimal Logical. If \code{TRUE} (default), returns only \code{value}
#'   and \code{label} columns.
#' @param cols Optional character vector of additional columns to include
#'   (\code{"description"} is the only extra column available).
#'
#' @return A data frame of PSOC classifications.
#' @export
#' @references \url{https://psa.gov.ph/classification/psoc}
#'
#' @examples
#' psoc <- get_psoc()
#' psoc_major <- get_psoc(level = "major")

get_psoc <- function(version = NULL, level = NULL, minimal = TRUE, cols = NULL) {
  arg  <- eval_args("psoc", version, level, "unit")
  data <- get_cache("psoc", arg$version)
  get_tidy(data, arg$level, .psoc_level_map, minimal, cols)
}

.psoc_level_map <- list(
  "major"     = 1L,
  "sub-major" = 2L,
  "sub_major" = 2L,
  "minor"     = 3L,
  "unit"      = 4L
)

