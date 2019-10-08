#' Get all comments of a thing
#' @name media_comments
#' @inheritParams trakt_api_common_parameters
#' @inheritParams search_filters
#' @param sort `character(1) ["newest"]`: Comment sort order, one of
#'   "newest", "oldest", "likes" or "replies".
#' @return A [tibble()][tibble::tibble-package].
#'
#' @export
#'
#' @examples
#' \dontrun{
#' movies_comments(193972)
#' shows_comments(46241, sort = "likes")
#' seasons_comments(46241, season = 1, sort = "likes")
#' episodes_comments(46241, season = 1, episode = 2, sort = "likes")
#' }
NULL

#' @describeIn media_comments Get comments for a movie
#' @export
movies_comments <- function(id,
                            sort = c("newest", "oldest", "likes", "replies"),
                            extended = c("min", "full"),
                            limit = 10L) {

  sort <- match.arg(sort)
  extended <- match.arg(extended)
  url <- build_trakt_url("movies", id, "comments", sort, extended = extended)
  response <- trakt_get(url)

  response %>%
    select(-"user") %>%
    bind_cols(
      pluck(response, "user") %>%
        unpack_user()
    ) %>%
    fix_tibble_response()
}

#' @describeIn media_comments Get comments for a movie
#' @export
shows_comments <- function(id,
                            sort = c("newest", "oldest", "likes", "replies"),
                            extended = c("min", "full"),
                            limit = 10L) {

  sort <- match.arg(sort)
  extended <- match.arg(extended)
  url <- build_trakt_url("shows", id, "comments", sort, extended = extended)
  response <- trakt_get(url)

  response %>%
    select(-"user") %>%
    bind_cols(
      pluck(response, "user") %>%
        unpack_user()
    ) %>%
    fix_tibble_response()
}

#' @describeIn media_comments Get comments for a season
#' @export
seasons_comments <- function(id, season = 1L,
                           sort = c("newest", "oldest", "likes", "replies"),
                           extended = c("min", "full"),
                           limit = 10L) {

  sort <- match.arg(sort)
  extended <- match.arg(extended)
  url <- build_trakt_url(
    "shows", id, "seasons", season, "comments", sort, extended = extended
  )
  response <- trakt_get(url)

  response %>%
    select(-"user") %>%
    bind_cols(
      pluck(response, "user") %>%
        unpack_user()
    ) %>%
    fix_tibble_response()
}

#' @describeIn media_comments Get comments for an episode
#' @export
episodes_comments <- function(id, season = 1L, episode = 1L,
                             sort = c("newest", "oldest", "likes", "replies"),
                             extended = c("min", "full"),
                             limit = 10L) {

  sort <- match.arg(sort)
  extended <- match.arg(extended)
  url <- build_trakt_url(
    "shows", id, "seasons", season, "episodes", episode,
    "comments", sort, extended = extended
  )
  response <- trakt_get(url)

  response %>%
    select(-"user") %>%
    bind_cols(
      pluck(response, "user") %>%
        unpack_user()
    ) %>%
    fix_tibble_response()
}
