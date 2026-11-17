test_that("get_psccs retrieves data correctly", {

  psccs_data <- get_psccs()

  expect_s3_class(psccs_data, "data.frame")
  expect_equal(dim(psccs_data), c(1870, 2))
  expect_identical(names(psccs_data), c("value", "label"))

  psccs_data_sections <- get_psccs(level = "section")
  expect_equal(dim(psccs_data_sections), c(11, 2))

  # duplicated source code 0103129 takes the title from 2018-sub-classes.json
  expect_identical(psccs_data$label[psccs_data$value == "0103129"], "Other acts of robbery with homicide, n.e.c.")

})
