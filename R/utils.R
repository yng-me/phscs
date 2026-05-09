clean_text <- function(x) {
  x <- trimws(x)
  x <- gsub("\\s+", " ", x)
  ifelse(is.na(x) | x == "", NA_character_, x)
}

to_sentence <- function(x) {
  ifelse(
    is.na(x),
    NA_character_,
    paste0(toupper(substr(x, 1, 1)), tolower(substring(x, 2)))
  )
}

