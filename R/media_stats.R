#' Get a show or movie's (or season's or episode's) stats
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
#' movies_stats("inception-2010")
#' \dontrun{
#' # Stats for multiple shows at once
#' shows_stats(c("breaking-bad", "game-of-thrones"))
#'
#' # Stats for multiple episodes
#' episodes_stats("futurama", season = 1, episode = 1:7)
#' }
NULL

#' @keywords internal
#' @noRd
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
media_stats <- function(type = c("shows", "movies"), target) {
  type <- match.arg(type)

  if (length(target) > 1) {
    return(map_df(target, ~ media_stats(type, .x)))
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
shows_stats <- function(target) {
  media_stats(type = "shows", target)
}

#' @rdname media_stats
#' @export
movies_stats <- function(target) {
  media_stats(type = "movies", target)
}

#' @rdname media_stats
#' @export
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
seasons_stats <- function(target, season = 1L) {
  if (length(target) > 1) {
    return(map_df(target, ~ seasons_stats(.x, season)))
  }

  if (length(season) > 1) {
    return(map_df(season, ~ seasons_stats(target, .x)))
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
episodes_stats <- function(target, season = 1L, episode = 1L) {
  if (length(target) > 1) {
    return(map_df(target, ~ episodes_stats(.x, season, episode)))
  }

  if (length(season) > 1) {
    return(map_df(season, ~ episodes_stats(target, .x, episode)))
  }

  if (length(episode) > 1) {
    return(map_df(episode, ~ episodes_stats(target, season, .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", season, "episodes", episode, "stats")
  response <- trakt_get(url = url)
  response$season <- season
  response$episode <- episode
  response$id <- target

  as_tibble(response)
}
