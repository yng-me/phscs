test_that("get_pcoicop retrieves data correctly", {

  skip_if_offline(host = "github.com")

  pcoicop_data <- get_pcoicop()

  expect_s3_class(pcoicop_data, "data.frame")
  expect_equal(dim(pcoicop_data), c(3468, 2))
  expect_identical(names(pcoicop_data), c("value", "label"))

  pcoicop_data_divisions <- get_pcoicop(level = "divisions")
  expect_equal(dim(pcoicop_data_divisions), c(15, 2))

})
