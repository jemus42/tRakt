context("test-user-history")

test_that("trakt.user.history does things", {
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
})
