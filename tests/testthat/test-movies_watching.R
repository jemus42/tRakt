test_that("_watching works", {
  movies_watching("deadpool-2016") %>%
    expect_is("tbl_df")

  shows_watching("the-simpsons", extended = "full") %>%
    expect_is("tbl_df")

  episodes_watching("the-simpsons", season = sample(2:29, 1), episode = sample(19, 1)) %>%
    expect_is("tbl_df")
})
