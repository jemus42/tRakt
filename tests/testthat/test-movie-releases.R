context("test-movie-releases")

test_that("trakt.movie.releases works", {
  skip_on_cran()
  
  movie <- "deadpool-2016"

  mov <- trakt.movie.releases(target = movie)
  mov_de <- trakt.movie.releases(target = movie, country = "de")
  mov_multi <- trakt.movie.releases(target = c(movie, "inception-2010"), country = "de")

  expect_is(mov, "tbl")
  expect_gte(nrow(mov), nrow(mov_de))
  expect_is(mov_multi, "tbl")
  expect_length(mov_multi, length(mov) + 1)
})
