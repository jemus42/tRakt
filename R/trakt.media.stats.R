#' Get a show or movie's stats
#'
#' The data includes show/movie ratings, scrobbles, checkins, plays, comments...
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @examples
#' \dontrun{
#' trakt.shows.stats(c("breaking-bad", "game-of-thrones"))
#' }
trakt.media.stats <- function(type = c("shows", "movies"), target) {
  type <- match.arg(type)

  if (length(target) > 1) {
    res <- purrr::map_df(target, ~ trakt.media.stats(type, .x))
    return(res)
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "stats")
  response <- trakt.api.call(url = url)
  response$type <- type
  response$id <- target

  tibble::as_tibble(response)
}

# Derived ----

#' @rdname trakt.media.stats
#' @export
trakt.shows.stats <- function(target) {
  trakt.media.stats(type = "shows", target)
}

#' @rdname trakt.media.stats
#' @export
trakt.movies.stats <- function(target) {
  trakt.media.stats(type = "movies", target)
}
