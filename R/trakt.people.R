#' Get a single person's details
#'
#' `trakt.people.summary` pulls show people data.
#'
#' Get a single person's details, like their various ids. If `extended` is `"full"`,
#' there will also be biographical data if available.
#' @param target The `id` of the person requested. Either the `slug`
#' (e.g. `"bryan-cranston"`), `trakt id` or `IMDb id`
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`
#' @return A `[tibble](tibble::tibble-package)` with person details.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/people/summary/get-a-single-person}{the trakt API docs for further info}
#' @family people data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' person <- trakt.people.summary("bryan-cranston")
#' }
trakt.people.summary <- function(target, extended = "min") {
  if (length(target) > 1) {
    response <- purrr::map_df(target, function(t) {
      response <- trakt.people.summary(target = t, extended = extended)
      return(response)
    })
    return(response)
  }

  # Construct URL, make API call
  url <- build_trakt_url("people", target, extended = extended)
  response <- trakt.api.call(url = url)

  # Flatten the data.frame
  # Fix NULLs (screw up data.frame conversion)
  response$ids[unlist(lapply(response$ids, is.null))] <- NA
  ids <- as.data.frame(response$ids)
  data <- response[names(response) != "ids"]
  # Fix NULLs (screw up data.frame conversion)
  data[unlist(lapply(data, is.null))] <- NA
  data <- as.data.frame(data)
  data <- cbind(data, ids)

  tibble::as_tibble(data)
}

#' Get a single person's movie credits
#'
#' `trakt.people.movies` pulls movie people data.
#'
#' Returns all movies where this person is in the cast or crew.
#' @param target The `id` of the person requested. Either the `slug`
#' (e.g. `"bryan-cranston"`), `trakt id` or `IMDb id`
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`
#' @return A `data.frame`s with person details.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/people/movies/get-movie-credits}{the trakt API docs for further info}
#' @family people data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' person <- trakt.people.movies("bryan-cranston")
#' }
trakt.people.movies <- function(target, extended = "min") {

  # Construct URL, make API call
  url <- build_trakt_url("people", target, "movies", extended = extended)
  response <- trakt.api.call(url = url)

  # Flattening cast
  if ("movie" %in% names(response$cast)) {
    response$cast$movie <- cbind(
      response$cast$movie[names(response$cast$movie) != "ids"],
      response$cast$movie$ids
    )
    response$cast <- cbind(
      response$cast[names(response$cast) != "movie"],
      response$cast$movie
    )
    response$cast <- convert_datetime(response$cast)
  }

  response
}

#' Get a single person's show credits
#'
#' `trakt.people.shows` pulls show people data.
#'
#' Returns all shows where this person is in the cast or crew.
#' @param target The `id` of the person requested. Either the `slug`
#' (e.g. `"bryan-cranston"`), `trakt id` or `IMDb id`
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`
#' @return A `data.frame`s with person details.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/people/shows/get-show-credits}{the trakt API docs for further info}
#' @family people data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' person <- trakt.people.shows("bryan-cranston")
#' }
trakt.people.shows <- function(target, extended = "min") {

  # Construct URL, make API call
  url <- build_trakt_url("people", target, "shows", extended = extended)
  response <- trakt.api.call(url = url)

  # Flattening cast
  if ("show" %in% names(response$cast)) {
    response$cast$show <- cbind(
      response$cast$show[names(response$cast$show) != "ids"],
      response$cast$show$ids
    )
    response$cast <- cbind(
      response$cast[names(response$cast) != "show"],
      response$cast$show
    )
    response$cast <- convert_datetime(response$cast)
  }

  response
}

#' Get the cast and crew of a show
#'
#' `trakt.show.people` pulls show people data.
#'
#' Returns all cast and crew for a show, depending on how much data is available.
#' @param target The `id` of the show requested. Either the `slug`
#' (e.g. `"game-of-thrones"`), `trakt id` or `IMDb id`
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`
#' @return A `list` containing `data.frame`s for cast and crew.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/shows/people/get-all-people-for-a-show}{the trakt API docs for further info}
#' @family show data
#' @family people data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.people <- trakt.show.people("breaking-bad")
#' }
trakt.show.people <- function(target, extended = "min") {

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "people", extended = extended)
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

#' Get the cast and crew of a movie
#'
#' `trakt.movie.people` pulls movie people data.
#'
#' Returns all cast and crew for a movie, depending on how much data is available.
#' @param target The `id` of the movie requested. Either the `slug`
#' (e.g. `"tron-legacy-2010"`), `trakt id` or `IMDb id`
#' @param extended Whether extended info should be provided.
#' Defaults to `"min"`, can either be `"min"` or `"full"`
#' @return A `list` containing `data.frame`s for cast and crew.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/movies/people/get-all-people-for-a-movie}{the trakt API docs for further info}
#' @family movie data
#' @family people data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' tron.people <- trakt.movie.people("tron-legacy-2010")
#' }
trakt.movie.people <- function(target, extended = "min") {

  # Construct URL, make API call
  url <- build_trakt_url("movies", target, "people", extended = extended)
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
