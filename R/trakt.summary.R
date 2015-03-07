#' Get a single movie's details
#'
#' \code{trakt.movie.summary} returns a single movie's summary information.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}. If multiple targets are
#' supplied, the results will be \code{rbind}ed together, automatically setting \code{force_data_frame}
#' to \code{TRUE}.
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

  response <- trakt.summary(type = "movies", target = target, extended = extended,
                            force_data_frame = force_data_frame)
  return(response)
}

#' Get show summary info
#'
#' \code{trakt.show.summary} pulls show summary data and returns it compactly.
#'
#' Note that setting \code{extended} to \code{min} makes this function
#' return about as much informations as \link[tRakt]{trakt.search}
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}. If multiple targets are
#' supplied, the results will be \code{rbind}ed together, automatically setting \code{force_data_frame}
#' to \code{TRUE}.
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

  response <- trakt.summary(type = "shows", target = target, extended = extended,
                            force_data_frame = force_data_frame)
  return(response)
}

#' @keywords internal
trakt.summary <- function(type, target, extended = "min", force_data_frame = FALSE){
  if (length(target) > 1){
    response <- plyr::ldply(target, function(t){
      response <- trakt.summary(type = type, target = t, extended = extended, force_data_frame = TRUE)
      return(response)
    })
    return(response)
  }

  # Construct URL, make API call
  url      <- build_trakt_url(type, target, extended = extended)
  response <- trakt.api.call(url = url)

  if (force_data_frame){
    temp <- response[sapply(response, length) == 1]
    temp[unlist(lapply(temp, is.null))] <- NA
    temp                                <- as.data.frame(temp)
    temp                                <- cbind(temp, response$ids)
    if ("airs" %in% names(response)){
      names(response$airs)                <- paste0("airs.", names(response$airs))
      temp                                <- cbind(temp, response$airs)
    }
    if ("available_translations" %in% names(response)){
      temp[["available_translations"]]    <- I(list(response$available_translations))
    }
    if ("images" %in% names(response)){
      temp[["images"]][[1]]               <- I(response$images)
    }
    response <- temp
  }
  return(response)
}
