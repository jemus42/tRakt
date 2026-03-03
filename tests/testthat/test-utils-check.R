test_that("check_user throws errors when it should", {
	skip_on_cran()

	vcr::local_cassette("utils_check_username")

	expect_error(check_username(user = NULL))
	expect_error(check_username(user = NA))
	expect_error(check_username(user = 4))
	expect_error(check_username(user = ""))
	expect_failure(expect_error(
		check_username(user = "jemus42", validate = TRUE),
		"list"
	))
})

test_that("check_filter_arg fails how it should", {
	expect_null(check_filter_arg(NULL))

	expect_warning(check_filter_arg(10239, "years"))
	expect_warning(check_filter_arg(119, "ratings"))
	expect_warning(check_filter_arg(1:5, "runtimes"))
	expect_warning(check_filter_arg("five", "genres"))
	expect_warning(check_filter_arg("asfehf", "networks"))
	expect_warning(check_filter_arg("five", "languages"))
	expect_warning(check_filter_arg("five", "certifications"))
	expect_warning(check_filter_arg("five", "countries"))
	expect_warning(check_filter_arg("five", "status"))

	expect_equal(
		check_filter_arg(c("action", "drama"), filter_type = "genres"),
		"action,drama"
	)
	expect_equal(
		check_filter_arg(c("HBO", "TNT"), filter_type = "networks"),
		"HBO,TNT"
	)
	expect_equal(
		check_filter_arg(c("hbo", "tnt"), filter_type = "networks"),
		"HBO,TNT"
	)
	expect_equal(
		check_filter_arg(c("en", "de"), filter_type = "languages"),
		"en,de"
	)
	expect_equal(
		check_filter_arg("EN", filter_type = "languages"),
		"en"
	)
	expect_equal(
		check_filter_arg(c("pg-13", "r"), filter_type = "certifications"),
		"pg-13,r"
	)
	expect_equal(
		check_filter_arg(c("ar", "am"), filter_type = "countries"),
		"ar,am"
	)
	expect_equal(
		check_filter_arg(c("ended", "canceled"), filter_type = "status"),
		"ended,canceled"
	)
	expect_equal(
		check_filter_arg(c("ENDED", "canceled"), filter_type = "status"),
		"ended,canceled"
	)
	expect_equal(
		check_filter_arg("Ended", filter_type = "status"),
		"ended"
	)
})


# validate_extended() tests ----

test_that("validate_extended handles basic values", {
	# "min" returns NULL query_value (omit the parameter)
	res <- validate_extended("min")
	expect_s3_class(res, "trakt_extended")
	expect_null(res$query_value)
	expect_false(res$keep_images)
	expect_equal(res$components, character(0))

	# "full" returns "full"
	res <- validate_extended("full")
	expect_equal(res$query_value, "full")
	expect_false(res$keep_images)
	expect_equal(res$components, "full")

	# "images" returns "images" and keep_images = TRUE
	res <- validate_extended("images")
	expect_equal(res$query_value, "images")
	expect_true(res$keep_images)
	expect_equal(res$components, "images")

	# "metadata" returns "metadata"
	res <- validate_extended("metadata")
	expect_equal(res$query_value, "metadata")
	expect_false(res$keep_images)
})

test_that("validate_extended handles combinations", {
	# Comma-separated string
	res <- validate_extended("full,images")
	expect_equal(res$query_value, "full,images")
	expect_true(res$keep_images)
	expect_setequal(res$components, c("full", "images"))

	# Character vector
	res <- validate_extended(c("full", "images"))
	expect_equal(res$query_value, "full,images")
	expect_true(res$keep_images)
	expect_setequal(res$components, c("full", "images"))

	# full,metadata
	res <- validate_extended("full,metadata")
	expect_equal(res$query_value, "full,metadata")
	expect_false(res$keep_images)
})

test_that("validate_extended handles internal modifiers", {
	# episodes modifier
	res <- validate_extended(c("full", "episodes"))
	expect_equal(res$query_value, "full,episodes")

	# noseasons modifier (with min, which gets stripped)
	res <- validate_extended(c("min", "noseasons"))
	expect_equal(res$query_value, "noseasons")
	expect_equal(res$components, "noseasons")

	# guest_stars modifier
	res <- validate_extended(c("full", "guest_stars"))
	expect_equal(res$query_value, "full,guest_stars")
})

test_that("validate_extended handles edge cases", {
	# NULL defaults to min
	res <- validate_extended(NULL)
	expect_null(res$query_value)

	# Empty string defaults to min
	res <- validate_extended("")
	expect_null(res$query_value)

	# Case insensitive
	res <- validate_extended("FULL")
	expect_equal(res$query_value, "full")

	# Whitespace handling
	res <- validate_extended(" full , images ")
	expect_equal(res$query_value, "full,images")
})

test_that("validate_extended rejects invalid values", {
	expect_error(validate_extended("invalid"), "invalid")
	expect_error(validate_extended("full,bogus"), "bogus")
	expect_error(validate_extended(123), "character")
})

test_that("validate_extended rejects min + full combination", {
	expect_error(validate_extended(c("min", "full")), "cannot contain both")
})
