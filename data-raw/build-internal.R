## data-raw/build-internal.R
## Reads all classification JSON files and saves them as internal package data.
## Requires: jsonlite, usethis (both in Suggests)
##
## Run from the package root: Rscript data-raw/build-internal.R

library(jsonlite)

# ── Helpers ───────────────────────────────────────────────────────────────────

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

# Parse a de-normalised JSON data frame into a tidy (level, value, label,
# description) data frame. `specs` is a list of named lists, each with:
#   level_int : integer level code
#   value_col : column name for the classification code
#   label_col : column name for the human-readable label (or NULL)
#   desc_col  : column name for the description (or NULL)
#   label_fn  : optional function applied to the label vector
parse_tidy <- function(df, specs) {
  empty <- data.frame(
    level = integer(0), value = character(0),
    label = character(0), description = character(0),
    stringsAsFactors = FALSE
  )
  result <- vector("list", length(specs))
  for (i in seq_along(specs)) {
    s     <- specs[[i]]
    val   <- clean_text(as.character(df[[s$value_col]]))
    lab   <- if (!is.null(s$label_col)) clean_text(df[[s$label_col]]) else val
    if (!is.null(s$label_fn)) lab <- s$label_fn(lab)
    desc  <- if (!is.null(s$desc_col))  clean_text(df[[s$desc_col]])  else NA_character_

    keep  <- !is.na(val) & nzchar(val)
    if (!any(keep)) {
      result[[i]] <- empty
      next
    }
    tmp   <- data.frame(
      level       = s$level_int,
      value       = val[keep],
      label       = lab[keep],
      description = if (length(desc) > 1L) desc[keep] else desc,
      stringsAsFactors = FALSE
    )
    tmp <- tmp[!duplicated(tmp$value), ]
    result[[i]] <- tmp
  }
  out <- do.call(rbind, result)
  rownames(out) <- NULL
  out
}

load_json <- function(path) {
  jsonlite::fromJSON(path, simplifyVector = TRUE)
}

# ── PSIC ──────────────────────────────────────────────────────────────────────

parse_psic <- function(df) {
  parse_tidy(df, list(
    list(level_int = 1L, value_col = "section",     label_col = "section_title",  desc_col = NULL),
    list(level_int = 2L, value_col = "division",    label_col = "division_title",  desc_col = "division_desc"),
    list(level_int = 3L, value_col = "groupcode",   label_col = "group_title",     desc_col = "groupdesc"),
    list(level_int = 4L, value_col = "classcode",   label_col = "class_title",     desc_col = "classdesc"),
    list(level_int = 5L, value_col = "subclasscode", label_col = "subclass_title", desc_col = "subclassdesc")
  ))
}

message("Building PSIC...")
phscs_psic <- list(
  "2019" = parse_psic(load_json("data-raw/psic/2019-all.json"))
)
message("  PSIC 2019: ", nrow(phscs_psic[["2019"]]), " rows")

# ── PSOC ──────────────────────────────────────────────────────────────────────

parse_psoc <- function(df) {
  parse_tidy(df, list(
    list(level_int = 1L, value_col = "majorcode",    label_col = "major_title",    desc_col = "majordesc",    label_fn = to_sentence),
    list(level_int = 2L, value_col = "submajorcode", label_col = "submajor_title", desc_col = "submajordesc", label_fn = to_sentence),
    list(level_int = 3L, value_col = "minorcode",    label_col = "minor_title",    desc_col = "minor_desc",   label_fn = to_sentence),
    list(level_int = 4L, value_col = "unitcode",     label_col = "unit_title",     desc_col = "unitdesc",     label_fn = to_sentence)
  ))
}

message("Building PSOC...")
phscs_psoc <- list(
  "2012" = parse_psoc(load_json("data-raw/psoc/2012-all.json"))
)
message("  PSOC 2012: ", nrow(phscs_psoc[["2012"]]), " rows")

# ── PCPC ──────────────────────────────────────────────────────────────────────

parse_pcpc <- function(df) {
  parse_tidy(df, list(
    list(level_int = 1L, value_col = "section",      label_col = "section_title",   desc_col = NULL,          label_fn = to_sentence),
    list(level_int = 2L, value_col = "divisioncode", label_col = "division_title",  desc_col = "division_desc", label_fn = to_sentence),
    list(level_int = 3L, value_col = "groupcode",    label_col = "group_title",     desc_col = "groupdesc"),
    list(level_int = 4L, value_col = "classcode",    label_col = "class_title",     desc_col = "classdesc"),
    list(level_int = 5L, value_col = "subclasscode", label_col = "subclass_title",  desc_col = "subclassdesc"),
    list(level_int = 6L, value_col = "itemcode",     label_col = "item_title",      desc_col = "itemdesc")
  ))
}

