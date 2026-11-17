test_that("get_pcoicop retrieves data correctly", {

  pcoicop_data <- get_pcoicop()

  expect_s3_class(pcoicop_data, "data.frame")
  expect_equal(dim(pcoicop_data), c(3472, 2))
  expect_identical(names(pcoicop_data), c("value", "label"))

  pcoicop_data_divisions <- get_pcoicop(level = "divisions")
  expect_equal(dim(pcoicop_data_divisions), c(15, 2))

  # codes are as in the source files ("041", 2009 division "1")
  expect_true("041" %in% get_pcoicop(level = "groups")$value)
  expect_true("1" %in% get_pcoicop(version = "2009", level = "divisions")$value)

})
