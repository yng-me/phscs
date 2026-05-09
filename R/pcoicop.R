#' Philippine Classification of Individual Consumption According to Purpose (PCOICOP)
#'
#' @param version Character. Version of the PCOICOP dataset. Default is the
#'   latest available (\code{"2020"}). Use \code{"2009"} for the 2009 edition.
#' @param level Character. Classification level: \code{"all"},
#'   \code{"divisions"}, \code{"groups"}, \code{"class"}, \code{"sub-class"},
#'   \code{"item"}, or \code{"subitem"} (default).
#' @param minimal Logical. If \code{TRUE} (default), returns only \code{value}
#'   and \code{label} columns.
#' @param cols Optional character vector of additional columns to include
#'   (\code{"description"} is the only extra column available).
#'
#' @return A data frame of PCOICOP classifications.
#' @export
#'
#' @references \url{https://psa.gov.ph/classification/pcoicop}
#'
#' @examples
#' pcoicop <- get_pcoicop()
#' pcoicop_divisions <- get_pcoicop(level = "divisions")

get_pcoicop <- function(version = NULL, level = NULL, minimal = TRUE, cols = NULL) {
  arg  <- eval_args("pcoicop", version, level, "all")
  data <- get_cache("pcoicop", arg$version)
  get_tidy(data, arg$level, .pcoicop_level_map, minimal, cols)
}

.pcoicop_level_map <- list(
  "divisions"  = 1L,
  "groups"     = 2L,
  "class"      = 3L,
  "sub-class"  = 4L,
  "sub_class"  = 4L,
  "item"       = 5L,
  "subitem"    = 6L,
  "sub_item"   = 6L
)

