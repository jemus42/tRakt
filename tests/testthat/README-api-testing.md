# API Response Testing Strategy

## Problem

The trakt.tv API regularly adds new fields to responses, causing tests that check for exact column names to fail even though the package functionality remains intact.

## Solution

Use flexible column checking that verifies required columns are present while allowing for additional columns.

## Test Helpers

The `helper-api-tests.R` file provides several functions for robust API testing:

### `expect_api_response()`

Main function for testing API responses:

```r
# Basic usage
api_result |>
  expect_api_response(
    min_cols = c("id", "name", "created_at"),  # Required columns
    min_rows = 1,                              # Optional: minimum rows
    exact_rows = 10                            # Optional: exact row count
  )
```

### `expect_contains_at_least()`

Lower-level function to check minimum columns:

```r
# Check that all required columns are present
result |>
  expect_contains_at_least(c("id", "title", "year"))
```

### `expect_extended_response()`

Compare minimal and extended API responses:

```r
minimal <- shows_summary("breaking-bad")
extended <- shows_summary("breaking-bad", extended = "full")

expect_extended_response(minimal, extended)
```

### `record_api_changes()`

Monitor when new fields are added (informational only):

```r
result |>
  record_api_changes(
    endpoint = "shows/summary",
    expected_cols = c("id", "title", "year")
  )
```

## Migration Guide

### Before (Brittle)
```r
test_that("user lists works", {
  result <- user_lists("jemus42")
  
  expect_s3_class(result, "tbl_df")
  expect_named(result, exact_column_names)
  expect_equal(nrow(result), 5)
})
```

### After (Flexible)
```r
test_that("user lists works", {
  # Define only the columns your package actually uses
  min_cols <- c("id", "name", "privacy", "created_at")
  
  user_lists("jemus42") |>
    expect_api_response(
      min_cols = min_cols,
      exact_rows = 5  # Only if functionally important
    )
})
```

## Best Practices

1. **Only test for columns your package uses**: Don't test for columns that are just passed through
2. **Use exact row counts sparingly**: Only when the count is functionally important
3. **Group related column definitions**: Keep minimum column lists near the top of test files
4. **Document why columns are required**: Add comments explaining which functions use which columns
5. **Monitor API changes**: Use `record_api_changes()` in a few key tests to stay informed

## Running the Refactoring Script

To identify tests that need updating:

```r
source("inst/scripts/helper-refactor-api-tests.R")
# This will analyze all test files and provide recommendations
```

Note: The refactoring scripts are located in `inst/scripts/` as they are one-time migration tools, not test helpers.

## Benefits

- Tests only fail when functionality is actually broken
- New API fields are automatically accepted
- Easier to maintain as API evolves
- Clear separation between required and optional fields
- Better test documentation through explicit minimum requirements