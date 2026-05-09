.onLoad <- function(libname, pkgname) {
  op <- options()
  op.phscs <- list(
    phscs.options = list(
      versions = list(
        pcoicop = c("2020", "2009"),
        pcpc    = "2002",
        psccs   = "2018",
        psced   = "2017",
        psic    = "2019",
        psoc    = "2012"
      ),
      levels = list(
        pcoicop = c("all", "divisions", "groups", "class", "sub-class", "item", "subitem"),
        pcpc    = c("all", "sections", "divisions", "groups", "classes", "sub-classes", "item"),
        psccs   = c("all", "section", "divisions", "groups", "classes", "sub-classes"),
        psced   = c("all", "levels", "broadfield", "narrowfield", "detailedfield"),
        psic    = c("all", "sections", "divisions", "groups", "classes", "sub-classes"),
        psoc    = c("all", "major", "sub-major", "minor", "unit")
      )
    )
  )

  to_set <- !(names(op.phscs) %in% names(op))
  if (any(to_set)) options(op.phscs[to_set])

  invisible()
}

