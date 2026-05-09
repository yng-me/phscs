test_that("get_psgc is re-exported from psgc and returns a data frame", {

  skip_if_not_installed("psgc")

  psgc_data <- get_psgc()

  expect_s3_class(psgc_data, "data.frame")
  expect_true("code" %in% names(psgc_data) || "area_code" %in% names(psgc_data) || ncol(psgc_data) > 0)

})


test_that("get_psgc accepts geographic_level argument", {

  skip_if_not_installed("psgc")

  psgc_regions <- get_psgc(geographic_level = "region")
  expect_s3_class(psgc_regions, "data.frame")
  expect_gt(nrow(psgc_regions), 0)

})

