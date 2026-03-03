#' Get the weekend box office
#'
#' Returns the top 10 grossing movies in the U.S. box office last weekend.
#' Updated every Monday morning.
#'
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @export
#' @family movie data
#' @eval apiurl("movies", "box office")
#' @importFrom tibble as_tibble
#' @examples
#' movies_boxoffice()
movies_boxoffice <- function(extended = "min") {
	extended <- validate_extended(extended)

	# Construct URL, make API call
	url <- build_trakt_url("movies/boxoffice", extended = extended$query_value)
	response <- trakt_get(url = url)

	response |>
		unpack_movie(keep_images = extended$keep_images) |>
		fix_tibble_response(keep_images = extended$keep_images)
}
