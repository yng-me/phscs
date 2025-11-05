test_that("get_psgc retrieves data correctly", {

  skip_if_offline(host = "github.com")

  psgc_data <- get_psgc()

  expect_s3_class(psgc_data, "data.frame")
  expect_equal(dim(psgc_data), c(43769, 3))
  expect_identical(names(psgc_data), c("area_code", "area_code_old", "area_name"))

  psgc_data_with_cols <- get_psgc(cols = "geographic_level")
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
  expect_equal(dim(psgc_data), c(43769, 13))

})

test_that("get_psgc retrieves data correctly with additional filter", {

  skip_if_offline(host = "github.com")

  psgc_data <- get_psgc(grepl("^10", area_code))
  expect_equal(dim(psgc_data), c(2121, 3))

})

