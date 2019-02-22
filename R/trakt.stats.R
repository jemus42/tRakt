#' Get a show or movie's stats
#'
#' `trakt.stats` pulls show stats and returns it compactly.
#' The data includes show ratings, scrobbles, checkins, plays, comments...
#' @param target The `id` of the show/movie requested. Either the `slug`
#' (e.g. `"game-of-thrones"`), `trakt id` or `IMDb id`.
#' @param type Either `shows` (default) or `movies`, depending the `target` type.
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/stats}{the trakt API docs for further info}
#' @family show data
#' @family movie data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.stats <- trakt.stats(type = "shows", "breaking-bad")
#' }
trakt.stats <- function(target, type = c("shows", "movies")) {
  match.arg(type)

  if (length(type) > 1) type <- type[1]

  if (length(target) > 1) {
    res <- purrr::map_df(target, ~ trakt.stats(.x, type = type))
    return(res)
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "stats")
  response <- trakt.api.call(url = url)
  response$type <- type
  response$id <- target

  tibble::as_tibble(response)
}
