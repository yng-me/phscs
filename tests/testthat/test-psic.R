test_that("get_psic retrieves data correctly", {

  psic_data <- get_psic()

  expect_s3_class(psic_data, "data.frame")
  expect_equal(dim(psic_data), c(1360, 2))
  expect_identical(names(psic_data), c("value", "label"))

  psic_data_sections <- get_psic(level = "sections")
  expect_equal(dim(psic_data_sections), c(21, 2))

})
