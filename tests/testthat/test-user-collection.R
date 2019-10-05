context("User / Collection")

test_that("user_collection works", {
  skip_on_cran()

  user <- "jemus42"

  col_sho <- user_collection(user = user, type = "shows", unnest_episodes = FALSE)
  col_sho2 <- user_collection(user = user)

  expect_identical(col_sho, col_sho2)

  col_sho %>%
    expect_is("tbl") %>%
    expect_length(10)

  user_collection(user = user, type = "movies") %>%
    expect_is("tbl") %>%
    expect_length(8)

  user_collection(user = c("jemus42", "sean"), type = "movies") %>%
    expect_is("tbl") %>%
    expect_length(9)

  # Error conditions ----
  expect_error(user_collection(user = -1))
  expect_message(user_collection(user = c("jemus42", "totallynotarealuser")))
  expect_error(user_collection(user = user, type = "wurst"))
})

# The unnesting thing ----

test_that("user_collection works with episode unnesting", {
  skip_if_not_installed("tidyr")
  skip_on_cran()

  user <- "jemus42"
  col_eps <- user_collection(user = user, type = "shows", unnest_episodes = TRUE)

  expect_is(col_eps, "tbl")
  expect_equal(ncol(col_eps), 12)
  expect_gt(nrow(col_eps), 10)
  expect_is(col_eps$collected_at, "POSIXct")
})
