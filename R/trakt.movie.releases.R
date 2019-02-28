#' Get a movie's release details
#'
#' Retrieve one or more movie's release information,
#' including the release date, country code (two letter, e.g. `us`), and
#' the certification (e.g. `PG`).
#' @inheritParams trakt_api_common_parameters
#' @param country Optional two letter country code to filter by.
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/releases/get-all-movie-releases}{the
#'  trakt API docs for further info}
#' @family movie data
#' @examples
#' \dontrun{
#' trakt.movies.releases("tron-legacy-2010")
#' }
trakt.movies.releases <- function(target, country = NULL) {
  if (length(target) > 1) {
    return(purrr::map_df(target, ~trakt.movies.releases(target = .x, country = country)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("movies", target, "releases", country = country)
  response <- trakt.api.call(url = url)

  response %>%
    fix_datetime() %>%
    mutate(movie = target) %>%
    as_tibble()
}
