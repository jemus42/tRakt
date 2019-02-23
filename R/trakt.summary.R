#' Get a single movie's details
#'
#' `trakt.movie.summary` returns a single movie's summary information.
#' @inheritParams id_movie_show
#' @inheritParams extended_info
#' @param force_data_frame If `TRUE`, the `list` is unnested as much as possible, resulting
#' in a flat `tibble` suitable to be `rbind`ed to other summary results.
#' @inherit return_tibble return
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/summary/get-a-movie}{the trakt API docs for further info}
#' @family movie data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movie.summary("tron-legacy-2010")
#' }
trakt.movie.summary <- function(target, extended = c("min", "full"), force_data_frame = FALSE) {
  trakt.summary(
    type = "movies", target = target, extended = extended,
    force_data_frame = force_data_frame
  )
}

#' Get show summary info
#'
#' `trakt.show.summary` pulls show summary data and returns it compactly.
#'
#' Note that setting `extended` to `min` makes this function
#' return about as much informations as \link[tRakt]{trakt.search}
#' @inheritParams id_movie_show
#' @inheritParams extended_info
#' @param force_data_frame If `TRUE`, the `list` is unnested as much as possible, resulting
#' in a flat [tibble][tibble::tibble-package] suitable to `rbind` with other summary results.
#' @inherit return_tibble return
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/shows/summary}{the trakt API docs for further info}
#' @family show data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.summary <- trakt.show.summary("breaking-bad")
#' }
trakt.show.summary <- function(target, extended = c("min", "full"), force_data_frame = FALSE) {
  extended <- match.arg(extended)

  trakt.summary(
    type = "shows", target = target, extended = extended,
    force_data_frame = force_data_frame
  )
}

#' @keywords internal
trakt.summary <- function(type, target, extended = c("min", "full"), force_data_frame = FALSE) {
  extended <- match.arg(extended)

  if (length(target) > 1) {
    response <- purrr::map_df(target, function(t) {
      trakt.summary(
        type = type, target = t, extended = extended,
        force_data_frame = TRUE
      )
    })
    return(response)
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, target, extended = extended)
  response <- trakt.api.call(url = url)

  if (force_data_frame) {
    temp <- response[sapply(response, length) == 1]
    temp[unlist(lapply(temp, is.null))] <- NA
    temp <- as.data.frame(temp)
    temp <- cbind(temp, response$ids)
    if ("airs" %in% names(response)) {
      names(response$airs) <- paste0("airs_", names(response$airs))
      temp <- cbind(temp, response$airs)
    }
    # Drop translations because no.
    if ("available_translations" %in% names(response)) {
      temp <- temp[names(temp) != "available_translations"]
    }
    response <- tibble::as_tibble(temp)
  }
  response
}
