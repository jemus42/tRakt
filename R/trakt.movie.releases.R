#' Get a movie's release details
#'
#' `trakt.movie.releases` returns one or more movie's release information,
#' including the release date, country code (two letter, e.g. `us`), and
#' the certification (e.g. `PG`).
#' @param target The `id` of the movie requested. Either the `slug`
#' (e.g. `"tron-legacy-2010"`), `trakt id` or `IMDb id`. If multiple targets are
#' provided, an additional `movie` column is appended to the `rbind`ed results, containing
#' the movie's `id` provided as `target`.
#' @param country Optional two letter country code.
#' @return A `data.frame` containing movie release dates and certification.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/releases/get-all-movie-releases}{the
#'  trakt API docs for further info}
#' @family movie data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movie.releases("tron-legacy-2010")
#' }
trakt.movie.releases <- function(target, country = NULL) {
  if (length(target) > 1) {
    response <- purrr::map_df(target, function(t) {
      response <- trakt.movie.releases(target = t, country = country)
      response$movie <- t

      return(response)
    })
    return(response)
  }

  # Construct URL, make API call
  url <- build_trakt_url("movies", target, "releases", country = country)
  response <- trakt.api.call(url = url)

  if (identical(response, data.frame())) return(tibble::tibble())

  response$release_date <- lubridate::as_date(response$release_date)

  tibble::as_tibble(response)
}
