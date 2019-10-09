#' Get the cast and crew of a show or movie
#'
#' Returns all cast and crew for a show/movie, depending on how much data is
#' available.
#' @details
#' The API methods for these functions are:
#'
#' - [/shows/:id/people](https://trakt.docs.apiary.io/#reference/shows/people/)
#' - [/movies/:id/people](https://trakt.docs.apiary.io/#reference/movies/people/)
#'
#' Note that as of 2019-09-30, there are two representations of `character[s]` and
#' `job[s]`:
#' One is a regular character variable, and the other is a list-column. The former is
#' [deprecated](https://github.com/trakt/api-help/issues/74)  and only included for
#' compatibility reasons.
#'
#' @name media_people
#' @inheritParams trakt_api_common_parameters
#' @param guest_stars `logical(1) ["FALSE"]`: Also include guest stars. This returns
#'   a lot of data, so use with care.
#' @return A `list` of one or more [tibbles][tibble::tibble-package] for `cast`
#'   and `crew`. The latter `tibble` objects are as flat as possible.
#' @family people data
#' @seealso [people_media], for the other direction: People that have credits
#'   in shows/movies.
#' @examples
#' \dontrun{
#' movies_people("deadpool-2016")
#' shows_people("breaking-bad")
#' seasons_people("breaking-bad", season = 1)
#' episodes_people("breaking-bad", season = 1, episode = 1)
#' }
NULL

#' @describeIn media_people Get cast & crew of a movie.
#' @export
movies_people <- function(id, extended = c("min", "full")) {
  extended <- match.arg(extended)

  # Construct URL, make API call
  url <- build_trakt_url("movies", id, "people", extended = extended)
  response <- trakt_get(url = url)

  unpack_people(response)
}

#' @describeIn media_people Get cast & crew of a show.
#' @export
shows_people <- function(id,
                         guest_stars = FALSE,
                         extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (guest_stars) {
    extended <- paste0(extended, ",guest_stars")
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", id, "people", extended = extended)
  response <- trakt_get(url = url)

  unpack_people(response)
}

#' @describeIn media_people Get cast & crew of a season.
#' @export
seasons_people <- function(id,
                           season = 1L,
                           guest_stars = FALSE,
                           extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (guest_stars) {
    extended <- paste0(extended, ",guest_stars")
  }

  # Construct URL, make API call
  url <- build_trakt_url(
    "shows", id, "seasons", season, "people",
    extended = extended
  )
  response <- trakt_get(url = url)

  unpack_people(response)
}

#' @describeIn media_people Get cast & crew of an episode.
#' @export
episodes_people <- function(id,
                            season = 1L, episode = 1L,
                            guest_stars = FALSE,
                            extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (guest_stars) {
    extended <- paste0(extended, ",guest_stars")
  }

  # Construct URL, make API call
  url <- build_trakt_url(
    "shows", id, "seasons", season, "episodes", episode, "people",
    extended = extended
  )
  response <- trakt_get(url = url)

  unpack_people(response)
}
