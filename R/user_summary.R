#' Get a user's profile
#'
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @export
#' @note If the specified user is private, you need to be able to make an [authenticated
#' request][trakt_credentials] and be friends with the user.
#' @family user data
#' @family summary methods
#' @eval apiurl("users", "profile")
#' @examples
#' \dontrun{
#' user_profile("sean")
#' }
user_profile <- function(user = "me", extended = "min") {
	check_username(user)

	if (length(user) > 1) {
		return(map_rbind(user, \(x) user_profile(user = x, extended)))
	}

	extended <- validate_extended(extended)

	# Construct URL, make API call
	url <- build_trakt_url("users", user, extended = extended$query_value)
	response <- trakt_get(url = url)

	response |>
		as_tibble() |>
		unpack_user()
}
