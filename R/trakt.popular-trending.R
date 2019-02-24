# Documentation ----

#' See which movies / shows are popular
#'
#' According to the API docs, popularity is calculated based both ratings
#' and number of ratings. Trending items are those being watched right now, where
#' items with the most users watching are returned first. Anticipation is measured
#' by the number of user-created lists an items is part of while not being released yet.
#'
#' @param limit,page `integer(1) [10L], [1L]`: Number of items and page for paginated requests.
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
#' trakt.trending(type = "movies", 5, extended = "full")
#' }
#'
#' # Get anticipated movies
#' trakt.anticipated(type = "movies", 10)
NULL

# Worker function ----
#' @keywords internal
trakt_auto_lists <- function(list_type = c("popular", "trending", "anticipated", "played"),
                            type = c("shows", "movies"),
                            limit = 10L, page = 1L,
                            extended = c("min", "full"),
                            period = NULL) {
  list_type <- match.arg(list_type)
  type      <- match.arg(type)
  extended  <- match.arg(extended)
  limit     <- as.integer(limit)
  page      <- as.integer(page)

  if (limit < 1 | page < 1) {
    stop("Limit and page must be greater than zero")
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, list_type, period, page = page,
                         limit = limit, extended = extended)
  response <- trakt.api.call(url)
  response <- tibble::as_tibble(response)

  # For this case we *only* get show objects, so we handle that first
  if (type == "shows" & list_type == "popular") {
    response <- unpack_show(response)
  }

  # Unnest show or movie object present only in some methods
  if (tibble::has_name(response, "show")) {
    response <- dplyr::bind_cols(
      response %>% dplyr::select(-show),
      unpack_show(response$show)
    )
  }

  if (has_name(response, "movie")) {
    response <- bind_cols(
      response %>% select(-movie),
      response$movie %>% select(-ids),
      response$movie$ids
    )
  }

  # Unpack ids – required for extended = "min"
  # This is done last because at this point we can be
  # reasonably certain there's no other problematic list/df columns
  if (has_name(response, "ids")) {
    response <- dplyr::bind_cols(
      response %>% dplyr::select(-ids),
      response$ids
    )
  }

  response
}

# list type ----
#' @rdname automated_lists
#' @export
trakt.popular <- function(type = c("shows", "movies"), limit = 10, page = 1,
                          extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  trakt_auto_lists(list_type = "popular", type = type,
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.trending <- function(type = c("shows", "movies"), limit = 10, page = 1,
                           extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  trakt_auto_lists(list_type = "trending", type = type,
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.anticipated <- function(type = c("shows", "movies"), limit = 10, page = 1,
                           extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  trakt_auto_lists(list_type = "anticipated", type = type,
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.played <- function(type = c("shows", "movies"),
                         limit = 10, page = 1, extended = c("min", "full"),
                         period = c("weekly" , "monthly" , "yearly" , "all")) {
  type <- match.arg(type)
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(list_type = "played", type = type,
                   limit = limit, page = page,
                   extended = extended, period = period)
}

#' @rdname automated_lists
#' @export
trakt.watched <- function(type = c("shows", "movies"),
                         limit = 10, page = 1, extended = c("min", "full"),
                         period = c("weekly" , "monthly" , "yearly" , "all")) {
  type <- match.arg(type)
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(list_type = "watched", type = type,
                   limit = limit, page = page,
                   extended = extended, period = period)
}

# media/list ----

#' @rdname automated_lists
#' @export
trakt.movies.trending <- function(limit = 10, page = 1, extended = c("min", "full")) {
  extended <- match.arg(extended)

  trakt_auto_lists(list_type = "trending", type = "movies",
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.shows.trending <- function(limit = 10, page = 1, extended = c("min", "full")) {
  extended <- match.arg(extended)

  trakt_auto_lists(list_type = "trending", type = "shows",
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.movies.popular <- function(limit = 10, page = 1, extended = c("min", "full")) {
  extended <- match.arg(extended)

  trakt_auto_lists(list_type = "popular", type = "movies",
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.shows.popular <- function(limit = 10, page = 1, extended = c("min", "full")) {
  extended <- match.arg(extended)

  trakt_auto_lists(list_type = "popular", type = "shows",
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.movies.anticipated <- function(limit = 10, page = 1, extended = c("min", "full")) {
  extended <- match.arg(extended)

  trakt_auto_lists(list_type = "anticipated", type = "movies",
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.shows.anticipated <- function(limit = 10, page = 1, extended = c("min", "full")) {
  extended <- match.arg(extended)

  trakt_auto_lists(list_type = "anticipated", type = "shows",
                   limit = limit, page = page, extended = extended)
}

# media/list with period ----

#' @rdname automated_lists
#' @export
trakt.shows.played <- function(limit = 10, page = 1, extended = c("min", "full"),
                               period = c("weekly" , "monthly" , "yearly" , "all")) {
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(list_type = "played", type = "shows", period = period,
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.movies.played <- function(limit = 10, page = 1, extended = c("min", "full"),
                               period = c("weekly" , "monthly" , "yearly" , "all")) {
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(list_type = "played", type = "movies", period = period,
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.shows.watched <- function(limit = 10, page = 1, extended = c("min", "full"),
                               period = c("weekly" , "monthly" , "yearly" , "all")) {
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(list_type = "watched", type = "shows", period = period,
                   limit = limit, page = page, extended = extended)
}

#' @rdname automated_lists
#' @export
trakt.movies.watched <- function(limit = 10, page = 1, extended = c("min", "full"),
                                period = c("weekly" , "monthly" , "yearly" , "all")) {
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(list_type = "watched", type = "movies", period = period,
                   limit = limit, page = page, extended = extended)
}
