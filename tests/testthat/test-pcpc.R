test_that("get_pcpc retrieves data correctly", {

  pcpc_data <- get_pcpc()

  expect_s3_class(pcpc_data, "data.frame")
  expect_equal(dim(pcpc_data), c(8734, 2))
  expect_identical(names(pcpc_data), c("value", "label"))

  pcpc_data_sections <- get_pcpc(level = "sections")
  expect_equal(dim(pcpc_data_sections), c(10, 2))

})

