#' Get a user's watched shows or movies
#'
#' For private users, an [authenticated request][trakt_credentials] is required.
#'
#' @inheritParams trakt_api_common_parameters
#' @param noseasons `logical(1) [TRUE]`: Only for `type = "show"`: Exclude detailed season
#' data from output. This is advisable if you do not need per-episode data and want to
#' be nice to the API.
#' @inherit trakt_api_common_parameters return
#' @export
#' @family user data
#' @eval apiurl("users", "watched")
#' @importFrom dplyr bind_cols select matches everything
#' @importFrom purrr pluck map
#' @importFrom rlang is_empty
#' @examples
#' \dontrun{
#' # Use noseasons = TRUE to avoid receiving detailed season/episode data
#' user_watched(user = "sean", noseasons = TRUE)
#' }
user_watched <- function(
	user = "me",
	type = c("shows", "movies"),
	noseasons = TRUE,
	extended = "min"
) {
	check_username(user)
	type <- match.arg(type)

	if (length(user) > 1) {
		return(map_rbind(
			user,
			\(x) user_watched(user = x, type = type, noseasons = noseasons, extended = extended),
			.names_to = "user"
		))
	}

	# Combine extended with noseasons modifier before validation
	extended_input <- if (type == "shows" && noseasons) c(extended, "noseasons") else extended
	extended <- validate_extended(extended_input)

	# Construct URL, make API call
	url <- build_trakt_url("users", user, "watched", type, extended = extended$query_value)
	response <- trakt_get(url = url)

	if (is_empty(response)) {
		return(tibble())
	}

	if (type == "shows") {
		# Unpack the show media object and bind it to the base tbl
		response <- response |>
			select(-"show") |>
			bind_cols(
				pluck(response, "show") |> unpack_show(keep_images = extended$keep_images)
			) |>
			select(
				-matches("^seasons$"),
				everything(),
				matches("^seasons$")
			)
		# This uses contains() because the seasons column might not exist
		# and this way I don't have to use an extra if-statement to check "noseasons == TRUE"
	} else if (type == "movies") {
		response <- unpack_movie(response, keep_images = extended$keep_images)
	}

	fix_tibble_response(response, keep_images = extended$keep_images)
}
