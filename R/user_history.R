#' Get a user's watch history
#'
#' Retrieve a the last `limit` items a user has watched, including the method by
#' which it was logged (e.g. *scrobble* or *checkin*).
#' @details
#' This function wraps the API method
#' [`/users/:id/history/:type`](https://trakt.docs.apiary.io/#reference/users/history/get-watched-history).
#' @inheritParams trakt_api_common_parameters
#' @param start_at,end_at `character(1)`: A time-window to filter by. Must be coercible
#' to a datetime object of class `POSIXct`. See [ISOdate] for further information.
#' @family user data
#' @eval apiurl("users", "history")
#' @importFrom dplyr bind_cols select rename rename_all
#' @importFrom rlang is_empty
#' @inherit trakt_api_common_parameters return
#' @note For `type = "shows"`, the
#' original output contains a nested object with `show` and `episode` data,
#' which are unnested by this function. Due to duplicate variable names,
#' all episode-related variables are prefixed with `episode_`. This results in the
#' episode number having the name `episode_episode`, which is quite silly. Sorry.
#' @export
#' @examples
#' \dontrun{
#' # Shows user "jemus42" watched around christmas 2016
#' user_history(
#'   user = "jemus42", type = "shows", limit = 5,
#'   start_at = "2015-12-24", end_at = "2015-12-28"
#' )
#' }
user_history <- function(
	user = "me",
	type = c("shows", "movies", "seasons", "episodes"),
	item_id = NULL,
	limit = 10L,
	start_at = NULL,
	end_at = NULL,
	extended = c("min", "full")
) {
	check_username(user)
	type <- match.arg(type)
	extended <- match.arg(extended)

	start_at <- if (!is.null(start_at)) format(as.POSIXct(start_at), "%FT%T.000Z", tz = "UTC")
	end_at <- if (!is.null(end_at)) format(as.POSIXct(end_at), "%FT%T.000Z", tz = "UTC")

	if (length(user) > 1) {
		return(map_rbind(
			user,
			\(x) user_history(user = x, type, item_id = item_id, limit, start_at, end_at, extended),
			.names_to = "user"
		))
	}

	# Construct URL, make API call
	url <- build_trakt_url(
		"users",
		user,
		"history",
		type,
		item_id = item_id,
		extended = extended,
		limit = limit,
		start_at = start_at,
		end_at = end_at
	)
	response <- trakt_get(url = url)
	response <- as_tibble(response)

	if (is_empty(response)) {
		return(tibble())
	}

	if (type == "shows") {
		response <- bind_cols(
			# History metadata
			response |>
				select(-"show", -"episode"),
			# Unpacked show data
			unpack_show(response$show),
			# Unpacked episode data
			response$episode |>
				select(-"ids") |>
				bind_cols(fix_ids(response$episode$ids)) |>
				rename(episode = "number") |>
				fix_tibble_response() |>
				rename_all(\(x) paste0("episode_", x))
		)
	}
	if (type == "movies") {
		response <- unpack_movie(response)
	}

	fix_tibble_response(response)
}
