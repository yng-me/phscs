#' Shorten region name
#'
#' @description This function shortens the region names in a PSGC data frame.
#'
#'
#' @param data A data frame containing PSGC data.
#' @param which Character. Specifies whether to shorten the region name by label or number. Options are \code{"label"} or \code{"number"}.
#' @param col Character. The name of the column containing the area names. Default is \code{"area_name"}.
#'
#' @returns A data frame with the region names shortened based on the specified \code{which} argument.
#' @export
#'
#' @examples
#' regions <- get_psgc(level = "regions")
#' shorten_region_name(regions)
#' shorten_region_name(regions, which = "number")

shorten_region_name <- function(data, which = c("label", "number"), col = "area_name") {

  match.arg(which, c("label", "number"))

  if(which[1] == "label") {

    dplyr::mutate(
      data,
      !!as.name(col) := dplyr::if_else(
        grepl("\\(", !!as.name(col)),
        stringr::str_remove_all(stringr::str_extract(!!as.name(col), "\\(.*?\\)"), "[\\(\\)]"),
        !!as.name(col)
      )
    )

  } else if (which[1] == "number") {

    dplyr::mutate(
      data,
      !!as.name(col) := dplyr::if_else(
        grepl("^Region | Region$", !!as.name(col)),
        stringr::str_split_i(stringr::str_remove_all(!!as.name(col), "^Region |" ), pattern = " ", i = 1),
        dplyr::if_else(
          grepl("\\(", !!as.name(col)),
          stringr::str_remove_all(stringr::str_extract(!!as.name(col), "\\(.*?\\)"), "[\\(\\)]"),
          !!as.name(col)
        )
      )
    )

  }
}
