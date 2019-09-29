#' Get a show or movie's stats
#'
#' The data contains watchers, playes, collectors, comments, lists, and votes.
#'
#' @details
#' The API methods for these functions are:
#'
#' - [/movies/:id/stats](https://trakt.docs.apiary.io/#reference/movies/stats/get-movie-stats)
#' - [/shows/:id/stats](https://trakt.docs.apiary.io/#reference/shows/stats/get-show-stats)
#' - [/shows/:id/seasons/:season/stats](https://trakt.docs.apiary.io/#reference/seasons/stats/get-season-stats)
#' - [/shows/:id/seasons/:season/episodes/:episode/stats](https://trakt.docs.apiary.io/#reference/episodes/stats/get-episode-stats)
#'
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @name media_stats
#' @examples
#' # Stats for a movie
#' trakt.movies.stats("inception-2010")
#' \dontrun{
#' # Stats for multiple shows at once
#' trakt.shows.stats(c("breaking-bad", "game-of-thrones"))
#'
#' # Stats for multiple episodes
#' trakt.episodes.stats("futurama", season = 1, episode = 1:7)
#' }
NULL

#' @keywords internal
#' @noRd
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
trakt.media.stats <- function(type = c("shows", "movies"), target) {
  type <- match.arg(type)

  if (length(target) > 1) {
    return(map_df(target, ~ trakt.media.stats(type, .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "stats")
  response <- trakt_get(url = url)
  response$type <- type
  response$id <- target

  as_tibble(response)
}

# Derived ----

#' @rdname media_stats
#' @export
trakt.shows.stats <- function(target) {
  trakt.media.stats(type = "shows", target)
}

#' @rdname media_stats
#' @export
trakt.movies.stats <- function(target) {
  trakt.media.stats(type = "movies", target)
}

#' @rdname media_stats
#' @export
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
trakt.seasons.stats <- function(target, season = 1L) {
  if (length(target) > 1) {
    return(map_df(target, ~ trakt.seasons.stats(.x, season)))
  }

  if (length(season) > 1) {
    return(map_df(season, ~ trakt.seasons.stats(target, .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", season, "stats")
  response <- trakt_get(url = url)
  response$season <- season
  response$id <- target

  as_tibble(response)
}

#' @rdname media_stats
#' @export
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
trakt.episodes.stats <- function(target, season = 1L, episode = 1L) {
  if (length(target) > 1) {
    return(map_df(target, ~ trakt.episodes.stats(.x, season, episode)))
  }

  if (length(season) > 1) {
    return(map_df(season, ~ trakt.episodes.stats(target, .x, episode)))
  }

  if (length(episode) > 1) {
    return(map_df(episode, ~ trakt.episodes.stats(target, season, .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", season, "episodes", episode, "stats")
  response <- trakt_get(url = url)
  response$season <- season
  response$episode <- episode
  response$id <- target

  as_tibble(response)
}
