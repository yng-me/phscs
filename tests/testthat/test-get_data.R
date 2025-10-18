test_that("get_psgc retrieves data correctly", {

  skip_if_offline(host = "github.com")

  psgc_data <- get_psgc()

  expect_s3_class(psgc_data, "data.frame")
  expect_equal(dim(psgc_data), c(43769, 3))
  expect_identical(names(psgc_data), c("area_code", "area_code_old", "area_name"))

  psgc_data_with_cols <- get_psgc(cols = "population_data")
  expect_equal(dim(psgc_data_with_cols), c(43769, 4))

})


test_that("get_psgc retrieves data correctly using different levels", {

  skip_if_offline(host = "github.com")

  psgc_regions <- get_psgc(level = "regions")
  expect_equal(dim(psgc_regions), c(18, 3))

  psgc_provinces <- get_psgc(level = "provinces")
  expect_equal(dim(psgc_provinces), c(82, 3))


})


test_that("get_psgc retrieves data correctly with minimal set to FALSE", {

  skip_if_offline(host = "github.com")

  psgc_data <- get_psgc(minimal = FALSE)
  expect_equal(dim(psgc_data), c(43769, 14))

})

test_that("get_psgc retrieves data correctly with additional filter", {

  skip_if_offline(host = "github.com")

  psgc_data <- get_psgc(grepl("^10", area_code))
  expect_equal(dim(psgc_data), c(2121, 3))

})


test_that("get_psic retrieves data correctly", {

  skip_if_offline(host = "github.com")

  psic_data <- get_psic()

  expect_s3_class(psic_data, "data.frame")
  expect_equal(dim(psic_data), c(1360, 2))
  expect_identical(names(psic_data), c("value", "label"))

  psic_data_sections <- get_psic(level = "sections")
  expect_equal(dim(psic_data_sections), c(21, 2))

})


test_that("get_psoc retrieves data correctly", {

  skip_if_offline(host = "github.com")

  psoc_data <- get_psoc()

  expect_s3_class(psoc_data, "data.frame")
  expect_equal(dim(psoc_data), c(455, 2))
  expect_identical(names(psoc_data), c("value", "label"))

  psoc_data_major <- get_psoc(level = "major")
  expect_equal(dim(psoc_data_major), c(10, 2))

})



test_that("get_psced retrieves data correctly", {

  skip_if_offline(host = "github.com")

  psced_data <- get_psced()

  expect_s3_class(psced_data, "data.frame")
  expect_equal(dim(psced_data), c(754, 2))
  expect_identical(names(psced_data), c("value", "label"))

  psced_data_levels <- get_psced(level = "levels")
  expect_equal(dim(psced_data_levels), c(9, 2))

})


test_that("get_pcoicop retrieves data correctly", {

  skip_if_offline(host = "github.com")

  pcoicop_data <- get_pcoicop()

  expect_s3_class(pcoicop_data, "data.frame")
  expect_equal(dim(pcoicop_data), c(3468, 2))
  expect_identical(names(pcoicop_data), c("value", "label"))

  pcoicop_data_divisions <- get_pcoicop(level = "divisions")
  expect_equal(dim(pcoicop_data_divisions), c(15, 2))

})


test_that("get_pcpc retrieves data correctly", {

  skip_if_offline(host = "github.com")

  pcpc_data <- get_pcpc()

  expect_s3_class(pcpc_data, "data.frame")
  expect_equal(dim(pcpc_data), c(8705, 2))
  expect_identical(names(pcpc_data), c("value", "label"))

  pcpc_data_sections <- get_pcpc(level = "sections")
  expect_equal(dim(pcpc_data_sections), c(10, 2))

})



