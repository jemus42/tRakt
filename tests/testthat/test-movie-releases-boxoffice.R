context("Getting movie releases and box office")

test_that("trakt.movies.releases works", {
  skip_on_cran()

  movie <- "deadpool-2016"

  mov <- trakt.movies.releases(target = movie)
  mov_de <- trakt.movies.releases(target = movie, country = "de")
  mov_multi <- trakt.movies.releases(target = c(movie, "inception-2010"), country = "de")

  expect_is(mov, "tbl")
  expect_gte(nrow(mov), nrow(mov_de))
  expect_is(mov_multi, "tbl")
  expect_length(mov_multi, length(mov))
})

test_that("trakt.movies.boxoffice works", {
  skip_on_cran()

  trakt.movies.boxoffice() %>%
    expect_is("tbl") %>%
    expect_length(7) %>%
    nrow() %>%
    expect_equal(10)
})
