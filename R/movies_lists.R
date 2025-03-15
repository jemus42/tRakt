#' Get lists containing a movie, show, season, episode or person
#'
#' @name media_lists
#' @inheritParams trakt_api_common_parameters
#' @param type `character(1) ["all"]`: The type of list, one of "all", "personal",
#'   "official" or "watchlists".
#' @param sort `character(1) ["popular"]`: Sort lists by one of "popular", "likes",
#'   "comments", "items", "added" or "updated".
#' @inherit trakt_api_common_parameters return
NULL

#' @export
#' @eval apiurl("movies", "lists")
#' @family list methods
#' @family movie data
#' @describeIn media_lists Lists containing a movie.
#' @examples
#' \dontrun{
#' movies_lists("190430", type = "personal", limit = 5)
#' }
movies_lists <- function(
  id,
  type = c("all", "personal", "official", "watchlists"),
  sort = c(
    "popular",
    "likes",
    "comments",
    "items",
    "added",
    "updated"
  ),
  limit = 10L,
  extended = c("min", "full")
) {
  type <- match.arg(type)
  sort <- match.arg(sort)
  extended <- match.arg(extended)

  url <- build_trakt_url("movies", id, "lists", type, sort, limit = limit, extended = extended)
  response <- trakt_get(url)

  unpack_lists(response)
}

#' @export
#' @eval apiurl("shows", "lists")
#' @family list methods
#' @family show data
#' @describeIn media_lists Lists containing a show.
#' @examples
#' \dontrun{
#' shows_lists("46241")
#' }
shows_lists <- function(
  id,
  type = c("all", "personal", "official", "watchlists"),
  sort = c(
    "popular",
    "likes",
    "comments",
    "items",
    "added",
    "updated"
  ),
  limit = 10L,
  extended = c("min", "full")
) {
  type <- match.arg(type)
  sort <- match.arg(sort)
  extended <- match.arg(extended)

  url <- build_trakt_url("shows", id, "lists", type, sort, limit = limit, extended = extended)
  response <- trakt_get(url)

  unpack_lists(response)
}

#' @export
#' @eval apiurl("seasons", "lists")
#' @family list methods
#' @family season data
#' @describeIn media_lists Lists containing a season.
#' @examples
#' \dontrun{
#' seasons_lists("46241", season = 1)
#' }
seasons_lists <- function(
  id,
  season,
  type = c("all", "personal", "official", "watchlists"),
  sort = c(
    "popular",
    "likes",
    "comments",
    "items",
    "added",
    "updated"
  ),
  limit = 10L,
  extended = c("min", "full")
) {
  type <- match.arg(type)
  sort <- match.arg(sort)
  extended <- match.arg(extended)

  url <- build_trakt_url("shows", id, "seasons", season, "lists", type, sort, limit = limit, extended = extended)
  response <- trakt_get(url)

  unpack_lists(response)
}

#' @export
#' @eval apiurl("episodes", "lists")
#' @family list methods
#' @family episode data
#' @describeIn media_lists Lists containing an episode.
#' @examples
#' \dontrun{
#' episodes_lists("46241", season = 1, episode = 1)
#' }
episodes_lists <- function(
  id,
  season,
  episode,
  type = c("all", "personal", "official", "watchlists"),
  sort = c(
    "popular",
    "likes",
    "comments",
    "items",
    "added",
    "updated"
  ),
  limit = 10L,
  extended = c("min", "full")
) {
  type <- match.arg(type)
  sort <- match.arg(sort)
  extended <- match.arg(extended)

  url <- build_trakt_url(
    "shows",
    id,
    "seasons",
    season,
    "episodes",
    episode,
    "lists",
    type,
    sort,
    limit = limit,
    extended = extended
  )
  response <- trakt_get(url)

  unpack_lists(response)
}

#' @export
#' @family list methods
#' @family people data
#' @describeIn media_lists Lists containing a person.
#' @examples
#' \dontrun{
#' people_lists("david-tennant")
#'
#' people_lists("emilia-clarke", sort = "items")
#' }
people_lists <- function(
  id,
  type = c("all", "personal", "official", "watchlists"),
  sort = c(
    "popular",
    "likes",
    "comments",
    "items",
    "added",
    "updated"
  ),
  limit = 10L,
  extended = c("min", "full")
) {
  type <- match.arg(type)
  sort <- match.arg(sort)
  extended <- match.arg(extended)

  url <- build_trakt_url("people", id, "lists", type, sort, limit = limit, extended = extended)
  response <- trakt_get(url)

  unpack_lists(response)
}
