test_that("get_psced retrieves data correctly", {

  psced_data <- get_psced()

  expect_s3_class(psced_data, "data.frame")
  expect_equal(dim(psced_data), c(754, 2))
  expect_identical(names(psced_data), c("value", "label"))

  psced_data_levels <- get_psced(level = "levels")
  expect_equal(dim(psced_data_levels), c(9, 2))

  # codes are as in the per-level source files (e.g. broad "60", narrow "601")
  psced_broad <- get_psced(level = "broadfield")
  expect_equal(nrow(psced_broad), 22)
  expect_true("60" %in% psced_broad$value)
  psced_narrow <- get_psced(level = "narrowfield")
  expect_equal(nrow(psced_narrow), 67)
  expect_true("601" %in% psced_narrow$value)

  # level is the education level (0-8), not the hierarchy depth
  psced_full <- get_psced(minimal = FALSE)
  expect_identical(psced_full$level[psced_full$value == "80223"], "8")
  expect_identical(get_psced(level = "broadfield", cols = "level")$level[1:2], c("0", "0"))

})
