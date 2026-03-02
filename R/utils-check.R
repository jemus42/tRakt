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


#' Check filter arguments
#'
#' @param filter The username input.
#' @param filter_type The kind of filter.
#' @noRd
#' @importFrom purrr map_lgl
#' @importFrom purrr is_empty
#' @keywords internal
check_filter_arg <- function(
	filter,
	filter_type = c(
		"query",
		"years",
		"genres",
		"languages",
		"countries",
		"runtimes",
		"ratings",
		"certifications",
		"networks",
		"status"
	)
) {
	filter_type <- match.arg(filter_type)

	# Empty in, empty out. Can't explain that.
	if (is_empty(filter) || identical(filter, "")) {
		return(NULL)
	}

	if (filter_type == "query") {
		filter <- as.character(filter)
	}
	if (filter_type == "years") {
		if (!(length(filter) %in% c(1, 2))) {
			cli::cli_warn("{.arg years} must be of length 1 or 2, keeping only first two values.")
			filter <- sort(filter[1:2])
		}

		if (length(filter) == 2) {
			filter <- paste0(sort(filter), collapse = "-")
		}

		# Check if the filter is okay now
		if (grepl(x = filter, pattern = "(^\\d{4}-\\d{4}$)|(^\\d{4}$)")) {
			filter
		} else {
			cli::cli_warn(
				"{.arg years} must be interpretable as a 4-digit year or range of 4-digit years."
			)
		}
	}
	if (filter_type == "runtimes") {
		if (!(length(filter) %in% c(1, 2))) {
			cli::cli_warn("{.arg runtimes} must be of length 1 or 2, keeping only first two values.")
			filter <- filter[1:2]
		}

		if (length(filter) == 2) {
			filter <- paste0(sort(filter), collapse = "-")
		}

		# Check if the filter is okay now
		if (grepl(x = filter, pattern = "(^\\d+-\\d+$)|(^\\d+$)")) {
			filter
		} else {
			cli::cli_warn("{.arg runtimes} must be interpretable as duration in minutes or range.")
		}
	}
	if (filter_type == "ratings") {
		if (!(length(filter) %in% c(1, 2))) {
			cli::cli_warn("{.arg ratings} must be of length 1 or 2, keeping only first two values.")
			filter <- filter[1:2]
		}

		if (length(filter) == 2) {
			filter <- paste0(sort(filter), collapse = "-")
		}

		# Check if the filter is okay now
		if (grepl(x = filter, pattern = "(^[1-9]{1,2}-[1-9]{1,3}$)|((^[1-9]{1,2}$)|(^100$))")) {
			filter
		} else {
			cli::cli_warn(
				"{.arg ratings} must be interpretable as an integer range or single integer between 1 and 100."
			)
		}
	}
	if (filter_type == "genres") {
		filter <- check_filter_arg_fixed(
			filter,
			filter_type,
			tRakt::trakt_genres$slug
		)
	}
	if (filter_type == "languages") {
		filter <- check_filter_arg_fixed(
			filter,
			filter_type,
			tRakt::trakt_languages$code
		)
	}
	if (filter_type == "countries") {
		filter <- check_filter_arg_fixed(
			filter,
			filter_type,
			tRakt::trakt_countries$code
		)
	}
	if (filter_type == "certifications") {
		filter <- check_filter_arg_fixed(
			filter,
			filter_type,
			tRakt::trakt_certifications$slug
		)
	}
	if (filter_type == "networks") {
		filter <- check_filter_arg_fixed(
			filter,
			filter_type,
			tRakt::trakt_networks$name
		)
	}
	if (filter_type == "status") {
		status_ok <- c("returning series", "in production", "planned", "canceled", "ended")

		filter <- check_filter_arg_fixed(filter, filter_type, status_ok)
	}
	filter
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
