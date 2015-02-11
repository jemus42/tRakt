#' Get a user's watched shows or movies
#'
#' \code{trakt.user.watched} pulls a user's stats.

#' @param user Target user. Defaults to \code{getOption("trakt.username")}
#' @param type Either \code{shows} (default), or \code{movies}
#' @return A \code{data.frame} containing stats.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/stats/get-stats}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' mystats   <- trakt.user.watched() # Defaults to your username if set
#' seanstats <- trakt.user.watched(user = "sean")
#' }
trakt.user.watched <- function(user = getOption("trakt.username"), type = "shows"){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  if (is.null(getOption("trakt.username"))){
    stop("No username is not set.")
  }
  
  # Construct URL
  baseURL   <- "https://api-v2launch.trakt.tv/users"
  url       <- paste0(baseURL, "/", user, "/watched/", type)
  
  # Actual API call
  headers   <- getOption("trakt.headers")
  response  <- httr::GET(url, headers)
  httr::stop_for_status(response) # In case trakt fails
  response  <- httr::content(response, as = "text")
  response  <- jsonlite::fromJSON(response)
  
  if (type == "shows"){
    # Flatten out ids
    shows           <- response$show[c("title", "year")]
    shows$slug      <- response$show$ids$slug
    shows$id.trakt  <- response$show$ids$trakt
    shows$id.imdb   <- response$show$ids$imdb
    shows$id.tvdb   <- response$show$ids$tvdb
    shows$id.tvrage <- response$show$ids$tvrage
    
    watched <- cbind(response[c("plays", "last_watched_at")], shows)
  } else if (type == "movies"){
    movies           <- response$movie[c("title", "year")]
    movies$slug      <- response$movie$ids$slug
    movies$id.trakt  <- response$movie$ids$trakt
    movies$id.imdb   <- response$movie$ids$imdb
    movies$id.tmdb   <- response$movie$ids$tmdb
    
    watched <- cbind(response[c("plays", "last_watched_at")], movies)
  } else {
    stop("Unknown type, must be 'shows' or 'movies'")
  }
  
  watched$lastwatched.posix  <- as.POSIXct(watched$last_watched_at, 
                                             origin = lubridate::origin, tz = "UTC")
  watched$lastwatched.string <- format(watched$lastwatched.posix, "%F")  
  watched$lastwatched.year   <- lubridate::year(watched$lastwatched.posix)
  
  return(watched)
}
