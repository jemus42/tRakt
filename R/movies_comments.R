#' Get all comments of a thing
#' @name media_comments
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @family comment methods
#' @examples
#' \dontrun{
#' movies_comments(193972)
#' shows_comments(46241, sort = "likes")
#' seasons_comments(46241, season = 1, sort = "likes")
#' episodes_comments(46241, season = 1, episode = 2, sort = "likes")
#' }
NULL

#' @describeIn media_comments Get comments for a movie
#' @eval apiurl("movies", "comments")
#' @family movie data
#' @export
movies_comments <- function(id,
                            sort = c("newest", "oldest", "likes", "replies"),
                            extended = c("min", "full"),
                            limit = 10L) {
  sort <- match.arg(sort)
  extended <- match.arg(extended)
  url <- build_trakt_url("movies", id, "comments", sort, extended = extended)
  response <- trakt_get(url)
  unpack_comments(response)
}

#' @describeIn media_comments Get comments for a movie
#' @eval apiurl("shows", "comments")
#' @family show data
#' @export
shows_comments <- function(id,
                           sort = c("newest", "oldest", "likes", "replies"),
                           extended = c("min", "full"),
                           limit = 10L) {
  sort <- match.arg(sort)
  extended <- match.arg(extended)
  url <- build_trakt_url("shows", id, "comments", sort, extended = extended)
  response <- trakt_get(url)
  unpack_comments(response)
}

#' @describeIn media_comments Get comments for a season
#' @eval apiurl("seasons", "comments")
#' @family season data
#' @export
seasons_comments <- function(id, season = 1L,
                             sort = c("newest", "oldest", "likes", "replies"),
                             extended = c("min", "full"),
                             limit = 10L) {
  sort <- match.arg(sort)
  extended <- match.arg(extended)
  url <- build_trakt_url(
    "shows", id, "seasons", season, "comments", sort,
    extended = extended
  )
  response <- trakt_get(url)
  unpack_comments(response)
}

#' @describeIn media_comments Get comments for an episode
#' @eval apiurl("episodes", "comments")
#' @family episode data
#' @export
episodes_comments <- function(id, season = 1L, episode = 1L,
                              sort = c("newest", "oldest", "likes", "replies"),
                              extended = c("min", "full"),
                              limit = 10L) {
  sort <- match.arg(sort)
  extended <- match.arg(extended)
  url <- build_trakt_url(
    "shows", id, "seasons", season, "episodes", episode,
    "comments", sort,
    extended = extended
  )
  response <- trakt_get(url)
  unpack_comments(response)
}
