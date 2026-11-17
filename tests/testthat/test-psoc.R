test_that("get_psoc retrieves data correctly", {

  psoc_data <- get_psoc()

  expect_s3_class(psoc_data, "data.frame")
  expect_equal(dim(psoc_data), c(455, 2))
  expect_identical(names(psoc_data), c("value", "label"))

  psoc_data_major <- get_psoc(level = "major")
  expect_equal(dim(psoc_data_major), c(10, 2))

  # codes are as in the source files (armed forces unit "110", no leading zero)
  expect_true("110" %in% psoc_data$value)

})