message("Building PCPC...")
phscs_pcpc <- list(
  "2002" = parse_pcpc(load_json("data-raw/pcpc/2002-all.json"))
)
message("  PCPC 2002: ", nrow(phscs_pcpc[["2002"]]), " rows")

# ── PSCED ─────────────────────────────────────────────────────────────────────
# Note: JSON column "level" is the education level code; renamed to avoid clash.

parse_psced <- function(df) {
  names(df)[names(df) == "level"] <- "level_code"
  parse_tidy(df, list(
    list(level_int = 1L, value_col = "level_code",      label_col = "level_title",          desc_col = NULL),
    list(level_int = 2L, value_col = "broadfield",      label_col = "broadfield_title",     desc_col = "broadfielddesc"),
    list(level_int = 3L, value_col = "narrowfield",     label_col = "narrowfield_title",    desc_col = "narrowfielddesc"),
    list(level_int = 4L, value_col = "detailedfield",   label_col = "detailedfield_title",  desc_col = "detailedfielddesc")
  ))
}

message("Building PSCED...")
phscs_psced <- list(
  "2017" = parse_psced(load_json("data-raw/psced/2017-all.json"))
)
message("  PSCED 2017: ", nrow(phscs_psced[["2017"]]), " rows")

# ── PCOICOP ───────────────────────────────────────────────────────────────────

parse_pcoicop <- function(df) {
  # Division label: sentence case, remove "(npishs)"
  div_label_fn <- function(x) {
    x <- to_sentence(x)
    x <- gsub("\\(npishs\\)", "", x, ignore.case = TRUE)
    clean_text(x)
  }
  # Group label: sentence case, remove trailing " (s)"
  grp_label_fn <- function(x) {
    x <- to_sentence(x)
    x <- sub(" \\(s\\)$", "", x)
    clean_text(x)
  }

  parse_tidy(df, list(
    list(level_int = 1L, value_col = "division",    label_col = "division_title",  desc_col = "divisiondesc",   label_fn = div_label_fn),
    list(level_int = 2L, value_col = "group",       label_col = "group_title",     desc_col = "groupdesc",      label_fn = grp_label_fn),
    list(level_int = 3L, value_col = "class_code",  label_col = "class_title",     desc_col = "classdesc"),
    list(level_int = 4L, value_col = "subclass",    label_col = "subclass_title",  desc_col = "subclassdesc"),
    list(level_int = 5L, value_col = "item",        label_col = "item_title",      desc_col = "itemdesc"),
    list(level_int = 6L, value_col = "subitem",     label_col = NULL,              desc_col = "subitemdesc")
  ))
}

message("Building PCOICOP...")
phscs_pcoicop <- list(
  "2020" = parse_pcoicop(load_json("data-raw/pcoicop/2020-all.json")),
  "2009" = parse_pcoicop(load_json("data-raw/pcoicop/2009-all.json"))
)
message("  PCOICOP 2020: ", nrow(phscs_pcoicop[["2020"]]), " rows")
message("  PCOICOP 2009: ", nrow(phscs_pcoicop[["2009"]]), " rows")

# ── PSCCS ─────────────────────────────────────────────────────────────────────

parse_psccs <- function(df) {
  parse_tidy(df, list(
    list(level_int = 1L, value_col = "sectioncode",  label_col = "section_title",   desc_col = "sectiondesc"),
    list(level_int = 2L, value_col = "divisioncode", label_col = "division_title",  desc_col = "divisiondesc"),
    list(level_int = 3L, value_col = "groupcode",    label_col = "group_title",     desc_col = "groupdesc"),
    list(level_int = 4L, value_col = "classcode",    label_col = "class_title",     desc_col = "classdesc"),
    list(level_int = 5L, value_col = "subclasscode", label_col = "subclass_title",  desc_col = "subclassdesc")
  ))
}

message("Building PSCCS...")
phscs_psccs <- list(
  "2018" = parse_psccs(load_json("data-raw/psccs/2018-all.json"))
)
message("  PSCCS 2018: ", nrow(phscs_psccs[["2018"]]), " rows")

# ── Save internal data ────────────────────────────────────────────────────────

message("Saving internal data...")
usethis::use_data(
  phscs_psic,
  phscs_psoc,
  phscs_pcpc,
  phscs_psced,
  phscs_pcoicop,
  phscs_psccs,
  internal  = TRUE,
  overwrite = TRUE,
  compress  = "xz"
)
message("Done. R/sysdata.rda written.")
