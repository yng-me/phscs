#' Philippine Standard Geographic Code (PSGC)
#'
#' @description Re-exported from the \code{psgc} package. See
#'   \code{\link[psgc]{get_psgc}} for full documentation.
#'
#' @inheritParams psgc::get_psgc
#'
#' @return A data frame of PSGC geographic data.
#' @export
#' @importFrom psgc get_psgc
#'
#' @references \url{https://psa.gov.ph/classification/psgc}
#'
#' @examples
#' psgc <- get_psgc()
#' psgc_regions <- get_psgc(geographic_level = "region")
get_psgc <- psgc::get_psgc

