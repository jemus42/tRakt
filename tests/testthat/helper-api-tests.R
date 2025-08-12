# Helper functions for robust API response testing

#' Check that a data frame contains at least the expected columns
#'
#' This function tests that all expected columns are present in the data frame,
#' but allows for additional columns that the API may add in the future.
#' Following testthat best practices for custom expectations.
#'
#' @param object The data frame to test
#' @param expected_cols Character vector of expected column names
#' @param label Optional label for the test
#' @param info Extra information to be printed on failure
expect_contains_at_least <- function(object, expected_cols, label = NULL, info = NULL) {
	act <- testthat::quasi_label(rlang::enquo(object), label)

	missing_cols <- setdiff(expected_cols, names(act$val))

	testthat::expect(
		length(missing_cols) == 0,
		sprintf(
			"Required columns missing from %s: %s\n%s",
			act$lab,
			paste(missing_cols, collapse = ", "),
			if (!is.null(info)) info else ""
		)
	)

	invisible(act$val)
}

#' Test tibble structure comprehensively
#'
#' @param object The tibble/data frame to test
#' @param min_cols (`character() | NULL`) Minimum expected column names
#' @param expected_class Expected S3 classes (default: tbl_df)
#' @param min_rows Minimum expected rows
#' @param exact_rows Exact expected rows (overrides min_rows)
#' @param col_types Named list of column types to check
expect_tibble <- function(
	object,
	min_cols = NULL,
	expected_class = "tbl_df",
	min_rows = NULL,
	exact_rows = NULL,
	col_types = NULL
) {
	act <- testthat::quasi_label(rlang::enquo(object))

	# Check class
	testthat::expect_s3_class(act$val, expected_class)

	# Check minimum columns if specified
	if (!is.null(min_cols)) {
		expect_contains_at_least(act$val, min_cols)
	}

	# Check row counts
	if (!is.null(exact_rows)) {
		testthat::expect_equal(nrow(act$val), exact_rows, label = sprintf("nrow(%s)", act$lab))
	} else if (!is.null(min_rows)) {
		testthat::expect_gte(nrow(act$val), min_rows, label = sprintf("nrow(%s)", act$lab))
	}

	# Check column types if specified
	if (!is.null(col_types)) {
		for (col_name in names(col_types)) {
			if (col_name %in% names(act$val)) {
				testthat::expect_type(
					act$val[[col_name]],
					col_types[[col_name]],
					label = sprintf("%s$%s", act$lab, col_name)
				)
			}
		}
	}

	invisible(act$val)
}
