#' Retrieve Philippine Standard Geographic Code (PSGC)
#'
#' @param token Character. API access token.
#' @param version Character. PSGC version such as: \code{July_2025}, \code{Q2_2025}, \code{Q1_2025}, \code{April_2024}, \code{Q4_2024}, \code{Q3_2024}, \code{Q2_2024}, and \code{Q4_2023}, \code{Q2_2021}.
#' @param level Character. Level of geographic data to retrieve. Available options are: \code{all}, \code{regions}, \code{provinces}, \code{municipalities}, \code{barangays}, \code{income_classification}, \code{urban_rural}, and \code{city_clas}..
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' Geographic levels
#' 0 - country
#' 1 - island group
#' 2 - region
#' 3 - province
#' 5 - highly urbanized city
#' 6 - city
#' 7 - municipality
#' 8 - district
#' 9 - barangay

#' @return A data frame of PSGC geographic data.
#' @export
#'
#' @examples
#' \dontrun{
#' get_psgc(token = "your_api_token")
#' }
#'



get_psgc <- function(token = NULL, version = NULL, level = NULL, harmonize = TRUE, minimal = TRUE, cols = NULL) {

  versions <- c("July_2025", "Q3_2025", "Q2_2025", "Q1_2025", "April_2024", "Q4_2024", "Q3_2024", "Q2_2024", "Q4_2023", "Q1_2023", "Q2_2021")
  levels <- c("all", "regions", "provinces", "municipalities", "barangays", "income_classification", "urban_rural", "city_class")
  level_default <- "all"

  arg <- eval_args(
    version = version,
    level = level,
    versions = versions,
    levels = levels,
    level_default
  )

  uri <- get_uri("psgc", arg$version, arg$level, token)
  df_res <- jsonlite::read_json(uri, simplifyVector = T)
  df_next <- df_res[['next']]
  df <- df_res$results$psgc_data
  df_n <- nrow(df)
  df_counter <- 1

  if(arg$level == level_default) {
    cols <- unique(c("level", cols))
  }

  if(harmonize) { df <- parse_psgc(df, minimal, cols) }

  while (!is.null(df_next)) {

    df_counter <- df_counter + 1
    cli::cli_status("Fetching {(df_n * (df_counter - 1)) + 1}-{df_n * df_counter} record...")

    df_i_res <- jsonlite::read_json(df_next, simplifyVector = T)
    df_i <- df_i_res$results$psgc_data
    if(harmonize) { df_i <- parse_psgc(df_i, minimal, cols) }
    df <- dplyr::bind_rows(df, df_i)
    df_n <- nrow(df_i)
    df_next <- df_i_res[['next']]
  }

  cli::cli_status_clear()

  df

}


parse_psgc <- function(data, minimal = FALSE, cols = NULL) {

  data <- dplyr::tibble(
    dplyr::transmute(
      data,
      area_code = psgc_code,
      area_name = stringr::str_squish(stringr::str_trim(area_name)),
      geographic_level = dplyr::case_when(
        stringr::str_trim(geographic_level) == "Reg" ~ 1L,
        stringr::str_trim(geographic_level) == "Prov" ~ 2L,
        stringr::str_trim(geographic_level) == "City" ~ 3L,
        stringr::str_trim(geographic_level) == "Mun" ~ 4L,
        stringr::str_trim(geographic_level) == "SubMun" ~ 6L,
        stringr::str_trim(geographic_level) == "Bgy" ~ 7L,
        TRUE ~ NA_integer_
      ),
      region_code = stringr::str_pad(reg, width = 2, pad = "0"),
      province_code = stringr::str_pad(prv, width = 3, pad = "0"),
      city_mun_code = stringr::str_pad(mun, width = 2, pad = "0"),
      barangay_code = stringr::str_pad(bgy, width = 3, pad = "0"),
      area_name_old = dplyr::if_else(
        stringr::str_trim(old_name) == "",
        NA_character_,
        stringr::str_squish(stringr::str_trim(old_name))
      ),
      city_class = dplyr::if_else(
        stringr::str_trim(city_class) == "",
        NA_character_,
        stringr::str_trim(city_class)
      ),
      income_class = dplyr::if_else(
        stringr::str_trim(income_classification) == "",
        NA_character_,
        stringr::str_trim(income_classification)
      ),
      urban_rural,
      island_region,
      status,
      version,
      correspondence_code = stringr::str_trim(correspondence_code),
      correspondence_code = dplyr::if_else(
        correspondence_code == "",
        NA_character_,
        correspondence_code
      ),
      income_class = as.integer(stringr::str_extract(income_class, "\\d+")),
      urban_rural = dplyr::if_else(stringr::str_trim(urban_rural) == "", NA_character_, stringr::str_trim(urban_rural)),
      island_region = dplyr::case_when(
        island_region == "L" ~ 1L,
        island_region == "V" ~ 2L,
        island_region == "M" ~ 3L,
        TRUE ~ NA_integer_
      ),
      urban_rural = dplyr::case_when(
        urban_rural == "U" ~ 1L,
        urban_rural == "R" ~ 2L,
        TRUE ~ NA_integer_
      ),
      population_data = purrr::map(population_data, \(x) {

        if(is.character(x)) {
          y <- jsonlite::fromJSON(x)
          if(length(y) == 0) {
            y <- data.frame(
              year = integer(0),
              population = integer(0)
            )
          }

          if(!("population" %in% names(y))) {
            y$population <- NA_integer_
          }

          dplyr::select(y, year, population)

        } else {

          if("population" %in% names(x)) {
            dplyr::mutate(
              x,
              population = suppressWarnings(
                as.integer(stringr::str_remove_all(population, ","))
              )
            )
          } else {
            x
          }

        }
      })
    )
  )

  if(minimal) {

    data <- dplyr::select(
      data,
      area_code,
      area_code_old = correspondence_code,
      area_name,
      dplyr::any_of(cols)
    )
  }

  dplyr::select(
    data,
    dplyr::any_of(
      c(
        "area_code",
        "correspondence_code",
        "area_name",
        "area_name_old",
        "region_code",
        "province_code",
        "city_mun_code",
        "barangay_code",
        "geographic_level",
        "island_region",
        "urban_rural",
        "income_class",
        "city_class",
        "population_data"
      )
    )
  )

}


shorten_region_name <- function(data, col, which = "label") {

  if(which == "label") {

    dplyr::mutate(
      data,
      {{col}} := dplyr::if_else(
        grepl("\\(", {{col}}),
        stringr::str_remove_all(stringr::str_extract({{col}}, "\\(.*?\\)"), "[\\(\\)]"),
        {{col}}
      )
    )

  } else if (which == "number") {

    dplyr::mutate(
      data,
      {{col}} := dplyr::if_else(
        grepl("^Region | Region$", {{col}}),
        stringr::str_split_i(stringr::str_remove_all({{col}}, "^Region |" ), pattern = " ", i = 1),
        dplyr::if_else(
          grepl("\\(", {{col}}),
          stringr::str_remove_all(stringr::str_extract({{col}}, "\\(.*?\\)"), "[\\(\\)]"),
          {{col}}
        )
      )
    )

  }
}


