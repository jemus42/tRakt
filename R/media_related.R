#' Search for related shows or movies
#'
#' Receive a set of media items that are related to a specific show or movie.
#' @details
#' The API methods wrapped are:
#'
#' - [/shows/:id/related](https://trakt.docs.apiary.io/#reference/shows/related/get-related-shows)
#' - [/movies/:id/related](https://trakt.docs.apiary.io/#reference/movies/related/get-related-movies)
#'
#' @inheritParams trakt_api_common_parameters
#' @inheritParams dynamic_lists
#' @return A [tibble()][tibble::tibble-package].
#' @importFrom tibble as_tibble
#' @importFrom purrr map_df
#' @importFrom dplyr select
#' @importFrom dplyr bind_cols
#' @importFrom dplyr everything
#' @importFrom dplyr mutate
#' @name media_related
#' @examples
#' shows_related("breaking-bad", limit = 5)
NULL

#' @keywords internal
#' @noRd
media_related <- function(id, type = c("shows", "movies"),
                          limit = 10L,
                          extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (length(id) > 1) {
    return(map_df(id, ~ media_related(.x, type, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, id, "related",
    extended = extended,
    limit = limit
  )
  response <- trakt_get(url = url)

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
    mutate(related_to = id) %>%
    select(related_to, everything()) %>%
    fix_tibble_response()
}

# Aliased/derived ----

#' @rdname media_related
#' @export
movies_related <- function(id,
                           limit = 10L,
                           extended = c("min", "full")) {
  media_related(id, type = "movies", extended = extended, limit = limit)
}

#' @rdname media_related
#' @export
shows_related <- function(id,
                          limit = 10L,
                          extended = c("min", "full")) {
  media_related(id, type = "shows", extended = extended, limit = limit)
}
