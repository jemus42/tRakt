#' Get who's watching a thing right now
#' @name media_watching
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#'
#' @examples
#' \dontrun{
#' movies_watching("deadpool-2016")
#' shows_watching("the-simpsons")
#' seasons_watching("the-simpsons", season = 6)
#' episodes_watching("the-simpsons", season = 6, episode = 12)
#' }
NULL

#' @describeIn media_watching Who's watching a movie.
#' @eval apiurl("movies", "watching")
#' @family movie data
#' @export
movies_watching <- function(id, extended = c("min", "full")) {
  extended <- match.arg(extended)

  url <- build_trakt_url("movies", id, "watching", extended = extended)
  response <- trakt_get(url)

  unpack_user(response)
}

#' @describeIn media_watching Who's watching a show.
#' @eval apiurl("shows", "watching")
#' @family show data
#' @export
shows_watching <- function(id, extended = c("min", "full")) {
  extended <- match.arg(extended)

  url <- build_trakt_url("shows", id, "watching", extended = extended)
  response <- trakt_get(url)

  unpack_user(response)
}

#' @describeIn media_watching Who's watching a season.
#' @eval apiurl("episodes", "watching")
#' @family episode data
#' @export
seasons_watching <- function(id, season = 1L, extended = c("min", "full")) {
  extended <- match.arg(extended)

  url <- build_trakt_url(
    "shows",
    id,
    "seasons",
    season,
    "watching",
    extended = extended
  )
  response <- trakt_get(url)

  unpack_user(response)
}


#' @describeIn media_watching Who's watching an episode.
#' @export
episodes_watching <- function(id, season = 1L, episode = 1L, extended = c("min", "full")) {
  extended <- match.arg(extended)

  url <- build_trakt_url(
    "shows",
    id,
    "seasons",
    season,
    "episodes",
    episode,
    "watching",
    extended = extended
  )
  response <- trakt_get(url)

  unpack_user(response)
}
