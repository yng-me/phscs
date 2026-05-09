#' Philippine Central Product Classification (PCPC)
#'
#' @param version Character. Version of the PCPC dataset. Default is the
#'   latest available (\code{"2002"}).
#' @param level Character. Classification level: \code{"all"},
#'   \code{"sections"}, \code{"divisions"}, \code{"groups"}, \code{"classes"},
#'   \code{"sub-classes"}, or \code{"item"} (default).
#' @param minimal Logical. If \code{TRUE} (default), returns only \code{value}
#'   and \code{label} columns.
#' @param cols Optional character vector of additional columns to include
#'   (\code{"description"} is the only extra column available).
#'
#' @return A data frame of PCPC classifications.
#' @export
#' @references \url{https://psa.gov.ph/classification/pcpc}
#'
#' @examples
#' pcpc <- get_pcpc()
#' pcpc_sections <- get_pcpc(level = "sections")

get_pcpc <- function(version = NULL, level = NULL, minimal = TRUE, cols = NULL) {
  arg  <- eval_args("pcpc", version, level, "all")
  data <- get_cache("pcpc", arg$version)
  get_tidy(data, arg$level, .pcpc_level_map, minimal, cols)
}

.pcpc_level_map <- list(
  "sections"    = 1L,
  "divisions"   = 2L,
  "groups"      = 3L,
  "classes"     = 4L,
  "sub-classes" = 5L,
  "item"        = 6L
)
