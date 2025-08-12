#' Get a user's watchlist
#'
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @export
#' @importFrom tibble as_tibble
#' @importFrom tibble tibble
#' @importFrom purrr map_df
#' @family user data
#' @eval apiurl("users", "watchlist")
#' @examples
#' \dontrun{
#' # Defaults to movie watchlist and minimal info
#' user_watchlist(user = "sean")
#' }
user_watchlist <- function(user = "me", type = c("movies", "shows"), extended = c("min", "full")) {
	check_username(user)
	type <- match.arg(type)
	extended <- match.arg(extended)

	if (length(user) > 1) {
		names(user) <- user
		return(map_df(user, \(x) user_watchlist(user = x, type, extended), .id = "user"))
	}

	# Construct URL, make API call
	url <- build_trakt_url("users", user, "watchlist", type, extended = extended)
	response <- trakt_get(url = url)

	if (identical(response, tibble())) {
		return(response)
	}

	if (type == "shows") {
		response <- cbind(response[names(response) != "show"], unpack_show(response$show))
	} else if (type == "movies") {
		response <- unpack_movie(response)
	}

	fix_tibble_response(response)
}
