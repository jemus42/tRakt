# Documentation ----

#' See which movies / shows are popular
#'
#' According to the API docs, popularity is calculated based both ratings
#' and number of ratings. Trending items are those being watched right now, where
#' items with the most users watching are returned first. Anticipation is measured
#' by the number of user-created lists an items is part of while not being released yet.
#'
#' @name automated_lists
#' @inheritParams trakt_api_common_parameters
#' @param start_date `character(1)`: A date in the past from which on to count updates.
#' If no date is supplied, the default is to use the date 7 days in the past relative
#' to the current date. Value must either be standard `YYYY-MM-DD` format or an object
#' of class [Date][base::Dates], which will then be coerced via [as.character()][base::as.character].
#' @return A [tibble()][tibble::tibble-package].
#'
#' @details
#'
#' These functions access the automatically updated lists provided by trakt.tv.
#' Each function comes in two flavors: Shows or movies. The following descriptions
#' are adapted directly from the [API reference](https://trakt.docs.apiary.io/#reference/movies/popular/get-popular-movies).
#'
#' - **Popular**: Popularity is calculated using the rating percentage and the number of ratings.
#' - **Trending**: Returns all movies/shows being watched right now.
#' Movies/shows with the most users are returned first.
#' - **Played**: Returns the most played (a single user can watch multiple times)
#' movies/shows in the specified time `period`.
#' - **Watched**: Returns the most watched (unique users) movies/shows in the specified
#' time `period`.
#' - **Collected**: Returns the most collected (unique users) movies/shows in the
#' specified time `period`.
#' - **Anticipated**: Returns the most anticipated movies/shows based on the number of
#' lists a movie/show appears on.
#' - **Updates**: Returns all movies/shows updated since the specified UTC `start_date`.
#' In this case, the upper bound for `limit` is 100.
#'
#' The functions for **Played**, **Watched**, **Collected** and **Played** each return the
#' same additional variables besides the media information: `watcher_count`,
#' `play_count`, `collected_count`, `collector_count`.
#'
#' @examples
#' \dontrun{
#' # Get popular shows with only ids
#' trakt.popular(type = "shows")
#'
#' # Get trending movies with extended information
#' trakt.trending(type = "movies", 5, extended = "full")
#'
#' # Get top 5 anticipated movies
#' trakt.anticipated(type = "movies", 5)
#' }
NULL

# Worker function ----
#' @keywords internal
#' @noRd
trakt_auto_lists <- function(list_type = c(
                               "popular", "trending", "anticipated",
                               "played", "watched", "collected", "updates"
                             ),
                             type = c("shows", "movies"),
                             limit = 10L,
                             extended = c("min", "full"),
                             period = NULL, start_date = NULL) {
  list_type <- match.arg(list_type)
  type <- match.arg(type)
  extended <- match.arg(extended)
  limit <- as.integer(limit)

  if (limit < 1) {
    stop("'limit' must be greater than zero, supplied <", limit, ">")
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, list_type, start_date, period,
    limit = limit, extended = extended
  )
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

  if (tibble::has_name(response, "movie")) {
    response <- dplyr::bind_cols(
      response %>% dplyr::select(-movie),
      response$movie %>% dplyr::select(-ids),
      response$movie$ids
    )
  }

  # Unpack ids – required for extended = "min"
  # This is done last because at this point we can be
  # reasonably certain there's no other problematic list/df columns
  if (tibble::has_name(response, "ids")) {
    response <- dplyr::bind_cols(
      response %>% dplyr::select(-ids),
      response$ids
    )
  }

  fix_datetime(response)
}

# list type ----
#' @rdname automated_lists
#' @export
trakt.popular <- function(type = c("shows", "movies"), limit = 10,
                          extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  trakt_auto_lists(
    list_type = "popular", type = type,
    limit = limit, extended = extended
  )
}

#' @rdname automated_lists
#' @export
trakt.trending <- function(type = c("shows", "movies"), limit = 10,
                           extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  trakt_auto_lists(
    list_type = "trending", type = type,
    limit = limit, extended = extended
  )
}

#' @rdname automated_lists
#' @export
trakt.anticipated <- function(type = c("shows", "movies"), limit = 10,
                              extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  trakt_auto_lists(
    list_type = "anticipated", type = type,
    limit = limit, extended = extended
  )
}

#' @rdname automated_lists
#' @export
trakt.played <- function(type = c("shows", "movies"),
                         limit = 10, extended = c("min", "full"),
                         period = c("weekly", "monthly", "yearly", "all")) {
  type <- match.arg(type)
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(
    list_type = "played", type = type,
    limit = limit,
    extended = extended, period = period
  )
}

#' @rdname automated_lists
#' @export
trakt.watched <- function(type = c("shows", "movies"),
                          limit = 10, extended = c("min", "full"),
                          period = c("weekly", "monthly", "yearly", "all")) {
  type <- match.arg(type)
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(
    list_type = "watched", type = type,
    limit = limit,
    extended = extended, period = period
  )
}

#' @rdname automated_lists
#' @export
trakt.collected <- function(type = c("shows", "movies"),
                            limit = 10, extended = c("min", "full"),
                            period = c("weekly", "monthly", "yearly", "all")) {
  type <- match.arg(type)
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(
    list_type = "collected", type = type,
    limit = limit,
    extended = extended, period = period
  )
}

#' @rdname automated_lists
#' @export
trakt.updates <- function(type = c("shows", "movies"),
                          limit = 10, extended = c("min", "full"),
                          start_date = Sys.Date() - 7) {
  type <- match.arg(type)
  extended <- match.arg(extended)
  start_date <- as.character(as.Date(start_date))

  if (is.null(start_date)) {
    start_date <- Sys.Date() - 28
  }

  trakt_auto_lists(
    list_type = "updates", type = type,
    limit = limit,
    extended = extended, start_date = start_date
  )
}
