test_that("movies_releases works", {
	skip_on_cran()

	movie <- "deadpool-2016"

	mov <- movies_releases(id = movie)
	mov_de <- movies_releases(id = movie, country = "de")
	mov_multi <- movies_releases(id = c(movie, "inception-2010"), country = "de")

	expect_s3_class(mov, "tbl")
	expect_gte(nrow(mov), nrow(mov_de))
	expect_s3_class(mov_multi, "tbl")
	expect_length(mov_multi, length(mov))
})

test_that("movies_boxoffice works", {
	skip_on_cran()

	movies_boxoffice() |>
		expect_s3_class("tbl") |>
		expect_length(7) |>
		nrow() |>
		expect_gt(3)
})
