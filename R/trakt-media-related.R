#' Search for related shows or movies
#'
#' Receive a set of media items that are related to a specific show or movie.
#' @inheritParams trakt_api_common_parameters
#' @inheritParams automated_lists
#' @return A [tibble()][tibble::tibble-package].
#' @importFrom tibble as_tibble
#' @importFrom purrr map_df
#' @importFrom dplyr select
#' @importFrom dplyr bind_cols
#' @importFrom dplyr everything
#' @importFrom dplyr mutate
#' @name media_related
#' @examples
#' trakt.shows.related("breaking-bad", limit = 5)
NULL

#' @keywords internal
#' @noRd
trakt.media.related <- function(target, type = c("shows", "movies"),
                                limit = 10L,
                                extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (length(target) > 1) {
    return(map_df(target, ~ trakt.media.related(.x, type, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "related",
    extended = extended,
    limit = limit
  )
  response <- trakt.api.call(url = url)

  # Flattening
  if (type == "shows") {
    response <- unpack_show(response)
  } else if (type == "movies") {
    response <- unpack_movie(response)
  }

  if (extended == "min" & type == "movies") {
    response <- response %>%
      select(-ids) %>%
      bind_cols(fix_ids(response$ids))
  }

  response %>%
    mutate(related_to = target) %>%
    select(related_to, everything()) %>%
    fix_tibble_response()
}

# Aliased/derived ----

#' @rdname media_related
#' @export
trakt.movies.related <- function(target,
                                 limit = 10L,
                                 extended = c("min", "full")) {
  trakt.media.related(target, type = "movies", extended = extended, limit = limit)
}

#' @rdname media_related
#' @export
trakt.shows.related <- function(target,
                                limit = 10L,
                                extended = c("min", "full")) {
  trakt.media.related(target, type = "shows", extended = extended, limit = limit)
}
