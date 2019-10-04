#' Get a movie's release details
#'
#' Retrieve one or more movie's release information,
#' including the release date, country code (two letter, e.g. `us`), and
#' the certification (e.g. `PG`).
#' @inheritParams trakt_api_common_parameters
#' @param country Optional two letter country code to filter by.
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @details
#' This function wraps the endpoint
#' [movies/:id/releases/:country](http://docs.trakt.apiary.io/reference/movies/releases/get-all-movie-releases)
#' @family movie data
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
#' @examples
#' \dontrun{
#' movies_releases("tron-legacy-2010")
#' }
movies_releases <- function(target, country = NULL) {
  if (length(target) > 1) {
    return(map_df(target, ~ movies_releases(target = .x, country = country)))
  }

  country <- check_filter_arg(country, filter_type = "countries")

  # Construct URL, make API call
  url <- build_trakt_url("movies", target, "releases", country = country)
  response <- trakt_get(url = url)

  response %>%
    mutate(movie = target) %>%
    fix_tibble_response()
}
