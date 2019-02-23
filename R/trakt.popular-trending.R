# Documentation ----

#' Get popular/trending/anticipated movies and shows
#'
#' According to the API docs, popularity is calculated based both ratings
#' and number of ratings. Trending items are those being watched right now, where
#' items with the most users watching are returned first. Anticipation is measured
#' by the number of user-created lists an items is part of while not being released yet.
#'
#' @param limit,page `integer(1) [10]`: Number of items and page for paginated requests.
#' Bot values must be greater than `0` and will be coerced to `integer`.
#' @inheritParams extended_info
#' @inheritParams type_shows_movies
#' @inherit return_tibble return
#' @family Automated lists
#' @name automated_lists
#' @examples
#' \dontrun{
#' # Get popular movies and shows
#' trakt.movies.popular(5)
#' trakt.shows.popular(5)
#'
#' # Get trending movies and shows
#' trakt.movies.trending(5)
#' trakttrending(type = "movies", 5)
#' }
#'
#' # Get anticipated movies
#' trakt.anticipated(type = "movies", 10)
NULL

# Worker function ----
#' @keywords internal
trakt_auto_lists <- function(list_type = c("popular", "trending", "anticipated"),
                            type = c("shows", "movies"),
                             limit = 10, page = 1,
                             extended = c("min", "full")) {
  list_type <- match.arg(list_type)
  type <- match.arg(type)
  extended <- match.arg(extended)
  limit <- as.integer(limit)
  page <- as.integer(page)
  if (limit < 1 | page < 1) {
    stop("Limit and page must be greater than zero")
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, list_type, page = page, limit = limit, extended = extended)
  response <- trakt.api.call(url)

  tibble::remove_rownames(tibble::as_tibble(response))

}

# Aliased/derived ----
#' @rdname automated_lists
#' @export
trakt.popular <- function(type = c("shows", "movies"), limit = 10, page = 1,
                          extended = c("min", "full")) {
  trakt_auto_lists(list_type = "popular", type = type,
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.trending <- function(type = c("shows", "movies"), limit = 10, page = 1,
                           extended = c("min", "full")) {
  trakt_auto_lists(list_type = "trending", type = type,
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.anticipated <- function(type = c("shows", "movies"), limit = 10, page = 1,
                           extended = c("min", "full")) {
  trakt_auto_lists(list_type = "anticipated", type = type,
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.movies.trending <- function(limit = 10, page = 1, extended = c("min", "full")) {
  trakt_auto_lists(list_type = "trending", type = "movies",
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.shows.trending <- function(limit = 10, page = 1, extended = c("min", "full")) {
  trakt_auto_lists(list_type = "trending", type = "shows",
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.movies.popular <- function(limit = 10, page = 1, extended = c("min", "full")) {
  trakt_auto_lists(list_type = "popular", type = "movies",
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.shows.popular <- function(limit = 10, page = 1, extended = c("min", "full")) {
  trakt_auto_lists(list_type = "popular", type = "shows",
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.movies.anticipated <- function(limit = 10, page = 1, extended = c("min", "full")) {
  trakt_auto_lists(list_type = "anticipated", type = "movies",
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.shows.anticipated <- function(limit = 10, page = 1, extended = c("min", "full")) {
  trakt_auto_lists(list_type = "anticipated", type = "shows",
                   limit = limit, page = page, extended = extended)
}
