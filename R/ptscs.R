#' Philippine Tourism Statistical Classification System (PTSCS)
#'
#' @description Returns a PTSCS list with columns \code{id}, \code{category_id},
#'   \code{description} (the category name) and \code{keywords}.
#'
#' @param type Character. Which list to return: \code{"industries"} (default),
#'   the tourism characteristic industries, or \code{"products"}, the tourism
#'   characteristic products. The two lists reuse the same codes.
#'
#' @return A data frame of PTSCS classifications. For industries,
#'   \code{keywords} is a list column of the comma-separated keywords; for
#'   products, it is the original \dQuote{Includes ...} text, unchanged.
#' @export
#'
#' @references \url{https://psa.gov.ph/classification/ptsc}
#'
#' @examples
#' ptscs <- get_ptscs()
#' ptscs_products <- get_ptscs(type = "products")

get_ptscs <- function(type = c("industries", "products")) {
  phscs_ptscs[[match.arg(type)]]
}
