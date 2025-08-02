test_that("people_summary works", {
	skip_on_cran()

	id <- "bryan-cranston"

	people_min <- people_summary(id = id, extended = "min")
	people_max <- people_summary(id = id, extended = "full")

	expect_s3_class(people_min, "tbl")
	expect_equal(nrow(people_min), 1)
	expect_equal(ncol(people_min), 5)
	expect_s3_class(people_max, "tbl")
	expect_equal(ncol(people_max), 14)

	expect_identical(
		rbind(
			people_summary(id = id),
			people_summary(id = id)
		),
		people_summary(id = c(id, id))
	)
})

test_that("people_media works", {
	skip_on_cran()

	id <- "bryan-cranston"

	mov_min <- people_movies(id = id, extended = "min")
	mov_max <- people_movies(id = id, extended = "full")

	expect_type(mov_min, "list")
	expect_named(mov_min, c("cast", "crew"))
	expect_s3_class(mov_min$cast, "tbl_df")
	expect_s3_class(mov_min$crew, "tbl_df")

	sho_min <- people_shows(id = id, extended = "min")
	sho_max <- people_shows(id = id, extended = "full")

	expect_type(sho_min, "list")
	expect_named(sho_min, c("cast", "crew"))
	expect_s3_class(sho_min$cast, "tbl_df")
	expect_s3_class(sho_min$crew, "tbl_df")
})
