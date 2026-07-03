#' Check username
#'
#' @param user The username input.
#' @param validate `logical(1) [TRUE]`: Retrieve user profile to check if it exists.
#' @return An HTTP error if the checks fail or else `TRUE` invisibly. If `validate`, the
#' user profile is returned as a `list`.
#' @keywords internal
#' @importFrom rlang is_empty is_character
check_username <- function(user, validate = FALSE) {
	if (is_empty(user) || identical(user, "") || !is_character(user)) {
		cli::cli_abort(
			"{.arg user} must be a non-empty character string, not {.obj_type_friendly {user}}."
		)
	}

	if (validate) {
		url <- build_trakt_url("users", user)
		trakt_get(url)
	}
	# Return TRUE if and only if everything else did not fail
	invisible(TRUE)
}

#' Check types
#'
#' Allowed types vary, and both "movie" and "movies" etc. should be allowed.
#' This function normalizes plural forms to singulars and concatenates multiple
#' results if allowed
#' @param type `character(n)`: One or more types, e.g. `"movies"`.
#' @param several.ok `logical(1) [TRUE]`: Passed to [match.arg][base::match.arg].
#' @param possible_types Types allowed (after normalization).
#'   Passed to [match.arg][base::match.arg] as `choices` param.
#' @return A `character` of length 1.
#' @keywords internal
#' @noRd
#' @importFrom dplyr case_when
check_types <- function(
	type,
	several.ok = TRUE,
	possible_types = c(
		"movie",
		"show",
		"season",
		"episode",
		"person"
	)
) {
	if (is.null(type)) {
		return(NULL)
	}

	type <- case_when(
		type %in% c("movie", "movies") ~ "movie",
		type %in% c("show", "shows") ~ "show",
		type %in% c("episode", "episodes") ~ "episode",
		type %in% c("season", "seasons") ~ "season",
		type %in% c("person", "persons", "people") ~ "person",
		type %in% c("comment", "comments") ~ "comments",
		type %in% c("list", "lists") ~ "lists",
		TRUE ~ ""
	)

	type <- match.arg(type, choices = possible_types, several.ok = several.ok)

	if (length(type) > 1) {
		type <- paste0(type, collapse = ",")
	}

	type
}


#' The helper's helper
#' @keywords internal
#' @importFrom stringr str_trim str_to_lower str_split
#' @importFrom purrr map_chr
#' @noRd
check_filter_arg_fixed <- function(filter, filter_type, filter_ok) {
	filter <- as.vector(str_split(filter, ",", simplify = TRUE))

	clean_filter <- str_to_lower(filter) |>
		str_trim("both")

	clean_filter_ok <- str_trim(filter_ok, "both") |>
		str_to_lower()

	filter <- map_chr(
		clean_filter,
		\(x) {
			matches <- x %in% clean_filter_ok

			if (!matches) {
				cli::cli_warn("{.arg {filter_type}} includes unknown value, ignoring: {.val {x}}.")
				""
			} else {
				filter_ok[x == clean_filter_ok] |>
					unique()
			}
		}
	)

	paste0(unique(filter), collapse = ",")
}


#' Validate and normalize the extended parameter
#'
#' Validates the `extended` parameter against values documented in the trakt.tv API.
#' The API supports `"full"`, `"images"`, `"metadata"`, and comma-separated combinations.
#' `"min"` is a package-level convenience meaning "use the API default" (omit the parameter).
#'
#' @param extended A character string or vector specifying the extended level.
#'   Valid user-facing values: `"min"`, `"full"`, `"images"`, `"metadata"`.
#'   Can be combined as `"full,images"` or `c("full", "images")`.
#'   Internal API modifiers (`"episodes"`, `"noseasons"`, `"guest_stars"`) are also accepted.
#' @return A list with class `"trakt_extended"` containing:
#'   - `query_value`: The string to pass as the `extended` URL query parameter,
#'     or `NULL` if minimal info is requested.
#'   - `keep_images`: Logical, whether images should be preserved in output.
#'   - `components`: Character vector of individual components.
#' @keywords internal
#' @noRd
validate_extended <- function(extended) {
	if (is.null(extended) || identical(extended, "")) {
		extended <- "min"
	}

	if (!is.character(extended)) {
		cli::cli_abort(
			"{.arg extended} must be a character string or vector, not {.obj_type_friendly {extended}}."
		)
	}

	# User-facing values documented in the API + internal modifiers used by specific endpoints
	valid_components <- c(
		"min",
		"full",
		"images",
		"metadata",
		"episodes",
		"noseasons",
		"guest_stars"
	)

	# Accept both "full,images" and c("full", "images")
	if (length(extended) == 1 && grepl(",", extended)) {
		components <- trimws(strsplit(extended, ",")[[1]])
	} else {
		components <- trimws(extended)
	}

	components <- tolower(components)
	# Remove empty strings from splitting
	components <- components[nzchar(components)]

	if (length(components) == 0) {
		components <- "min"
	}

	# Validate each component
	invalid <- setdiff(components, valid_components)
	if (length(invalid) > 0) {
		valid_user_facing <- setdiff(valid_components, c("episodes", "noseasons", "guest_stars"))
		cli::cli_abort(c(
			"{.arg extended} contains invalid value{?s}: {.val {invalid}}.",
			"i" = "Valid values are: {.val {valid_user_facing}}."
		))
	}

	# "min" is mutually exclusive with "full"
	if ("min" %in% components && "full" %in% components) {
		cli::cli_abort(
			'{.arg extended} cannot contain both {.val min} and {.val full}.'
		)
	}

	# "min" means omit the parameter entirely — but internal modifiers can still be present
	if ("min" %in% components) {
		components <- setdiff(components, "min")
	}

	if (length(components) == 0) {
		query_value <- NULL
	} else {
		query_value <- paste(components, collapse = ",")
	}

	structure(
		list(
			query_value = query_value,
			keep_images = "images" %in% components,
			components = components
		),
		class = "trakt_extended"
	)
}
