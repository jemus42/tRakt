#' Get the cast and crew of a show or movie
#'
#' Returns all cast and crew for a show/movie, depending on how much data is
#' available.
#'
#' @note
#' As of 2019-09-30, there are two representations of `character[s]` and
#' `job[s]`:
#' One is a regular character variable, and the other is a list-column. The former is
#' [deprecated](https://github.com/trakt/api-help/issues/74) and only included for
#' compatibility reasons.
#'
#' @name media_people
#' @inheritParams trakt_api_common_parameters
#' @param guest_stars `r lifecycle::badge("deprecated")` `logical(1) ["FALSE"]`:
#'   Previously requested a separate `guest_stars` table. The trakt.tv API no
#'   longer returns that array — guest cast is now included in `cast`.
#'   This argument is currently a no-op and will be removed in a future release.
#' @return A `list` of one or more [tibbles][tibble::tibble-package] for `cast`
#'   and/or `crew`. The latter `tibble` objects are as flat as possible.
#' @family people data
#' @seealso [people_media], for the other direction: People that have credits
#'   in shows/movies.
#' @examplesIf trakt_api_available()
#' movies_people("deadpool-2016")
#' shows_people("breaking-bad")
#' seasons_people("breaking-bad", season = 1)
#' episodes_people("breaking-bad", season = 1, episode = 1)
NULL

# Shared deprecation warning for the no-op `guest_stars` argument.
# The trakt.tv API stopped returning a separate `guest_stars` array; guest
# cast is now included in `cast`. Warn only when the user explicitly opts in,
# so callers using the default behaviour see nothing.
warn_for_guest_stars <- function(guest_stars, user_env = rlang::caller_env(2)) {
	if (!isTRUE(guest_stars)) {
		return(invisible())
	}
	lifecycle::deprecate_warn(
		when = "0.18.0",
		what = I("The `guest_stars` argument"),
		details = c(
			"The trakt.tv API no longer returns a separate `guest_stars` array.",
			"Guest cast is now included in `cast`.",
			"This argument is a no-op and will be removed in a future release."
		),
		user_env = user_env
	)
	invisible()
}

#' @rdname media_people
#' @eval apiurl("movies", "people")
#' @family movie data
#' @family people data
#' @export
movies_people <- function(id, extended = "min") {
	extended <- validate_extended(extended)

	# Construct URL, make API call
	url <- build_trakt_url("movies", id, "people", extended = extended$query_value)
	response <- trakt_get(url = url)

	unpack_people(response)
}

#' @rdname media_people
#' @eval apiurl("shows", "people")
#' @family show data
#' @family people data
#' @export
shows_people <- function(id, guest_stars = FALSE, extended = "min") {
	warn_for_guest_stars(guest_stars)
	# Combine extended with guest_stars modifier before validation
	extended_input <- if (guest_stars) c(extended, "guest_stars") else extended
	extended <- validate_extended(extended_input)

	# Construct URL, make API call
	url <- build_trakt_url("shows", id, "people", extended = extended$query_value)
	response <- trakt_get(url = url)

	unpack_people(response)
}

#' @rdname media_people
#' @eval apiurl("seasons", "people")
#' @family season data
#' @family people data
#' @export
seasons_people <- function(id, season = 1L, guest_stars = FALSE, extended = "min") {
	warn_for_guest_stars(guest_stars)
	# Combine extended with guest_stars modifier before validation
	extended_input <- if (guest_stars) c(extended, "guest_stars") else extended
	extended <- validate_extended(extended_input)

	# Construct URL, make API call
	url <- build_trakt_url(
		"shows",
		id,
		"seasons",
		season,
		"people",
		extended = extended$query_value
	)
	response <- trakt_get(url = url)

	unpack_people(response)
}

#' @rdname media_people
#' @eval apiurl("episodes", "people")
#' @family episode data
#' @family people data
#' @export
episodes_people <- function(
	id,
	season = 1L,
	episode = 1L,
	guest_stars = FALSE,
	extended = "min"
) {
	warn_for_guest_stars(guest_stars)
	# Combine extended with guest_stars modifier before validation
	extended_input <- if (guest_stars) c(extended, "guest_stars") else extended
	extended <- validate_extended(extended_input)

	# Construct URL, make API call
	url <- build_trakt_url(
		"shows",
		id,
		"seasons",
		season,
		"episodes",
		episode,
		"people",
		extended = extended$query_value
	)
	response <- trakt_get(url = url)

	unpack_people(response)
}
