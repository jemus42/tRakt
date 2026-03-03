#' Get a user's watchlist
#'
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @export
#' @family user data
#' @eval apiurl("users", "watchlist")
#' @examples
#' \dontrun{
#' # Defaults to movie watchlist and minimal info
#' user_watchlist(user = "sean")
#' }
user_watchlist <- function(user = "me", type = c("movies", "shows"), extended = "min") {
	check_username(user)
	type <- match.arg(type)

	if (length(user) > 1) {
		return(map_rbind(user, \(x) user_watchlist(user = x, type, extended), .names_to = "user"))
	}

	extended <- validate_extended(extended)

	# Construct URL, make API call
	url <- build_trakt_url("users", user, "watchlist", type, extended = extended$query_value)
	response <- trakt_get(url = url)

	if (identical(response, tibble())) {
		return(response)
	}

	if (type == "shows") {
		response <- cbind(
			response[names(response) != "show"],
			unpack_show(response$show, keep_images = extended$keep_images)
		)
	} else if (type == "movies") {
		response <- unpack_movie(response, keep_images = extended$keep_images)
	}

	fix_tibble_response(response, keep_images = extended$keep_images)
}
