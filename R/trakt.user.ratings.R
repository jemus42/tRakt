#' Get a user's ratings
#'
#' \code{trakt.user.ratings} pulls a user's ratings
#' @param user Target user. Defaults to \code{getOption("trakt.username")}
#' @param type Either \code{shows} (default) or \code{movies}
#' @param rating A rating to filter by. Can be \code{1} through \code{10}, default is \code{NULL}
#' @return A \code{list} or \code{data.frame} containing stats.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/ratings/get-ratings}{the trakt API docs for further info}
#' @family user
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' ratedshows  <- trakt.user.ratings()
#' ratedmovies <- trakt.user.ratings(type = "movies")
#' }
trakt.user.ratings <- function(user = getOption("trakt.username"), type = "shows", rating = NULL){
  if (is.null(user) && is.null(getOption("trakt.username"))){
    stop("No username is set.")
  }
  if (type == "seasons"){
    message("Season ratings are not cleaned up (yet), consider using episodes or shows.")
  }
  if (!is.null(rating) && !(rating %in% 1:10)){
    stop("rating must be between 1 and 10")
  }

  # Construct URL, make API call
  baseURL   <- "https://api-v2launch.trakt.tv/users/"
  url       <- paste0(baseURL, user, "/ratings/", type, "/", rating)
  response  <- trakt.api.call(url = url)

  # Flattening
  if (type == "shows"){
    response$show  <- cbind(response$show[names(response$show) != "ids"],  response$show$ids)
    response       <- cbind(response[names(response) != "show"], response$show)
  } else if (type == "movies"){
    response$movie <- cbind(response$movie[names(response$movie) != "ids"],   response$movie$ids)
    response       <- cbind(response[names(response) != "movie"], response$movie)

  } else if (type == "episodes"){
    # Prepend ids to avoid duplicates
    names(response$episode$ids) <- paste0("episode.", names(response$episode$ids))
    names(response$show)[-3]    <- paste0("show.",    names(response$show)[-3])
    names(response$show$ids)    <- paste0("show.",    names(response$show$ids))
    # Move stuff around to flatten the DF
    response$episode <- cbind(response$episode[names(response$episode) != "ids"], response$episode$ids)
    response$show    <- cbind(response$show[names(response$show) != "ids"],       response$show$ids)
    response         <- cbind(response[names(response) != "episode"],             response$episode)
    response         <- cbind(response[names(response) != "show"],                response$show)
    names(response)  <- sub("number", "episode", names(response))
  }
  return(response)
}
