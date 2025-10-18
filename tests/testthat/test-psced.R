test_that("get_psced retrieves data correctly", {

  skip_if_offline(host = "github.com")

  psced_data <- get_psced()

  expect_s3_class(psced_data, "data.frame")
  expect_equal(dim(psced_data), c(754, 2))
  expect_identical(names(psced_data), c("value", "label"))

  psced_data_levels <- get_psced(level = "levels")
  expect_equal(dim(psced_data_levels), c(9, 2))

})
