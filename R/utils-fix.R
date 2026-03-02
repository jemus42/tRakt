#' Set ratings to NA if votes == 0
#' @keywords internal
#' @importFrom dplyr if_else
#' @importFrom rlang has_name
#' @noRd
fix_ratings <- function(response) {
	if (!(has_name(response, "rating") && has_name(response, "votes"))) {
		# Robustness towards usage in extended = "min" context, means less if'ing
		return(response)
	}
	response$rating <- if_else(response$votes == 0, NA_real_, response$rating)
	response
}

#' Fix IDs object
#' Always return characters, replace NULL with explicit NA
#' @keywords internal
#' @importFrom purrr modify_if
#' @importFrom rlang has_name
#' @noRd
fix_ids <- function(ids) {
	if (!inherits(ids, c("data.frame", "list"))) {
		cli::cli_abort("{.arg ids} must be a list or data.frame, not {.obj_type_friendly {ids}}.")
	}

	# Since tvrage is dead and tvrage IDs tend to be NA/0,
	# I decided to drop them in general as they are basically just junk
	if (has_name(ids, "tvrage")) {
		ids["tvrage"] <- NULL
	}

	# Flatten nested plex object into plex_guid (and plex_slug when present)
	# Shows/movies have both guid and slug; seasons/episodes only have guid
	if (has_name(ids, "plex")) {
		plex <- ids[["plex"]]
		ids[["plex"]] <- NULL
		if (is.data.frame(plex) || (is.list(plex) && !is.null(plex))) {
			if (!is.null(plex[["guid"]])) {
				ids[["plex_guid"]] <- as.character(plex[["guid"]])
			}
			if (!is.null(plex[["slug"]])) {
				ids[["plex_slug"]] <- as.character(plex[["slug"]])
			}
		}
	}

	modify_if(ids, is.null, ~NA_character_, .else = as.character)
}

#' Quick datetime conversion
#'
#' Searches for datetime variables and converts them to `POSIXct` via \pkg{lubridate}.
#' @param response The input object. Must be `data.frame`(ish) or named `list`.
#' @return The same object with converted datetimes
#' @importFrom lubridate ymd_hms
#' @importFrom lubridate as_date
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom dplyr any_of
#' @importFrom purrr map_at
#' @importFrom rlang has_name
#' @keywords internal
#' @noRd
fix_datetime <- function(response) {
	if (!inherits(response, c("data.frame", "list"))) {
		cli::cli_abort(
			"{.arg response} must inherit from data.frame or list, not {.obj_type_friendly {response}}."
		)
	}
	datevars <- c(
		"first_aired",
		"updated_at",
		"listed_at",
		"last_watched_at",
		"last_updated_at",
		"last_collected_at",
		"rated_at",
		"friends_at",
		"followed_at",
		"collected_at",
		"joined_at",
		"watched_at",
		"created_at"
	)

	datevars <- datevars[datevars %in% names(response)]

	if (has_name(response, "released")) {
		response$released <- as_date(response$released)
	}
	if (has_name(response, "birthday")) {
		response$birthday <- as_date(response$birthday)
	}

	if (inherits(response, "data.frame")) {
		response |>
			mutate(across(
				any_of(datevars),
				\(x) {
					# Don't convert already POSIXct vars
					if (!(inherits(x, "POSIXct"))) {
						ymd_hms(x)
					} else {
						x
					}
				}
			))
	} else {
		map_at(response, datevars, ymd_hms)
	}
}

# Unpack the ratings distribution my tibblurazing them
#' @keywords internal
#' @importFrom tibble enframe
#' @importFrom rlang has_name
fix_ratings_distribution <- function(response) {
	if (!has_name(response, "distribution")) {
		return(response)
	}

	response$distribution <- enframe(unlist(response$distribution), name = "rating", value = "n")
	response$distribution$rating <- as.integer(response$distribution$rating)
	response$distribution <- list(response$distribution)
	response
}

#' Fix a tibble for final output
#' @keywords internal
#' @noRd
#' @importFrom tibble as_tibble
#' @importFrom tibble remove_rownames
fix_tibble_response <- function(response) {
	# Drop nested objects that don't fit tabular output
	# These are returned by the API for shows, seasons, and episodes
	response[["images"]] <- NULL
	response[["colors"]] <- NULL

	response |>
		as_tibble() |>
		fix_datetime() |>
		fix_ratings() |>
		remove_rownames()
}

#' Replace "" and NULL with explicit NAs
#' @importFrom dplyr if_else
#' @importFrom purrr map_chr
#' @keywords internal
#' @noRd
#' @note Currently only for [character()] variables. Because this might nuke classes.
fix_missing <- function(x) {
	if (inherits(x, "character")) {
		x <- map_chr(x, \(x) if_else(identical(x, ""), NA_character_, x))
	}
	x
}
