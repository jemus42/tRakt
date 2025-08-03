test_that("aliases work", {
	movies_aliases(190430) |>
		expect_tibble(min_cols = c("title", "country"))

	shows_aliases(104439) |>
		expect_tibble(min_cols = c("title", "country"))
})
