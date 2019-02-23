#' Get popular and trending movies and shows
#'
#' According to the API docs, popularity is calculated based both ratings
#' and number of ratings. Trending items are those being watched right now, where
#' items with the most users watching are returned first.
#'
#' @param limit Number of movies/shows to return. Is coerced to `integer` and must be
#' greater than 0.
#' @param page Page to return (default is `1`)
#' for \href{http://docs.trakt.apiary.io/#introduction/pagination}{pagination}.
#' @inheritParams extended_info
#' @inheritParams type_show_movie
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @aliases trakt.trending
#' @family Automated lists
#' @examples
#' \dontrun{
#' # Get popular movies and shows
#' trakt.movies.popular(5)
#' trakt.shows.popular(5)
#'
#' # Get trending movies and shows
#' trakt.movies.trending(5)
#' trakt.shows.trending(5)
#' }
trakt.popular <- function(type, limit = 10, page = 1, extended = c("min", "full")) {
  extended <- match.arg(extended)
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

#' @rdname trakt.popular
#' @export
trakt.trending <- function(type, limit = 10, page = 1, extended = c("min", "full")) {
  extended <- match.arg(extended)
  limit <- as.integer(limit)
  page <- as.integer(page)
  if (limit < 1 | page < 1) {
    stop("Limit and page must be greater than zero")
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, "trending", page = page, limit = limit, extended = extended)
  response <- trakt.api.call(url)

  if (type == "shows") {
    response <- cbind(response[names(response) != "show"], response$show)
    response$show <- cbind(response$show[names(response$show) != "ids"], response$show$ids)
  } else if (type == "movies") {
    response$movie <- cbind(response$movie[names(response$movie) != "ids"], response$movie$ids)
    response <- cbind(response[names(response) != "movie"], response$movie)
  }
  response <- convert_datetime(response)

  tibble::remove_rownames(tibble::as_tibble(response))
}

#' @rdname trakt.popular
#' @export
trakt.movies.trending <- function(limit = 10, page = 1, extended = c("min", "full")) {
  trakt.trending("movies", limit = limit, page = page, extended = extended)
}

#' @rdname trakt.popular
#' @export
trakt.shows.trending <- function(limit = 10, page = 1, extended = c("min", "full")) {
  trakt.trending("shows", limit = limit, page = page, extended = extended)
}

#' @rdname trakt.popular
#' @export
trakt.movies.popular <- function(limit = 10, page = 1, extended = c("min", "full")) {
  trakt.popular(type = "movies", limit = limit, page = page, extended = extended)
}

#' @rdname trakt.popular
#' @export
trakt.shows.popular <- function(limit = 10, page = 1, extended = c("min", "full")) {
  trakt.popular(type = "shows", limit = limit, page = page, extended = extended)
}
