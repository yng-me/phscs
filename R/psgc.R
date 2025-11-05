#' Philippine Standard Geographic Code (PSGC)
#'
#' @param ... See \code{?dplyr::filter}. Expressions that return a logical value, and are defined in terms of the variables in returned data. If multiple expressions are included, they are combined with the & operator. Only rows for which all conditions evaluate to TRUE are kept.
#' @param token Character. API access token. If \code{NULL}, retrieves data from the local cache.
#' @param version Character. PSGC version such as: \code{"Q3_2025"}, \code{"July_2025"}, \code{"Q2_2025"}, \code{"Q1_2025"}, \code{"April_2024"}, \code{"Q4_2024"}, \code{"Q3_2024"}, \code{"Q2_2024"}, and \code{"Q4_2023"}, \code{"Q2_2021"}. If \code{NULL}, retrieves the latest version available in the local cache.
#' @param level Character. Level of geographic data to retrieve. Available options are: \code{"all"}, \code{"regions"}, \code{"provinces"}, \code{"hucs"} \code{"municipalities"}, \code{"sub_municipalities"} \code{"barangays"}, \code{"income_classification"}, \code{"urban_rural"}, and \code{"city_class"}.
#' @param harmonize Logical. If \code{TRUE}, formats and standardizes the returned data. Default is \code{TRUE}.
#' @param minimal Logical. If \code{TRUE}, returns a simplified dataset. Default is \code{TRUE}.
#' @param cols Optional. Character vector of additional columns to include when \code{minimal = FALSE}.
#'
#' @return A data frame of PSGC geographic data.
#' @export
#'
#' @references \url{https://psa.gov.ph/classification/psgc}
#'
#' @examples
#' \dontrun{
#' get_psgc(token = "your_api_token")
#' }
#'
#' # If token is not provided, the function will fetch from local cache or
#' # download the latest version from remote repo
#' psgc <- get_psgc()
#'
#' # Get specific level
#' psgc_regions <- get_psgc(level = "regions")
#' psgc_regions
#'

get_psgc <- function(
  ...,
  token = NULL,
  version = NULL,
  level = NULL,
  harmonize = TRUE,
  minimal = TRUE,
  cols = NULL
) {

  level_default <- "all"

  arg <- eval_args(
    what = "psgc",
    version = version,
    level = level,
    level_default
  )

  if(is.null(token)) {

    data <- get_data_from_cache(
      what = "psgc",
      version = arg$version,
      ...
    )

    data <- get_tidy_psgc(data, level = arg$level, minimal = minimal, cols = cols)

    return(data)

  }

  if(arg$level %in% c("hucs", "cities", "sub_municipalities")) {
    agrg$level <- "all"
  }

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
        stringr::str_trim(geographic_level) == "SubMun" ~ 5L,
        stringr::str_trim(geographic_level) == "Bgy" ~ 6L,
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
      urban_rural = dplyr::if_else(
        stringr::str_trim(urban_rural) == "",
        NA_character_,
        stringr::str_trim(urban_rural)
      ),
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
        "population_data",
        cols
      )
    )
  )

}

get_tidy_psgc <- function(data, level, minimal, cols = NULL) {

  if(level == "regions") {
    data <- dplyr::filter(data, geographic_level == 1)
  } else if(level == "provinces") {
    data <- dplyr::filter(data, geographic_level == 2)
  } else if(level == "huc" | level == "hucs") {
    data <- dplyr::filter(data, city_class == "HUC")
  } else if(level == "cities") {
    data <- dplyr::filter(data, geographic_level == 3)
  } else if(level == "municipalities") {
    data <- dplyr::filter(data, geographic_level == 4)
  } else if(level == "sub_municipalities") {
    data <- dplyr::filter(data, geographic_level == 5)
  } else if(level == "barangays") {
    data <- dplyr::filter(data, geographic_level == 6)
  }

  if(minimal) {
    data <- dplyr::select(
      data,
      area_code,
      area_code_old = correspondence_code,
      area_name,
      dplyr::any_of(cols)
    )
  }

  data
}

