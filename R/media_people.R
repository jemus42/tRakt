
#' Get the cast and crew of a show or movie
#'
#' Returns all cast and crew for a show/movie, depending on how much data is
#' available.
#' @details
#' The API methods for these functions are:
#'
#' - [/shows/:id/people](https://trakt.docs.apiary.io/#reference/shows/people/get-all-people-for-a-show)
#' - [/movies/:id/people](https://trakt.docs.apiary.io/#reference/movies/people/get-all-people-for-a-movie)
#'
#' Note that as of 2019-09-30, there are two representations of `character[s]` and `job[s]`:
#' One is a regular character variable, and the other is a list-column. The former is
#' [deprecated and only included for compatibility reasons](https://github.com/trakt/api-help/issues/74).
#'
#' @name media_people
#' @inheritParams trakt_api_common_parameters
#' @return A `list` of one or more [tibbles][tibble::tibble-package] for `cast`
#' and `crew`. The latter `tibble` objects are as flat as possible.
#' @family people data
#' @seealso [people_media], for the other direction: People that have credits in shows/movies.
#' @examples
#' \dontrun{
#' shows_people("breaking-bad")
#' }
NULL

#' Retrieve cast & crew for shows and movies
#' @keywords internal
#' @noRd
#' @importFrom purrr is_empty
#' @importFrom purrr map_df
#' @importFrom dplyr bind_cols
#' @importFrom dplyr select
#' @importFrom tibble as_tibble
#' @importFrom rlang has_name
media_people <- function(type = c("shows", "movies"), id,
                               extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  # Construct URL, make API call
  url <- build_trakt_url(type, id, "people", extended = extended)
  response <- trakt_get(url = url)

  if (is_empty(response)) {
    return(tibble())
  }

  # Flatten the data.frame
  if (has_name(response, "cast") & !is_empty(response$cast)) {
    response$cast$person[["images"]] <- NULL

    response$cast$person <- response$cast$person %>%
      select(-ids) %>%
      cbind(fix_ids(response$cast$person$ids)) %>%
      fix_datetime() %>%
      as_tibble()

    response$cast <- response$cast %>%
      select(-person) %>%
      cbind(response$cast$person) %>%
      as_tibble()
  }

  if (has_name(response, "crew") & !is_empty(response$crew)) {
    response$crew <- map_df(trakt_people_crew_sections, function(section) {
      response$crew[[section]]$person[["images"]] <- NULL

      if (!has_name(response$crew, section) | is_empty(response$crew[[section]])) {
        return(tibble())
      }

      response$crew[[section]]$person <- response$crew[[section]]$person %>%
        select(-ids) %>%
        cbind(fix_ids(response$crew[[section]]$person$ids))

      response$crew[[section]] <- response$crew[[section]] %>%
        select(-person) %>%
        cbind(response$crew[[section]]$person) %>%
        mutate(crew_type = section) %>%
        as_tibble() %>%
        fix_datetime()
    })
  }

  response
}

#' @rdname media_people
#' @export
shows_people <- function(id, extended = c("min", "full")) {
  media_people(type = "shows", id = id, extended = extended)
}

#' @rdname media_people
#' @export
movies_people <- function(id, extended = c("min", "full")) {
  media_people(type = "movies", id = id, extended = extended)
}
