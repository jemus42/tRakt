#' Get show or movie user ratings
#'
#' Returns a show's or movie's rating and ratings distribution.
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
#' trakt.seasons.ratings("futurama", season = 1:5)
#' trakt.episodes.ratings("futurama", season = 1, episode = 1:7)
#' }
NULL

#' @keywords internal
trakt.ratings <- function(type = c("shows", "movies"), target) {
  type <- match.arg(type)

  if (length(target) > 1) {
    ret <- purrr::map_df(target, function(t) {
      trakt.ratings(type = type, target = t)
    })
    return(ret)
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "ratings")
  response <- trakt.api.call(url = url)

  response$distribution <- tibble::enframe(unlist(response$distribution),
                                           name = "rating", value = "n")

  tibble::tibble(
    id = target,
    type = type,
    votes = response$votes,
    rating = response$rating,
    distribution = list(response$distribution)
  )
}

# Aliases for show/movie ratings ----

#' @rdname media_ratings
#' @export
trakt.shows.ratings <- function(target) {
  trakt.ratings(type = "shows", target)
}

#' @rdname media_ratings
#' @export
trakt.movies.ratings <- function(target) {
  trakt.ratings(type = "movies", target)
}

# Seasons and episodes ratings ----

#' @rdname media_ratings
#' @param season `integer(1) [1L]`: The season number. If longer, e.g. `1:5`, the function
#' is vectorized and the output will be combined via [purrr::map_df].
#' @export
trakt.seasons.ratings <- function(target, season = 1) {
  if (length(target) > 1) {
    ret <- purrr::map_df(target, function(t) {
      trakt.seasons.ratings(target = t, season = season)
    })
    return(ret)
  }

  if (length(season) > 1) {
    ret <- purrr::map_df(season, function(season) {
      trakt.seasons.ratings(target = target, season = season)
    })
    return(ret)
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", season, "ratings")
  response <- trakt.api.call(url = url)

  response$distribution <- tibble::enframe(unlist(response$distribution),
                                           name = "rating", value = "n")

  tibble::tibble(
    id = target,
    season = season,
    votes = response$votes,
    rating = response$rating,
    distribution = list(response$distribution)
  )
}

#' @rdname media_ratings
#' @param episode `integer(1) [1L]`: The episode number. If longer, e.g. `1:13`, the function
#' is vectorized and the output will be combined via [purrr::map_df].
#' @export
trakt.episodes.ratings <- function(target, season = 1, episode = 1) {
  if (length(target) > 1) {
    ret <- purrr::map_df(target, function(t) {
      trakt.episodes.ratings(target = t, season = season, episode = episode)
    })
    return(ret)
  }

  if (length(season) > 1) {
    ret <- purrr::map_df(season, function(season) {
      trakt.episodes.ratings(target = target, season = season, episode = episode)
    })
    return(ret)
  }

  if (length(episode) > 1) {
    ret <- purrr::map_df(episode, function(episode) {
      trakt.episodes.ratings(target = target, season = season, episode = episode)
    })
    return(ret)
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", season, "episodes", episode, "ratings")
  response <- trakt.api.call(url = url)

  response$distribution <- tibble::enframe(unlist(response$distribution),
                                           name = "rating", value = "n")

  tibble::tibble(
    id = target,
    season = season,
    episode = episode,
    votes = response$votes,
    rating = response$rating,
    distribution = list(response$distribution)
  )
}

multi_ratings <- trakt.episodes.ratings(target = c("futurama", "the-simpsons"),
                                        season = 1:2, episode = 1:2)
