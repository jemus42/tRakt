test_that("media_people works", {
	skip_on_cran()

	# `guest_stars = TRUE` is now deprecated (no-op upstream); silence the warning
	# in the test body — argument-deprecation behaviour is exercised separately below.
	withr::local_options(lifecycle_verbosity = "quiet")

	vcr::local_cassette("media_people")
	movies_people("deadpool-2016") |>
		expect_named(c("cast", "crew")) |>
		purrr::walk(
			~ {
				expect_s3_class(.x, "tbl_df")
			}
		)

	shows_people("breaking-bad") |>
		expect_named(c("cast", "crew")) |>
		purrr::walk(
			~ {
				expect_s3_class(.x, "tbl_df")
			}
		)

	shows_people("breaking-bad", guest_stars = TRUE) |>
		expect_named(c("cast", "crew")) |>
		purrr::walk(
			~ {
				expect_s3_class(.x, "tbl_df")
			}
		)

	seasons_people("breaking-bad", season = 1) |>
		expect_named(c("cast", "crew")) |>
		purrr::walk(
			~ {
				expect_s3_class(.x, "tbl_df")
			}
		)

	seasons_people("breaking-bad", season = 1, guest_stars = TRUE) |>
		expect_named(c("cast", "crew")) |>
		purrr::walk(
			~ {
				expect_s3_class(.x, "tbl_df")
			}
		)

	episodes_people("breaking-bad", season = 1, episode = 1) |>
		expect_named(c("cast", "crew")) |>
		purrr::walk(
			~ {
				expect_s3_class(.x, "tbl_df")
			}
		)

	episodes_people("breaking-bad", season = 1, episode = 1, guest_stars = TRUE) |>
		expect_named(c("cast", "crew")) |>
		purrr::walk(
			~ {
				expect_s3_class(.x, "tbl_df")
			}
		)
})

test_that("guest_stars argument is deprecated", {
	skip_on_cran()
	vcr::local_cassette("media_people")
	expect_warning(
		shows_people("breaking-bad", guest_stars = TRUE),
		class = "lifecycle_warning_deprecated"
	)
})
