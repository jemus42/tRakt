#' Search for related shows or movies
#'
#' Receive a set of media items that are related to a specific show or movie.
#' @inheritParams trakt_api_common_parameters
#' @inheritParams automated_lists
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @examples
#' \dontrun{
#' trakt.related("breaking-bad", "shows", limit = 5)
#' }
trakt.related <- function(target, type = c("shows", "movies"),
                          limit = 10L, page = 1L,
                          extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (length(target) > 1) {
    return(purrr::map_df(target, ~trakt.related(.x, type, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "related", extended = extended,
                         limit = limit, page = page)
  response <- trakt.api.call(url = url)

  # Flattening
  response <- cbind(response[names(response) != "ids"], fix_ids(response$ids))
  response$related_to <- target

  tibble::as_tibble(response)
}

# Aliased/derived ----

#' @rdname trakt.related
#' @export
trakt.movies.related <- function(target,
                                 limit = 10L, page = 1L,
                                 extended = c("min", "full")) {
  trakt.related(target, type = "movies", extended = extended)
}

#' @rdname trakt.related
#' @export
trakt.shows.related <- function(target,
                                limit = 10L, page = 1L,
                                extended = c("min", "full")) {
  trakt.related(target, type = "shows", extended = extended)
}
