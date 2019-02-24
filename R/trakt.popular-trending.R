# Documentation ----

#' Get popular/trending/anticipated movies and shows
#'
#' According to the API docs, popularity is calculated based both ratings
#' and number of ratings. Trending items are those being watched right now, where
#' items with the most users watching are returned first. Anticipation is measured
#' by the number of user-created lists an items is part of while not being released yet.
#'
#' @param limit,page `integer(1) [10L] [1L]`: Number of items and page for paginated requests.
#' Bot values must be greater than `0` and will be coerced to `integer`.
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble][tibble::tibble-package].
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
                            limit = 10L, page = 1L,
                            extended = c("min", "full"),
                            period = NULL) {
  list_type <- match.arg(list_type)
  type <- match.arg(type)
  extended <- match.arg(extended)
  limit <- as.integer(limit)
  page <- as.integer(page)
  if (limit < 1 | page < 1) {
    stop("Limit and page must be greater than zero")
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, list_type, period, page = page,
                         limit = limit, extended = extended)
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
trakt.played <- function(type = c("shows", "movies"),
                         limit = 10, page = 1, extended = c("min", "full"),
                         period = c("weekly" , "monthly" , "yearly" , "all")) {
  period <- match.arg(period)

  trakt_auto_lists(list_type = "played", type = "shows",
                   limit = limit, page = page,
                   extended = extended, period = period)
}

# media/list ----

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

# media/list with period ----

#' @rdname automated_lists
#' @export
trakt.shows.played <- function(limit = 10, page = 1, extended = c("min", "full"),
                               period = c("weekly" , "monthly" , "yearly" , "all")) {
  period <- match.arg(period)

  trakt_auto_lists(list_type = "played", type = "shows", period = period,
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.movies.played <- function(limit = 10, page = 1, extended = c("min", "full"),
                               period = c("weekly" , "monthly" , "yearly" , "all")) {
  period <- match.arg(period)

  trakt_auto_lists(list_type = "played", type = "movies", period = period,
                   limit = limit, page = page, extended = extended)
}
