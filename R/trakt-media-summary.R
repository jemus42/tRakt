#' Get show or movie summary info
#'
#' Note that this function returns the same amount of informations as [trakt.search].
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble][tibble::tibble-package].
#' @family summary data
#' @name media_summary
#' @examples
#' # Minimal info by default
#' trakt.shows.summary("breaking-bad")
#' \dontrun{
#' # More information
#' trakt.shows.summary("breaking-bad", extended = "full")
#'
#' # Info for multiple movies
#' trakt.movies.summary(c("inception-2010", "the-dark-knight-2008"), extended = "full")
#' }
NULL

#' @keywords internal
#' @noRd
#' @importFrom purrr map_df
#' @importFrom purrr flatten_df
#' @importFrom tibble has_name
#' @importFrom lubridate as_datetime
#' @importFrom dplyr bind_cols
#' @importFrom dplyr select
#' @note Handling of this result is annoying because it's always just a list, not a data.frame
trakt.media.summary <- function(type = c("movies", "shows"), target, extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (length(target) > 1) {
    return(map_df(target, ~trakt.media.summary(type, target = .x, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, extended = extended)
  response <- trakt.api.call(url = url)

  # All variants have this in common
  response$ids <- fix_ids(as_tibble(response$ids))

  # If extended == "min", we only have IDs to worry about, so early return
  if (extended == "min") {
    response <- response[names(response) != "ids"] %>%
      as_tibble() %>%
      bind_cols(response$ids)

    return(response)
  }

  # extended == "full" objects have this in common
  response$available_translations <- list(response$available_translations)
  response$genres <- list(response$genres)

  # Clean up shows and movie objects separately, feels cleaner that way.
  if (type == "shows") {

    response$airs <- response$airs %>%
      as_tibble() %>%
      set_names(., paste0("airs_", names(.)))

    response <- response[!(names(response) %in% c("ids", "airs"))] %>%
      as_tibble() %>%
      bind_cols(response$airs, response$id)

  } else if (type == "movies") {

    response <- response[names(response) != "ids"] %>%
      as_tibble() %>%
      bind_cols(response$id)
  }

  as_tibble(response)
}

# Derived ----

#' @rdname media_summary
#' @export
trakt.movies.summary <- function(target, extended = c("min", "full")) {
  trakt.media.summary(type = "movies", target = target, extended = extended)
}

#' @rdname media_summary
#' @export
trakt.shows.summary <- function(target, extended = c("min", "full")) {
  trakt.media.summary(type = "shows", target = target, extended = extended)
}
