#' Shorten region name
#'
#' @description This function shortens the region names in a PSGC data frame.
#'
#' @param data A data frame containing PSGC data.
#' @param which Character. Specifies whether to shorten the region name by
#'   label or number. Options are \code{"label"} or \code{"number"}.
#' @param col Character. The name of the column containing the area names.
#'   Default is \code{"area_name"}.
#'
#' @returns A data frame with the region names shortened based on the specified
#'   \code{which} argument.
#' @export
#'
#' @examples
#' regions <- get_psgc(geographic_level = "region")
#' shorten_region_name(regions)
#' shorten_region_name(regions, which = "number")

shorten_region_name <- function(data, which = c("label", "number"), col = "area_name") {

  which <- match.arg(which)
  x <- data[[col]]

  if (which == "label") {

    has_paren <- grepl("\\(", x)
    extracted <- regmatches(x, regexpr("\\(.*?\\)", x))
    extracted <- gsub("[()]", "", extracted)
    data[[col]] <- ifelse(has_paren, extracted[match(seq_along(x), which(has_paren))], x)

  } else {

    has_region <- grepl("^Region |Region$", x)
    has_paren  <- grepl("\\(", x)

    result <- x

    # Regions with "(label)" → extract inside parens
    extract_paren <- function(s) gsub("[()]", "", regmatches(s, regexpr("\\(.*?\\)", s)))

    # Regions starting with "Region " → extract the roman/number after it
    strip_region <- function(s) {
      s2 <- sub("^Region ", "", s)
      sub(" .*", "", s2)
    }

    for (i in seq_along(x)) {
      if (has_region[i]) {
        result[i] <- strip_region(x[i])
      } else if (has_paren[i]) {
        m <- regexpr("\\(.*?\\)", x[i])
        result[i] <- gsub("[()]", "", regmatches(x[i], m))
      }
    }

    data[[col]] <- result
  }

  data
}
