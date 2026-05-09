#' Philippine Standard Classification of Education (PSCED)
#'
#' @param version Character. Version of the PSCED dataset. Default is the
#'   latest available (\code{"2017"}).
#' @param level Character. Classification level: \code{"all"},
#'   \code{"levels"}, \code{"broadfield"}, \code{"narrowfield"}, or
#'   \code{"detailedfield"} (default).
#' @param minimal Logical. If \code{TRUE} (default), returns only \code{value}
#'   and \code{label} columns.
#' @param cols Optional character vector of additional columns to include
#'   (\code{"description"} is the only extra column available).
#'
#' @return A data frame of PSCED classifications.
#' @export
#'
#' @references \url{https://psa.gov.ph/classification/psced}
#'
#' @examples
#' psced <- get_psced()
#' psced_levels <- get_psced(level = "levels")

get_psced <- function(version = NULL, level = NULL, minimal = TRUE, cols = NULL) {
  arg  <- eval_args("psced", version, level, "detailedfield")
  data <- get_cache("psced", arg$version)
  get_tidy(data, arg$level, .psced_level_map, minimal, cols)
}

.psced_level_map <- list(
  "levels"        = 1L,
  "broadfield"    = 2L,
  "narrowfield"   = 3L,
  "detailedfield" = 4L
)

