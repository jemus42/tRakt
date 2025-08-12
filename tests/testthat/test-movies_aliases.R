test_that("aliases work", {
	skip_on_cran()
	)

	vcr::local_cassette("movies_aliases_and_shows_aliases")
	movies_aliases(190430) |>
		expect_tibble(min_cols = c("title", "country"))

	shows_aliases(104439) |>
		expect_tibble(min_cols = c("title", "country"))
})
