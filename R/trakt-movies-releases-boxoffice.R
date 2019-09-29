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
#' trakt.movies.releases("tron-legacy-2010")
#' }
trakt.movies.releases <- function(target, country = NULL) {
  if (length(target) > 1) {
    return(map_df(target, ~ trakt.movies.releases(target = .x, country = country)))
  }

  country <- check_filter_arg(country, filter_type = "countries")

  # Construct URL, make API call
  url <- build_trakt_url("movies", target, "releases", country = country)
  response <- trakt_get(url = url)

  response %>%
    mutate(movie = target) %>%
    fix_tibble_response()
}

#' Get the weekend box office
#'
#' Returns the top 10 grossing movies in the U.S. box office last weekend.
#' Updated every Monday morning.
#'
#' @details
#' This function wraps
#' [movies/boxoffice](https://trakt.docs.apiary.io/#reference/movies/box-office/get-the-weekend-box-office).
#'
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @family movie data
#' @importFrom tibble as_tibble
#' @examples
#' trakt.movies.boxoffice()
trakt.movies.boxoffice <- function(extended = c("min", "full")) {
  extended <- match.arg(extended)

  # Construct URL, make API call
  url <- build_trakt_url("movies/boxoffice", extended = extended)
  response <- trakt_get(url = url)

  response %>%
    unpack_movie() %>%
    fix_tibble_response()
}
