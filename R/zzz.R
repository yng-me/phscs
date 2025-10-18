utils::globalVariables(
  c(
    ".",
    ":=",
    "division_title",
    "divisiondesc",
    "groupdesc",
    "classdesc",
    "subclass",
    "subclass_title",
    "subclassdesc",
    "itemdesc",
    "subitem",
    "subitemdesc",
    "sub_item",
    "variable",
    "sub_item_description",
    "divisioncode",
    "division_desc",
    "groupcode",
    "classcode",
    "subclasscode",
    "itemcode",
    "item_code",
    "item_title",
    "section",
    "chapter",
    "heading",
    "area_code",
    "id",
    "division",
    "class_code",
    "title",
    "sub_class_code",
    "majorcode",
    "submajorcode",
    "minorcode",
    "unitcode",
    "title",
    "description",
    "code_unit",
    "area_name",
    "bgy",
    "broadfield",
    "city_class",
    "code",
    "commodity",
    "commodity_description",
    "commodity_heading_desc",
    "commoditydesc",
    "correspondence_code",
    "detailedfield",
    "detailedfield_title",
    "detailedfielddesc",
    "income_classification",
    "island_region",
    "level",
    "mun",
    "narrowfield",
    "old_name",
    "parent_heading_desc",
    "population",
    "population_data",
    "prv",
    "psgc_code",
    "reg",
    "sectioncode",
    "sectiondesc",
    "status",
    "sub_class_title",
    "urban_rural"
  )
)


.onLoad <- function(libname, pkgname) {
  op <- options()
  op.rcbms <- list(
    rcbms.options = list(
      classification_base_uri = "https://classification.psa.gov.ph"
    )
  )

  to_set <- !(names(op.rcbms) %in% names(op))
  if (any(to_set)) options(op.rcbms[to_set])

  invisible()
}
