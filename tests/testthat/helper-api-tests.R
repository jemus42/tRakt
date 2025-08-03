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

#' Check data frame structure without strict column name matching
#' 
#' Tests essential properties of API responses without being brittle
#' to new columns being added
#' 
#' @param object The data frame to test
#' @param min_cols Minimum expected columns
#' @param min_rows Minimum expected rows (default 0)
#' @param exact_rows Expected exact row count (optional)
expect_api_response <- function(object, min_cols, min_rows = 0, exact_rows = NULL) {
	act <- testthat::quasi_label(rlang::enquo(object))
	
	# Check it's a data frame
	testthat::expect_s3_class(act$val, "tbl_df")
	
	# Check minimum columns are present
	expect_contains_at_least(act$val, min_cols)
	
	# Check row counts
	if (!is.null(exact_rows)) {
		testthat::expect_equal(nrow(act$val), exact_rows)
	} else if (min_rows > 0) {
		testthat::expect_gte(nrow(act$val), min_rows)
	}
	
	invisible(act$val)
}

#' Test that extended API responses contain additional columns
#' 
#' When using extended=full, API responses should have more columns
#' than the minimal response
#' 
#' @param minimal_response The minimal API response
#' @param extended_response The extended API response
expect_extended_response <- function(minimal_response, extended_response) {
	min_act <- testthat::quasi_label(rlang::enquo(minimal_response))
	ext_act <- testthat::quasi_label(rlang::enquo(extended_response))
	
	# Extended should have all minimal columns plus more
	expect_contains_at_least(ext_act$val, names(min_act$val))
	
	# Extended should have more columns
	testthat::expect_gt(
		length(names(ext_act$val)), 
		length(names(min_act$val)),
		label = "Extended response should have more columns than minimal"
	)
	
	invisible(ext_act$val)
}

#' Record current API response structure for monitoring
#' 
#' This function can be used to log current API responses to track
#' when new fields are added. It doesn't fail tests but provides
#' information about API changes.
#' 
#' @param object The API response
#' @param endpoint Description of the API endpoint
#' @param expected_cols The columns we expect
record_api_changes <- function(object, endpoint, expected_cols) {
	act <- testthat::quasi_label(rlang::enquo(object))
	
	current_cols <- names(act$val)
	new_cols <- setdiff(current_cols, expected_cols)
	
	if (length(new_cols) > 0) {
		testthat::inform(sprintf(
			"New columns detected in %s: %s",
			endpoint,
			paste(new_cols, collapse = ", ")
		))
	}
	
	invisible(act$val)
}

#' Test tibble structure comprehensively
#' 
#' Based on testthat best practices for testing tibbles/data frames
#' 
#' @param object The tibble/data frame to test
#' @param min_cols Minimum expected columns
#' @param expected_class Expected S3 classes (default: tbl_df)
#' @param min_rows Minimum expected rows
#' @param exact_rows Exact expected rows (overrides min_rows)
#' @param col_types Named list of column types to check
expect_tibble <- function(object, 
                         min_cols = NULL,
                         expected_class = "tbl_df",
                         min_rows = NULL,
                         exact_rows = NULL,
                         col_types = NULL) {
	act <- testthat::quasi_label(rlang::enquo(object))
	
	# Check class
	testthat::expect_s3_class(act$val, expected_class)
	
	# Check minimum columns if specified
	if (!is.null(min_cols)) {
		expect_contains_at_least(act$val, min_cols)
	}
	
	# Check row counts
	if (!is.null(exact_rows)) {
		testthat::expect_equal(nrow(act$val), exact_rows,
			label = sprintf("nrow(%s)", act$lab))
	} else if (!is.null(min_rows)) {
		testthat::expect_gte(nrow(act$val), min_rows,
			label = sprintf("nrow(%s)", act$lab))
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

#' Use snapshot testing for API responses
#' 
#' Wrapper around expect_snapshot_value for consistent API testing
#' 
#' @param expr Expression that returns API response
#' @param style Serialization style for snapshot
#' @param ... Additional arguments to expect_snapshot_value
expect_api_snapshot <- function(expr, style = "json2", ...) {
	# Remove volatile fields like timestamps before snapshot
	result <- rlang::eval_tidy(rlang::enquo(expr))
	
	# Common volatile fields to exclude
	volatile_fields <- c("created_at", "updated_at", "last_activity", 
	                    "cached_at", "expires_at")
	
	# Create a copy without volatile fields for snapshot
	snapshot_data <- result
	for (field in volatile_fields) {
		if (field %in% names(snapshot_data)) {
			snapshot_data[[field]] <- NULL
		}
	}
	
	testthat::expect_snapshot_value(snapshot_data, style = style, ...)
	
	invisible(result)
}