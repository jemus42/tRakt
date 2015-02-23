#' Get a user's ratings
#'
#' \code{trakt.user.ratings} pulls a user's ratings

#' @param user Target user. Defaults to \code{getOption("trakt.username")}
#' @param type Either \code{shows} (default) or \code{movies}
#' @return A \code{list} or \code{data.frame} containing stats.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/ratings/get-ratings}{the trakt API docs for further info}
#' @family user
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' mystats   <- trakt.user.stats() # Defaults to your username if set
#' seanstats <- trakt.user.stats(user = "sean")
#' }
trakt.user.ratings <- function(user = getOption("trakt.username"), type = "shows", rating = NULL){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  if (is.null(user) && is.null(getOption("trakt.username"))){
    stop("No username is set.")
  }
  if (type == "seasons"){
    stop("Season ratings are not supported (yet), use episodes or shows.")
  }
  # Please R CMD check
  ids <- NULL; episode <- NULL; show <- NULL

  # Construct URL
  baseURL   <- "https://api-v2launch.trakt.tv/users"
  url       <- paste0(baseURL, "/", user, "/ratings/", type, "/", rating)

  # Actual API call
  response  <- trakt.api.call(url = url)

  # Flattening
  if (type == "shows"){
    response$show <- cbind(subset(response$show, select = -ids),  response$show$ids)
    response      <- cbind(subset(response,      select = -show), response$show)
  } else if (type == "movies"){
    response$movie <- cbind(subset(response$movie, select = -ids),   response$movie$ids)
    response       <- cbind(subset(response,       select = -movie), response$movie)

  } else if (type == "episodes"){
    # Prepend ids to avoid duplicates
    names(response$episode$ids) <- paste0("episode.", names(response$episode$ids))
    names(response$show)[-3]    <- paste0("show.",    names(response$show)[-3])
    names(response$show$ids)    <- paste0("show.",    names(response$show$ids))
    # Move stuff around to flatten the DF
    response$episode <- cbind(subset(response$episode, select = -ids),     response$episode$ids)
    response$show    <- cbind(subset(response$show,    select = -ids),     response$show$ids)
    response         <- cbind(subset(response,         select = -episode), response$episode)
    response         <- cbind(subset(response,         select = -show),    response$show)
    names(response)  <- sub("number", "episode", names(response))
  }

  # Date normalization
  response$rated_at  <- lubridate::parse_date_time(response$rated_at,
                                                   "%y-%m-%dT%H-%M-%S", truncated = 3)

  return(response)
}
