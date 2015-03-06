#' Get a single movie's details
#'
#' \code{trakt.movie.summary} returns a single movie's summary information.
#' @param target The \code{id} of the movie requested. Either the \code{slug}
#' (e.g. \code{"tron-legacy-2010"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @param force_data_frame If \code{TRUE}, the \code{list} is unnested as much as possible, resulting
#' in a flat \code{data.frame} suitable to be \code{rbind}ed to other summary results.
#' @return A \code{list} or \code{data.frame} containing movie information
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/movies/summary/get-a-movie}{the trakt API docs for further info}
#' @family movie data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.movie.summary("tron-legacy-2010")
#' }
trakt.movie.summary <- function(target, extended = "min", force_data_frame = FALSE){

  # Construct URL, make API call
  url      <- build_trakt_url("movies", target, extended = extended)
  response <- trakt.api.call(url = url)

  if (force_data_frame){
    movie <- response[sapply(response, length) == 1]
    movie[unlist(lapply(movie, is.null))] <- NA
    movie                                 <- as.data.frame(movie)
    movie                                 <- cbind(movie, response$ids)
    if ("available_translations" %in% names(response)){
      movie[["available_translations"]]   <- I(list(response$available_translations))
    }
    if ("images" %in% names(response)){
      movie[["images"]][[1]]              <- I(response$images)
    }
    response <- movie
  }
  return(response)
}

#' Get show summary info
#'
#' \code{trakt.show.summary} pulls show summary data and returns it compactly.
#'
#' Note that setting \code{extended} to \code{min} makes this function
#' return about as much informations as \link[tRakt]{trakt.search}
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}
#' @param extended Whether extended info should be provided.
#' Defaults to \code{"min"}, can either be \code{"min"} or \code{"full"}
#' @param force_data_frame If \code{TRUE}, the \code{list} is unnested as much as possible, resulting
#' in a flat \code{data.frame} suitable to be \code{rbind}ed to other summary results.
#' @return A \code{list} or \code{data.frame} containing summary info
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/shows/summary}{the trakt API docs for further info}
#' @family show data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.summary <- trakt.show.summary("breaking-bad")
#' }
trakt.show.summary <- function(target, extended = "min", force_data_frame = FALSE){

  # Construct URL, make API call
  url      <- build_trakt_url("shows", target, extended = extended)
  response <- trakt.api.call(url = url)

  if (force_data_frame){
    show <- response[sapply(response, length) == 1]
    show[unlist(lapply(show, is.null))] <- NA
    show                                <- as.data.frame(show)
    show                                <- cbind(show, response$ids)
    if ("airs" %in% names(response)){
      names(response$airs)                <- paste0("airs.", names(response$airs))
      show                                <- cbind(show, response$airs)
    }
    if ("available_translations" %in% names(response)){
      show[["available_translations"]]    <- I(list(response$available_translations))
    }
    if ("images" %in% names(response)){
      show[["images"]][[1]]               <- I(response$images)
    }
    response <- show
  }
  return(response)
}
