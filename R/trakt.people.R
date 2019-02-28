#' Get a single person's details
#'
#' Get a single person's details, like their various IDs. If `extended` is `"full"`,
#' there will also be biographical data if available.
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @importFrom purrr flatten_df
#' @importFrom purrr modify_if
#' @importFrom purrr map_df
#' @family people data
#' @examples
#' \dontrun{
#' person <- trakt.people.summary("bryan-cranston", "min")
#'
#' more_people <- trakt.people.summary(c("kit-harington", "emilia-clarke"))
#' }
trakt.people.summary <- function(target, extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (length(target) > 1) {
    return(purrr::map_df(target, ~trakt.people.summary(.x, extended)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("people", target, extended = extended)
  response <- trakt.api.call(url = url)

  # Substitute NULLs with explicit NAs and flatten IDs
  response$ids <- fix_ids(response$ids)
  response <- purrr::modify_if(response, is.null,
                               function(x) return(NA_character_))
  response <- purrr::flatten_df(response)

  response
}

# People that have media ----

#' Get a single person's movie or show credits
#'
#' Returns all movies or shows where this person is in the cast or crew.
#' @inheritParams trakt_api_common_parameters
#' @return A `list`.
#' @name people_media
#' @family people data
#' @seealso [trakt.media.people], for the other direction: Media that has people.
#' @examples
#' \dontrun{
#' trakt.people.movies("bryan-cranston")
#' }
NULL

#' @keywords internal
trakt.people.media <- function(type = c("shows", "movies"), target,
                               extended = c("min", "full")) {
  extended <- match.arg(extended)
  type <- match.arg(type)

  # Construct URL, make API call
  url <- build_trakt_url("people", target, type, extended = extended)
  trakt.api.call(url = url)
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
#' @inheritParams trakt_api_common_parameters
#' @return A `list`.
#' @name media_people
#' @family people data
#' @seealso [trakt.people.media], for the other direction: People that have credits.
#' @examples
#' \dontrun{
#' breakingbad.people <- trakt.show.people("breaking-bad")
#' }
#'

#' @keywords internal
trakt.media.people <- function(type = c("shows", "movies"), target,
                               extended = c("min", "full")) {

  type <- match.arg(type)
  extended <- match.arg(extended)

  # Construct URL, make API call
  url <- build_trakt_url(type, target, "people", extended = extended)
  response <- trakt.api.call(url = url)

  # Flatten the data.frame
  response$cast <- cbind(
    response$cast[names(response$cast) != "person"],
    response$cast$person
  )
  response$cast <- cbind(
    response$cast[names(response$cast) != "ids"],
    response$cast$ids
  )

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

