#' Media user ratings
#'
#' Returns a movie's or show's (or season's, or episode's) rating and ratings distribution.
#' If you *do not* want the full ratings distribution, it is highly advised to
#' just use `*_summary` functions or [seasons_episodes] for episode ratings.
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @name media_ratings
#' @note Since this function is able to work on multi-length inputs for
#' `id`, `season` and `episode`, it is possible to get a lot of data, *but* at the cost
#' of one API call *per element in each argument*. Please be kind to the API.
#' @examples
#' # A movie's ratings
#' movies_ratings("tron-legacy-2010")
#'
#' # A show's ratings
#' shows_ratings("game-of-thrones")
#' \dontrun{
#' # Ratings for seasons 1 through 5
#' seasons_ratings("futurama", season = 1:5)
#'
#' # Ratings for episodes 1 through 7 of season 1
#' episodes_ratings("futurama", season = 1, episode = 1:7)
#' }
NULL

#' @keywords internal
#' @importFrom dplyr mutate
#' @importFrom purrr map_df
media_ratings <- function(type = c("shows", "movies"), id) {
	type <- match.arg(type)

	if (length(id) > 1) {
		return(map_df(id, ~ media_ratings(type = type, id = .x)))
	}

	# Construct URL, make API call
	url <- build_trakt_url(type, id, "ratings")
	response <- trakt_get(url = url)

	response |>
		fix_ratings_distribution() |>
		as_tibble() |>
		mutate(
			id = id,
			type = type
		)
}

# Aliases for show/movie ratings ----

#' @rdname media_ratings
#' @family show data
#' @eval apiurl("shows", "ratings")
#' @export
shows_ratings <- function(id) {
	media_ratings(type = "shows", id)
}

#' @rdname media_ratings
#' @family movie data
#' @eval apiurl("movies", "ratings")
#' @export
movies_ratings <- function(id) {
	media_ratings(type = "movies", id)
}

# Seasons and episodes ratings ----

#' @rdname media_ratings
#' @eval apiurl("seasons", "ratings")
#' @family season data
#' @export
#' @importFrom dplyr mutate
#' @importFrom purrr map_df
seasons_ratings <- function(id, season = 1L) {
	if (length(id) > 1) {
		return(map_df(id, ~ seasons_ratings(.x, season)))
	}

	if (length(season) > 1) {
		return(map_df(season, ~ seasons_ratings(id, .x)))
	}

	# Construct URL, make API call
	url <- build_trakt_url("shows", id, "seasons", season, "ratings")
	response <- trakt_get(url = url)

	response |>
		fix_ratings_distribution() |>
		as_tibble() |>
		mutate(
			id = id,
			season = season
		)
}

#' @rdname media_ratings
#' @eval apiurl("episodes", "ratings")
#' @family episode data
#' @export
#' @importFrom dplyr mutate
#' @importFrom purrr map_df
episodes_ratings <- function(id, season = 1L, episode = 1L) {
	if (length(id) > 1) {
		return(map_df(id, ~ episodes_ratings(.x, season, episode)))
	}

	if (length(season) > 1) {
		return(map_df(season, ~ episodes_ratings(id, .x, episode)))
	}

	if (length(episode) > 1) {
		return(map_df(episode, ~ episodes_ratings(id, season, .x)))
	}

	# Construct URL, make API call
	url <- build_trakt_url(
		"shows",
		id,
		"seasons",
		season,
		"episodes",
		episode,
		"ratings"
	)
	response <- trakt_get(url = url)

	response |>
		fix_ratings_distribution() |>
		as_tibble() |>
		mutate(
			id = id,
			season = as.integer(season),
			episode = as.integer(episode)
		)
}
