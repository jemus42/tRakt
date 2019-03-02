#' Show or movie user ratings
#'
#' Returns a movie's or show's (or season's, or episode's) rating and ratings distribution.
#' If you *do not* want the full ratings distribution, it is highly advised to
#' just use `*.summary` functions or `trakt.seasons.season` for episode ratings.
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble][tibble::tibble-package].
#' @name media_ratings
#' @note Since this function is able to work on multi-length inputs for
#' `target`, `season` and `episode`, it is possible to get a lot of data, *but* at the cost
#' of one API call *per element in each argument*. Please be kind to the API.
#' @examples
#' \dontrun{
#' trakt.movies.ratings("tron-legacy-2010")
#' trakt.shows.ratings("game-of-thrones")
#' 
#' # Ratings for seasons 1 through 5
#' trakt.seasons.ratings("futurama", season = 1:5)
#' 
#' # Ratings for episodes 1 through 7 of season 1
#' trakt.episodes.ratings("futurama", season = 1, episode = 1:7)
#' }
NULL

#' @keywords internal
#' @importFrom dplyr mutate
#' @importFrom tibble as_tibble
#' @importFrom purrr map_df
trakt.media.ratings <- function(type = c("shows", "movies"), target) {
  type <- match.arg(type)

  if (length(target) > 1) {
    return(map_df(target, ~ trakt.media.ratings(type = type, target = .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "ratings")
  response <- trakt.api.call(url = url)

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
trakt.shows.ratings <- function(target) {
  trakt.media.ratings(type = "shows", target)
}

#' @rdname media_ratings
#' @export
trakt.movies.ratings <- function(target) {
  trakt.media.ratings(type = "movies", target)
}

# Seasons and episodes ratings ----

#' @rdname media_ratings
#' @export
#' @importFrom dplyr mutate
#' @importFrom tibble as_tibble
#' @importFrom purrr map_df
trakt.seasons.ratings <- function(target, season = 1L) {
  if (length(target) > 1) {
    return(map_df(target, ~ trakt.seasons.ratings(.x, season)))
  }

  if (length(season) > 1) {
    return(map_df(season, ~ trakt.seasons.ratings(target, .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", season, "ratings")
  response <- trakt.api.call(url = url)

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
trakt.episodes.ratings <- function(target, season = 1L, episode = 1L) {
  if (length(target) > 1) {
    return(map_df(target, ~ trakt.episodes.ratings(.x, season, episode)))
  }

  if (length(season) > 1) {
    return(map_df(season, ~ trakt.episodes.ratings(target, .x, episode)))
  }

  if (length(episode) > 1) {
    return(map_df(episode, ~ trakt.episodes.ratings(target, season, .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", season, "episodes", episode, "ratings")
  response <- trakt.api.call(url = url)

  response %>%
    fix_ratings_distribution() %>%
    as_tibble() %>%
    mutate(
      id = target,
      season = season,
      episode = episode
    )
}
