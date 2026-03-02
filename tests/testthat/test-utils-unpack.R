# unpack_show ----

test_that("unpack_show handles minimal show object", {
	show <- tibble::tibble(
		title = "Test Show",
		year = 2024L,
		ids = tibble::tibble(
			trakt = 1L,
			slug = "test-show",
			tvdb = 100L,
			imdb = "tt1234",
			tmdb = 200L
		)
	)

	result <- unpack_show(show)

	expect_s3_class(result, "tbl_df")
	expect_true("title" %in% names(result))
	expect_true("trakt" %in% names(result))
	expect_false("ids" %in% names(result))
})

test_that("unpack_show drops images and colors", {
	show <- tibble::tibble(
		title = "Test Show",
		year = 2024L,
		ids = tibble::tibble(
			trakt = 1L,
			slug = "test-show",
			imdb = "tt1234",
			tmdb = 200L,
			tvdb = 100L
		)
	)
	show$images <- tibble::tibble(
		fanart = I(list("http://example.com/fanart.jpg")),
		poster = I(list("http://example.com/poster.jpg"))
	)
	show$colors <- tibble::tibble(
		primary = "#ff0000",
		accent = "#00ff00"
	)

	result <- unpack_show(show)

	expect_false("images" %in% names(result))
	expect_false("colors" %in% names(result))
	expect_true("title" %in% names(result))
})

test_that("unpack_show handles plex in ids (guid + slug)", {
	ids <- tibble::tibble(
		trakt = 1L,
		slug = "test-show",
		imdb = "tt1234",
		tmdb = 200L,
		tvdb = 100L
	)
	ids$plex <- tibble::tibble(guid = "abc123", slug = "test-slug")

	show <- tibble::tibble(
		title = "Test Show",
		year = 2024L,
		ids = ids
	)

	result <- unpack_show(show)

	expect_true("plex_guid" %in% names(result))
	expect_true("plex_slug" %in% names(result))
	expect_equal(result$plex_guid, "abc123")
	expect_equal(result$plex_slug, "test-slug")
})

test_that("unpack_show handles plex with guid only (no slug)", {
	ids <- tibble::tibble(
		trakt = 1L,
		slug = "test-show",
		imdb = "tt1234",
		tmdb = 200L,
		tvdb = 100L
	)
	ids$plex <- tibble::tibble(guid = "abc123")

	show <- tibble::tibble(
		title = "Test Show",
		year = 2024L,
		ids = ids
	)

	result <- unpack_show(show)

	expect_true("plex_guid" %in% names(result))
	# plex_slug should not be created when slug is absent
	expect_false("plex_slug" %in% names(result))
	expect_equal(result$plex_guid, "abc123")
})

test_that("unpack_show flattens airs", {
	show <- tibble::tibble(
		title = "Test Show",
		year = 2024L,
		ids = tibble::tibble(
			trakt = 1L,
			slug = "test-show",
			imdb = "tt1234",
			tmdb = 200L,
			tvdb = 100L
		),
		airs = tibble::tibble(
			day = "Sunday",
			time = "21:00",
			timezone = "America/New_York"
		)
	)

	result <- unpack_show(show)

	expect_false("airs" %in% names(result))
	expect_true("airs_day" %in% names(result))
	expect_true("airs_time" %in% names(result))
	expect_true("airs_timezone" %in% names(result))
	expect_equal(result$airs_day, "Sunday")
})

test_that("unpack_show rejects non-data.frame input", {
	expect_error(unpack_show("not_a_df"), "must inherit from data.frame")
	expect_error(unpack_show(list(title = "test")), "must inherit from data.frame")
})
