#' Get a user's ratings
#'
#' Retrieve a user's media ratings
#' @inheritParams trakt_api_common_parameters
#' @param rating `integer(1) [NULL]`: Optional rating between `1` and `10` to filter by.
#' @param limit `integer(1) [NULL]`: Number of items to return. If `NULL` (default), all items are returned.
#' @inherit trakt_api_common_parameters return
#' @export
#' @family user data
#' @eval apiurl("users", "ratings")
#' @importFrom dplyr bind_cols rename
#' @importFrom purrr map list_rbind
#' @examples
#' \dontrun{
#' user_ratings(user = "jemus42", "shows")
#' user_ratings(user = "sean", type = "movies")
#' }
user_ratings <- function(
	user = "me",
	type = c("movies", "seasons", "shows", "episodes"),
	rating = NULL,
	extended = c("min", "full"),
	limit = NULL
) {
	check_username(user)
	type <- match.arg(type)
	extended <- match.arg(extended)

	if (!is.null(rating)) {
		if (!(as.integer(rating) %in% 1:10)) {
			stop("rating must be an integer between 1 and 10")
		}
	}

	if (length(user) > 1) {
		names(user) <- user
		return(map(user, \(x) user_ratings(user = x, type, rating, extended, limit)) |> list_rbind(names_to = "user"))
	}

	# Construct URL, make API call
	url <- build_trakt_url("users", user, "ratings", type, rating, extended = extended, limit = limit)
	response <- trakt_get(url = url)

	if (identical(response, tibble())) {
		return(response)
	}

	# Flattening
	if (type == "movies") {
		response <- unpack_movie(response)
	}

	if (type == "shows") {
		response <- response |>
			select(-"show") |>
			bind_cols(unpack_show(response$show))
	}

	if (type == "seasons") {
		# Also keeping seasons and show object separate, see comment below
		response$season <- bind_cols(
			response$season |> select(-"ids"),
			fix_ids(response$season$ids)
		) |>
			as_tibble() |>
			rename(season = "number") |>
			fix_datetime()

		response$show <- unpack_show(response$show)
	}

	if (type == "episodes") {
		# Keep episode and show objects as separate list-like items so
		# the result is still data.frame-ish enough and duplicate names
		# don't cause headaches that way. Not perfectly tidy, but tidy enough.
		response$episode <- bind_cols(
			response$episode |> select(-"ids"),
			fix_ids(response$episode$ids)
		) |>
			as_tibble() |>
			rename(episode = "number")

		response$show <- unpack_show(response$show)
	}
	fix_tibble_response(response)
}
