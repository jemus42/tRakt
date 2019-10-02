#' Get a single person's details
#'
#' Get a single person's details, like their various IDs. If `extended` is
#' `"full"`, there will also be biographical data if available, e.g. their
#' birthday.
#' @details
#' This function wraps the API method
#' [/people/:id](https://trakt.docs.apiary.io/#reference/people/summary/get-a-single-person).
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @importFrom purrr modify_if
#' @importFrom purrr map_df
#' @family people data
#' @examples
#' # A single person's extended information
#' trakt.people.summary("bryan-cranston", "full")
#'
#' # Multiple people
#' trakt.people.summary(c("kit-harington", "emilia-clarke"))
trakt.people.summary <- function(target, extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (length(target) > 1) {
    return(map_df(target, ~ trakt.people.summary(.x, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("people", target, extended = extended)
  response <- trakt_get(url = url)

  # Substitute NULLs with explicit NAs and flatten IDs
  response$ids <- as_tibble(fix_ids(response$ids))
  response <- modify_if(response, is.null, ~ return(NA_character_))
  response <- fix_datetime(response)
  response[names(response) != "ids"] %>%
    as_tibble() %>%
    bind_cols(response$ids)
}

# People that have media ----

#' Get a single person's movie or show credits
#'
#' Returns all movies or shows where this person is in the cast or crew.
#' @details
#' The API methods wrapped are
#' - [`/people/:id/movies`](https://trakt.docs.apiary.io/#reference/people/movies/get-movie-credits)
#' - [`/people/:id/shows`](https://trakt.docs.apiary.io/#reference/people/shows/get-show-credits)
#'
#' Note that as of 2019-09-30, there are two representations of `character[s]` and `job[s]`:
#' One is a regular character variable, and the other is a list-column. The former is
#' [deprecated and only included for compatibility reasons](https://github.com/trakt/api-help/issues/74).
#'
#' @inheritParams trakt_api_common_parameters
#' @return A `list` of one or more [tibbles][tibble::tibble-package] for `cast`
#' and `crew`. The latter `tibble` objects are as flat as possible.
#' @name people_media
#' @family people data
#' @seealso [media_people], for the other direction: Media that has people.
#' @examples
#' \dontrun{
#' trakt.people.movies("christopher-nolan")
#'
#' trakt.people.shows("kit-harington")
#' }
NULL

#' @keywords internal
#' @noRd
#' @importFrom tibble has_name
#' @importFrom tibble as_tibble
#' @importFrom tibble tibble
#' @importFrom dplyr bind_cols
#' @importFrom dplyr select
#' @importFrom purrr is_empty
trakt.people.media <- function(type = c("shows", "movies"), target,
                               extended = c("min", "full")) {
  extended <- match.arg(extended)
  type <- match.arg(type)

  # Construct URL, make API call
  url <- build_trakt_url("people", target, type, extended = extended)
  response <- trakt_get(url = url)

  if (identical(response, list(cast = list()))) {
    return(tibble())
  }

  if (type == "shows") {
    if (has_name(response, "cast") & !is_empty(response$cast)) {
      response$cast <- response$cast$show %>%
        unpack_show() %>%
        bind_cols(
          response$cast %>%
            select(-show)
        ) %>%
        as_tibble()
    }
    if (has_name(response, "crew") & !is_empty(response$crew)) {
      response$crew <- unpack_crew_sections(response$crew, type = "shows")
    }
  }
  if (type == "movies") {
    if (has_name(response, "cast") & !is_empty(response$cast)) {
      response$cast <- response$cast %>%
        unpack_movie() %>%
        as_tibble()
    }
    if (has_name(response, "crew") & !is_empty(response$crew)) {
      response$crew <- unpack_crew_sections(response$crew, type = "movies")
    }
  }

  response
}


#' @rdname people_media
#' @export
trakt.people.movies <- function(target, extended = c("min", "full")) {
  trakt.people.media(type = "movies", target = target, extended = extended)
}

#' @rdname people_media
#' @export
trakt.people.shows <- function(target, extended = c("min", "full")) {
  trakt.people.media(type = "shows", target = target, extended = extended)
}

# Media that has people ----

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
#' trakt.shows.people("breaking-bad")
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
#' @importFrom tibble has_name
trakt.media.people <- function(type = c("shows", "movies"), target,
                               extended = c("min", "full")) {
  type <- match.arg(type)
  extended <- match.arg(extended)

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "people", extended = extended)
  response <- trakt_get(url = url)

  if (is_empty(response)) return(tibble())

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
trakt.shows.people <- function(target, extended = c("min", "full")) {
  trakt.media.people(type = "shows", target = target, extended = extended)
}

#' @rdname media_people
#' @export
trakt.movies.people <- function(target, extended = c("min", "full")) {
  trakt.media.people(type = "movies", target = target, extended = extended)
}
