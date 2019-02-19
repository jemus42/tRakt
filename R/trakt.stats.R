#' [Defunct] Get a show or movie's stats
#'
#' DEFUNCT as of 2015-03-06,
#' see \href{http://docs.trakt.apiary.io/reference/shows/stats/get-show-stats}{their API docs}
#'
#' `trakt.stats` pulls show stats and returns it compactly.
#' The data includes show ratings, scrobbles, checkins, plays, comments…
#' @param target The `id` of the show/movie requested. Either the `slug`
#' (e.g. `"game-of-thrones"`), `trakt id` or `IMDb id`.
#' @param type Either `shows` (default) or `movies`, depending the `target` type.
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`.
#' @return A `list` containing show stats
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/stats}{the trakt API docs for further info}
#' @family show data
#' @family movie data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.stats <- trakt.stats(type = "shows", "breaking-bad")
#' }
trakt.stats <- function(target, type = "shows", extended = "min") {

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "stats", extended = extended)
  response <- trakt.api.call(url = url)

  return(response)
}
