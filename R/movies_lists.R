#' Get lists containing a movie, show, season, episode or person
#'
#' @name media_lists
#' @inheritParams trakt_api_common_parameters
#' @param type `character(1) ["all"]`: The type of list, one of "all", "personal",
#'   "official" or "watchlists".
#' @param sort `character(1) ["popular"]`: Sort lists by one of "popular", "likes",
#'   "comments", "items", "added" or "updated".
#' @return A [tibble()][tibble::tibble-package].
#' @family list methods
#' @examples
#' \dontrun{
#' movies_lists("190430", type = "personal", limit = 5)
#' shows_lists("46241")
#' seasons_lists("46241", season = 1)
#' episodes_lists("46241", season = 1, episode = 1)
#' people_lists("david-tennant")
#' }
NULL

#' @export
#' @describeIn media_lists Lists containing a movie.
movies_lists <- function(id,
                         type = c("all", "personal", "official", "watchlists"),
                         sort = c(
                           "popular", "likes", "comments",
                           "items", "added", "updated"
                         ),
                         limit = 10L,
                         extended = c("min", "full")) {
  type <- match.arg(type)
  sort <- match.arg(sort)
  extended <- match.arg(extended)

  url <- build_trakt_url("movies", id, "lists", type, sort,
    limit = limit, extended = extended
  )
  response <- trakt_get(url)

  unpack_lists(response)
}

#' @export
#' @describeIn media_lists Lists containing a show.
shows_lists <- function(id,
                        type = c("all", "personal", "official", "watchlists"),
                        sort = c(
                          "popular", "likes", "comments",
                          "items", "added", "updated"
                        ),
                        limit = 10L,
                        extended = c("min", "full")) {
  type <- match.arg(type)
  sort <- match.arg(sort)
  extended <- match.arg(extended)

  url <- build_trakt_url("shows", id, "lists", type, sort,
    limit = limit, extended = extended
  )
  response <- trakt_get(url)

  unpack_lists(response)
}

#' @export
#' @describeIn media_lists Lists containing a season.
seasons_lists <- function(id, season,
                          type = c("all", "personal", "official", "watchlists"),
                          sort = c(
                            "popular", "likes", "comments",
                            "items", "added", "updated"
                          ),
                          limit = 10L,
                          extended = c("min", "full")) {
  type <- match.arg(type)
  sort <- match.arg(sort)
  extended <- match.arg(extended)

  url <- build_trakt_url("shows", id, "seasons", season, "lists", type, sort,
    limit = limit, extended = extended
  )
  response <- trakt_get(url)

  unpack_lists(response)
}

#' @export
#' @describeIn media_lists Lists containing an episode.
episodes_lists <- function(id, season, episode,
                           type = c("all", "personal", "official", "watchlists"),
                           sort = c(
                             "popular", "likes", "comments",
                             "items", "added", "updated"
                           ),
                           limit = 10L,
                           extended = c("min", "full")) {
  type <- match.arg(type)
  sort <- match.arg(sort)
  extended <- match.arg(extended)

  url <- build_trakt_url("shows", id, "seasons", season, "episodes", episode,
    "lists", type, sort,
    limit = limit, extended = extended
  )
  response <- trakt_get(url)

  unpack_lists(response)
}

#' @export
#' @describeIn media_lists Lists containing a person.
people_lists <- function(id,
                         type = c("all", "personal", "official", "watchlists"),
                         sort = c(
                           "popular", "likes", "comments",
                           "items", "added", "updated"
                         ),
                         limit = 10L,
                         extended = c("min", "full")) {
  type <- match.arg(type)
  sort <- match.arg(sort)
  extended <- match.arg(extended)

  url <- build_trakt_url("people", id, "lists", type, sort,
    limit = limit, extended = extended
  )
  response <- trakt_get(url)

  # limit param seems to be ignoren in this method, so manual workaround
  response %>%
    unpack_lists() %>%
    head(limit)
}
