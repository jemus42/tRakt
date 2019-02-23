#' @rdname trakt.related
#' @export
trakt.movies.related <- function(target, extended = c("min", "full")) {
  trakt.related(target, type = "movies", extended = extended)
}

#' @rdname trakt.related
#' @export
trakt.shows.related <- function(target, extended = c("min", "full")) {
  trakt.related(target, type = "shows", extended = extended)
}

#' Search for related shows or movies
#'
#' Receive a set of shows that are related to a specific show/movie
#' @param target The `id` of the show/movie requested. Either the `slug`
#' (e.g. `"game-of-thrones"`), `trakt id` or `IMDb id`
#' @inheritParams extended_info
#' @inheritParams type_shows_movies
#' @inherit return_tibble return
#' @export
#' @examples
#' \dontrun{
#' trakt.related("breaking-bad", "shows")
#' }
trakt.related <- function(target, type = c("shows", "movies"), extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (length(target) > 1) {
    response <- purrr::map_df(target, function(t) {
      trakt.related(target = t, type = type, extended = extended)
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
