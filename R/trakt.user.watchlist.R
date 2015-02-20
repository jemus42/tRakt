#' Get a user's watchlist
#'
#' \code{trakt.user.watchlist} pulls a user's watchlist.

#' @param user Target user. Defaults to \code{getOption("trakt.username")}
#' @param type Either \code{shows} (default), \code{seasons} or \code{movies}
#' @return A \code{data.frame} containing stats.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/#reference/users/ratings/get-watchlist}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' mystats   <- trakt.user.watchlist() # Defaults to your username if set
#' seanstats <- trakt.user.watchlist(user = "sean")
#' }
trakt.user.watchlist <- function(user = getOption("trakt.username"), type = "shows"){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  if (is.null(getOption("trakt.username"))){
    stop("No username is set.")
  }

  # Please R CMD check
  show  <- NULL
  ids   <- NULL
  movie <- NULL

  # Construct URL
  baseURL   <- "https://api-v2launch.trakt.tv/users"
  url       <- paste0(baseURL, "/", user, "/watchlist/", type)

  # Actual API call
  response  <- trakt.api.call(url = url)

  if (type == "show"){
    response  <- cbind(subset(response, select = -show), response$show)
    response  <- cbind(subset(response, select = -ids), response$ids)
  } else if (type == "movies"){
    response  <- cbind(subset(response, select = -movie), response$movie)
    response  <- cbind(subset(response, select = -ids), response$ids)
  }
  response$listed_at  <- lubridate::parse_date_time(response$listed_at, "%y-%m-%dT%H-%M-%S", truncated = 3)

  return(response)
}
