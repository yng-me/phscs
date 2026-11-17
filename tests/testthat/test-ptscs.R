test_that("get_ptscs returns both lists with the same columns", {

  cols <- c("id", "category_id", "description", "keywords")

  ptscs_data <- get_ptscs()
  expect_s3_class(ptscs_data, "data.frame")
  expect_equal(nrow(ptscs_data), 15)
  expect_identical(names(ptscs_data), cols)

  ptscs_products <- get_ptscs(type = "products")
  expect_equal(nrow(ptscs_products), 18)
  expect_identical(names(ptscs_products), cols)
  expect_identical(ptscs_products$description[ptscs_products$category_id == "12.1"], "Retail Trade Services")

})

test_that("get_ptscs splits industry keywords into a list column", {

  kw <- get_ptscs()$keywords
  expect_type(kw, "list")
  expect_identical(kw[[1]][1:3], c("consumption", "drinks", "fit"))
  expect_false(any(vapply(kw, function(k) any(!nzchar(k)), logical(1))))  # ",," leaves no empty keyword

  # products keep the original text
  kw_products <- get_ptscs(type = "products")$keywords
  expect_type(kw_products, "character")
  expect_true(startsWith(kw_products[3], "Includes :\r\nPassenger transport by inter-urban railways"))

})
