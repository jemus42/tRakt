context("User / History")

test_that("trakt.user.history does things", {
  skip_on_cran()

  trakt.user.history(user = "jemus42", "shows") %>%
    expect_is("tbl") %>%
    expect_length(6) %>%
    nrow() %>%
    expect_equal(10)

  trakt.user.history(user = "jemus42", "movies") %>%
    expect_is("tbl") %>%
    expect_length(10) %>%
    nrow() %>%
    expect_equal(10)

  trakt.user.history(user = c("jemus42", "sean"), limit = 2) %>%
    expect_is("tbl") %>%
    expect_length(7) %>%
    nrow() %>%
    expect_equal(4)
})
