#' Get popular movies and shows
#'
#' `trakt.[movies|shows].popular` returns a list of the most popular movies on trakt.tv.
#' According to the API docs, opularity is calculated based both ratings and number of ratings.
#' @param limit Number of movies/shows to return. Is coerced to `integer` and must be
#' greater than 0.
#' @param page Page to return (default is `1`)
#' for \href{http://docs.trakt.apiary.io/#introduction/pagination}{pagination}.
#' @inheritParams  extended_info
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @aliases trakt.popular
#' @family Automated lists
#' @examples
#' \dontrun{
#' trakt.movies.popular(5)
#' trakt.shows.popular(5)
#' }
trakt.movies.popular <- function(limit = 10, page = 1, extended = "min") {
  trakt.popular(type = "movies", limit = limit, page = page, extended = extended)
}

#' @describeIn trakt.movies.popular Get popular shows
trakt.shows.popular <- function(limit = 10, page = 1, extended = "min") {
  trakt.popular(type = "shows", limit = limit, page = page, extended = extended)
}

#' @keywords internal
trakt.popular <- function(type, limit = 10, page = 1, extended = "min") {
  limit <- as.integer(limit)
  page <- as.integer(page)
  if (limit < 1 | page < 1) {
    stop("Limit and page must be greater than zero")
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, "popular", page = page, limit = limit, extended = extended)
  response <- trakt.api.call(url)

  # Spreading out ids to get a flat data.frame
  response <- cbind(response[names(response) != "ids"], response$ids)

  tibble::remove_rownames(tibble::as_tibble(response))
}
