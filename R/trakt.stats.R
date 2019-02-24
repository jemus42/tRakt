#' Get a show or movie's stats
#'
#' `trakt.stats` pulls show stats and returns it compactly.
#' The data includes show ratings, scrobbles, checkins, plays, comments...
#' @inheritParams id_movie_show
#' @inheritParams type_shows_movies
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
  type <- match.arg(type)

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
