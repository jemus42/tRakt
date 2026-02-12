#' Get a movie's release details
#'
#' Retrieve one or more movie's release information,
#' including the release date, country code (two letter, e.g. `us`), and
#' the certification (e.g. `PG`).
#' @inheritParams trakt_api_common_parameters
#' @param country Optional two letter country code to filter by. See [trakt_countries]
#'   for a table of country codes.
#' @inherit trakt_api_common_parameters return
#' @export
#' @eval apiurl("movies", "releases")
#' @family movie data
#' @examples
#' \dontrun{
#' movies_releases("tron-legacy-2010")
#' }
movies_releases <- function(id, country = NULL) {
	if (length(id) > 1) {
		return(map(id, \(x) movies_releases(id = x, country = country)) |> list_rbind())
	}

	country <- check_filter_arg(country, filter_type = "countries")

	# Construct URL, make API call
	url <- build_trakt_url("movies", id, "releases", country = country)
	response <- trakt_get(url = url)

	response |>
		mutate(movie = id) |>
		fix_tibble_response()
}
