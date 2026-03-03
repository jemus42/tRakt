#' Get a user's collected shows or movies
#'
#'
#' @details
#' This function wraps the API method
#' [`/users/:user_id/collection/:type`](https://trakt.docs.apiary.io/#reference/users/collection/get-collection).
#' @note The `extended = "metadata"` API parameter can be used to add media
#' information like `media_type`, `resolution`, `audio`, `audio_channels` and `3D`
#' to the output. Combine with `"full"` as `extended = "full,metadata"`.
#'
#' @inheritParams trakt_api_common_parameters
#' @param unnest_episodes `logical(1) [FALSE]`: Unnests episode data using
#' [tidyr::unnest()] and returns one row per episode rather than one row per show.
#' @inherit trakt_api_common_parameters return
#' @export
#' @family user data
#' @eval apiurl("users", "collection")
#' @importFrom lubridate ymd_hms
#' @importFrom dplyr mutate select bind_cols rename everything
#' @importFrom purrr pluck
#' @importFrom rlang is_empty
#' @examples
#' \dontrun{
#' user_collection(user = "sean", type = "movies")
#' user_collection(user = "sean", type = "shows")
#' }
user_collection <- function(
	user = "me",
	type = c("shows", "movies"),
	unnest_episodes = FALSE,
	extended = "min"
) {
	check_username(user)
	type <- match.arg(type)

	if (type == "movie" && unnest_episodes) {
		cli::cli_warn("{.arg unnest_episodes} only applies to {.code type = \"shows\"}.")
	}

	if (length(user) > 1) {
		return(map_rbind(
			user,
			\(x) {
				user_collection(
					user = x,
					type = type,
					unnest_episodes = unnest_episodes,
					extended = extended
				)
			},
			.names_to = "user"
		))
	}

	extended <- validate_extended(extended)

	# Construct URL, make API call
	url <- build_trakt_url("users", user, "collection", type, extended = extended$query_value)
	response <- trakt_get(url = url)

	if (is_empty(response)) {
		return(tibble())
	}

	if (type == "shows") {
		response <- response |>
			select(-"show") |>
			bind_cols(
				pluck(response, "show") |>
					unpack_show(keep_images = extended$keep_images)
			) |>
			as_tibble() |>
			select(-"seasons", everything(), "seasons") |>
			mutate(seasons = map(.data[["seasons"]], as_tibble))

		# I think importing tidyr for this alone is worth it, because
		# A list structure this big and deeply nested is just wrong:
		# (response[[11]][[1]])[[2]][[1]][[2]]

		if (unnest_episodes) {
			if (!requireNamespace("tidyr", quietly = TRUE)) {
				cli::cli_abort("This functionality requires the {.pkg tidyr} package.")
			}

			response <- as_tibble(response) |>
				tidyr::unnest(cols = "seasons") |>
				rename(season = "number") |>
				tidyr::unnest(cols = "episodes") |>
				rename(episode = "number") |>
				mutate(collected_at = ymd_hms(.data[["collected_at"]]))
		}
	} else if (type == "movies") {
		response <- unpack_movie(response, keep_images = extended$keep_images)
	}

	fix_tibble_response(response, keep_images = extended$keep_images)
}
