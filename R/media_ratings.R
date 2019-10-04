#' Media user ratings
#'
#' Returns a movie's or show's (or season's, or episode's) rating and ratings distribution.
#' If you *do not* want the full ratings distribution, it is highly advised to
#' just use `*_summary` functions or [seasons_season] for episode ratings.
#' @details
#' The API methods for these functions are:
#'
#' - [/movies/:id/ratings](https://trakt.docs.apiary.io/#reference/movies/ratings/get-movie-ratings)
#' - [/shows/:id/ratings](https://trakt.docs.apiary.io/#reference/shows/ratings/get-show-ratings)
#' - [/shows/:id/seasons/:season/ratings](https://trakt.docs.apiary.io/#reference/seasons/ratings/get-season-ratings)
#' - [/shows/:id/seasons/:season/episodes/:episode/ratings](https://trakt.docs.apiary.io/#reference/episodes/ratings/get-episode-ratings)
#'
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @name media_ratings
#' @note Since this function is able to work on multi-length inputs for
#' `target`, `season` and `episode`, it is possible to get a lot of data, *but* at the cost
#' of one API call *per element in each argument*. Please be kind to the API.
#' @examples
#' # A movie's ratings
#' movies_ratings("tron-legacy-2010")
#'
#' # A show's ratings
#' shows_ratings("game-of-thrones")
#' \dontrun{
#' # Ratings for seasons 1 through 5
#' seasons_ratings("futurama", season = 1:5)
#'
#' # Ratings for episodes 1 through 7 of season 1
#' episodes_ratings("futurama", season = 1, episode = 1:7)
#' }
NULL

#' @keywords internal
#' @importFrom dplyr mutate
#' @importFrom tibble as_tibble
#' @importFrom purrr map_df
media_ratings <- function(type = c("shows", "movies"), target) {
  type <- match.arg(type)

  if (length(target) > 1) {
    return(map_df(target, ~ media_ratings(type = type, target = .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "ratings")
  response <- trakt_get(url = url)

  response %>%
    fix_ratings_distribution() %>%
    as_tibble() %>%
    mutate(
      id = target,
      type = type
    )
}

# Aliases for show/movie ratings ----

#' @rdname media_ratings
#' @export
shows_ratings <- function(target) {
  media_ratings(type = "shows", target)
}

#' @rdname media_ratings
#' @export
movies_ratings <- function(target) {
  media_ratings(type = "movies", target)
}

# Seasons and episodes ratings ----

#' @rdname media_ratings
#' @export
#' @importFrom dplyr mutate
#' @importFrom tibble as_tibble
#' @importFrom purrr map_df
seasons_ratings <- function(target, season = 1L) {
  if (length(target) > 1) {
    return(map_df(target, ~ seasons_ratings(.x, season)))
  }

  if (length(season) > 1) {
    return(map_df(season, ~ seasons_ratings(target, .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", season, "ratings")
  response <- trakt_get(url = url)

  response %>%
    fix_ratings_distribution() %>%
    as_tibble() %>%
    mutate(
      id = target,
      season = season
    )
}

#' @rdname media_ratings
#' @export
#' @importFrom dplyr mutate
#' @importFrom tibble as_tibble
#' @importFrom purrr map_df
episodes_ratings <- function(target, season = 1L, episode = 1L) {
  if (length(target) > 1) {
    return(map_df(target, ~ episodes_ratings(.x, season, episode)))
  }

  if (length(season) > 1) {
    return(map_df(season, ~ episodes_ratings(target, .x, episode)))
  }

  if (length(episode) > 1) {
    return(map_df(episode, ~ episodes_ratings(target, season, .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url(
    "shows", target,
    "seasons", season,
    "episodes", episode,
    "ratings"
  )
  response <- trakt_get(url = url)

  response %>%
    fix_ratings_distribution() %>%
    as_tibble() %>%
    mutate(
      id = target,
      season = as.integer(season),
      episode = as.integer(episode)
    )
}