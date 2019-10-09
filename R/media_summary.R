#' Get show or movie summary info
#'
#' @details
#' These functions wrap the "single item" API methods:
#' - [/shows/:id](https://trakt.docs.apiary.io/#reference/shows/summary/get-a-single-show)
#' - [/movies/:id](https://trakt.docs.apiary.io/#reference/movies/summary/get-a-movie)
#' @note These functions return the same amount of information as
#'   [search_*][search_query].
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @family summary data
#' @name media_summary
#' @examples
#' # Minimal info by default
#' shows_summary("breaking-bad")
#' movies_summary("inception-2010")
#' \dontrun{
#' # More information
#' shows_summary("breaking-bad", extended = "full")
#'
#' # Info for multiple movies
#' movies_summary(c("inception-2010", "the-dark-knight-2008"), extended = "full")
#' }
NULL

#' @keywords internal
#' @noRd
#' @importFrom purrr map_df
#' @importFrom purrr modify_if
#' @importFrom rlang has_name
#' @importFrom lubridate as_datetime
#' @importFrom dplyr bind_cols
#' @importFrom dplyr select
#' @note Handling of this result is annoying because it's always just a list,
#'   not a data.frame
media_summary <- function(type = c("movies", "shows"), id, extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (length(id) > 1) {
    return(map_df(id, ~ media_summary(type, id = .x, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, id, extended = extended)
  response <- trakt_get(url = url)

  # If extended == "min", we only have IDs to worry about, so early return
  if (extended == "min") {
    response[names(response) != "ids"] %>%
      as_tibble() %>%
      bind_cols(fix_ids(response$ids))
  } else {
    flatten_single_media_object(response, type)
  }
}

# Derived ----

#' @rdname media_summary
#' @export
movies_summary <- function(id, extended = c("min", "full")) {
  media_summary(type = "movies", id = id, extended = extended)
}

#' @rdname media_summary
#' @export
shows_summary <- function(id, extended = c("min", "full")) {
  media_summary(type = "shows", id = id, extended = extended)
}
