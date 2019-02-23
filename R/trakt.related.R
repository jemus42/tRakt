#' Search for related movies
#'
#' `trakt.movies.related` returns movies related to the input movie.
#'
#' Receive a set of movies that are related to a specific movie.
#' @param target The `id` of the movie requested. Either the `slug`
#' (e.g. `"tron-legacy-2010"`), `trakt id` or `IMDb id`. If multiple `target`s are
#' provided, the results will be `rbind`ed together and a `source` column as appended,
#' containing the provided `id` of the input.
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`.
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/related/get-related-movies}{the trakt API docs for further info}
#' @family movie data
#' @family aggregated data
#' @examples
#' \dontrun{
#' library(tRakt)
#' related <- trakt.movies.related("tron-legacy-2010")
#' }
trakt.movies.related <- function(target, extended = c("min", "full")) {
  trakt.related(target, type = "movies", extended = extended)
}

#' Search for related shows
#'
#' `trakt.shows.related` returns shows related to the input show.
#'
#' Receive a set of shows that are related to a specific show.
#' @param target The `id` of the movie requested. Either the `slug`
#' (e.g. `"tron-legacy-2010"`), `trakt id` or `IMDb id`. If multiple `target`s are
#' provided, the results will be `rbind`ed together and a `source` column as appended,
#' containing the provided `id` of the input.
#' @inheritParams trakt.movies.related
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/related/get-related-shows}{the trakt API docs for further info}
#' @family show data
#' @family aggregated data
#' @examples
#' \dontrun{
#' library(tRakt)
#' related <- trakt.shows.related("game-of-thrones")
#' }
trakt.shows.related <- function(target, extended = c("min", "full")) {
  trakt.related(target, type = "shows", extended = extended)
}

#' Search for related shows or movies
#'
#' `trakt.related` returns shows or movies related to the input show/movie.
#' Receive a set of shows that are related to a specific show/movie
#' @param target The `id` of the show/movie requested. Either the `slug`
#' (e.g. `"game-of-thrones"`), `trakt id` or `IMDb id`
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`
#' @keywords internal
trakt.related <- function(target, type, extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (length(target) > 1) {
    response <- purrr::map_df(target, function(t) {
      response <- trakt.related(target = t, type = type, extended = extended)
      return(response)
    })
    return(response)
  }
  # Construct URL, make API call
  url <- build_trakt_url(type, target, "related", extended = extended)
  response <- trakt.api.call(url = url)

  # Flattening
  response <- cbind(response[names(response) != "ids"], response$ids)
  response$related_to <- target

  tibble::as_tibble(response)
}
