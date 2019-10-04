#' Get show or movie summary info
#'
#' @details
#' These functions wrap the "single item" API methods:
#' - [/shows/:id](https://trakt.docs.apiary.io/#reference/shows/summary/get-a-single-show)
#' - [/movies/:id](https://trakt.docs.apiary.io/#reference/movies/summary/get-a-movie)
#' @note These functions return the same amount of information as [trakt.search].
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @family summary data
#' @name media_summary
#' @examples
#' # Minimal info by default
#' shows_summary("breaking-bad")
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
#' @note Handling of this result is annoying because it's always just a list, not a data.frame
media_summary <- function(type = c("movies", "shows"), target, extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (length(target) > 1) {
    return(map_df(target, ~ media_summary(type, target = .x, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, extended = extended)
  response <- trakt_get(url = url)

  # All variants have this in common
  response$ids <- fix_ids(response$ids)

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

  # Make sure top-level elements that could be NULL aren't
  # Check e.g. show "1657" for homepage = NULL
  response <- response %>%
    modify_if(is.null, ~ return(NA_character_))

  # Clean up shows and movie objects separately, feels cleaner that way.
  if (type == "shows") {
    response$airs <- response$airs %>%
      modify_if(is.null, ~ return(NA_character_), .else = as.character) %>%
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

  fix_tibble_response(response)
}

# Derived ----

#' @rdname media_summary
#' @export
movies_summary <- function(target, extended = c("min", "full")) {
  media_summary(type = "movies", target = target, extended = extended)
}

#' @rdname media_summary
#' @export
shows_summary <- function(target, extended = c("min", "full")) {
  media_summary(type = "shows", target = target, extended = extended)
}
