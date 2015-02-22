#' Get a user's watched shows or movies
#'
#' \code{trakt.user.watched} pulls a user's watched shows or movies.
#' It does not use OAuth2, so you can only get data for a user with a
#' public profile.
#' @param user Target user. Defaults to \code{getOption("trakt.username")}
#' @param type Either \code{shows} (default), \code{shows.extended} or \code{movies}
#' @return A \code{data.frame} containing stats.
#' if \code{type} is set to \code{shows.extended}, the resulting \code{data.frame}
#' contains play stats for _every_ watched episode of _every_ show. Otherwise,
#' the returned \code{data.frame} only contains play stats per show or movie respectively.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/watched/get-watched}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' myshows     <- trakt.user.watched() # Defaults to your username if set
#' seans.shows <- trakt.user.watched(user = "sean")
#' }
trakt.user.watched <- function(user = getOption("trakt.username"), type = "shows"){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  if (is.null(user) && is.null(getOption("trakt.username"))){
    stop("No username is set.")
  }

  # Construct URL
  baseURL   <- "https://api-v2launch.trakt.tv/users"
  url       <- paste0(baseURL, "/", user, "/watched/", type)

  # Actual API call
  response  <- trakt.api.call(url = url)

  if (type == "shows"){
    # Flatten out ids
    shows           <- response$show[c("title", "year")]
    shows$slug      <- response$show$ids$slug
    shows$id.trakt  <- response$show$ids$trakt
    shows$id.imdb   <- response$show$ids$imdb
    shows$id.tvdb   <- response$show$ids$tvdb
    shows$id.tvrage <- response$show$ids$tvrage

    # Try to get some stuff out of response$seasons
    shows$seasons  <- sapply(response$seasons, function(x){max(x[[1]])})
    shows$episodes <- length(sapply(response$seasons, function(x){x[[2]]}))

    watched <- cbind(response[c("plays", "last_watched_at")], shows)

  } else if (type == "shows.extended"){

    # Drop specials (s00)
    for (i in nrow(response$show)){
      response$seasons[[i]]$episodes <- response$seasons[[i]]$episodes[response$seasons[[i]]$number != 0]
    }

    epstats <- NULL
    for (show in 1:nrow(response)){
      title <- response[show, ]$show$title
      #print(paste(show, title))
      x      <- response$seasons[[show]]
      season_nums <- x[[1]]
      # Create per-season datasets, append season number
      if (length(x[[1]]) > 1){
        for (s in 1:length(season_nums)){
          x[[2]][[s]][["season"]] <- season_nums[[s]]
        }
        # Bind it all together
        temp <- plyr::ldply(x[[2]], as.data.frame)
        temp <- temp[temp$season != 0, ]
      } else {
        temp <- as.data.frame(x[[2]])
        temp[["season"]] <- season_nums
      }

      temp$title  <- title
      names(temp) <- sub("number", "episode", names(temp))
      epstats     <- rbind(temp, epstats)
    }
    watched <- epstats[c("title", "season", "episode", "plays", "last_watched_at")]
  } else if (type == "movies"){
    # Flatten out ids
    movies          <- response$movie[c("title", "year")]
    movies$slug     <- response$movie$ids$slug
    movies$id.trakt <- response$movie$ids$trakt
    movies$id.imdb  <- response$movie$ids$imdb
    movies$id.tmdb  <- response$movie$ids$tmdb

    watched <- cbind(response[c("plays", "last_watched_at")], movies)
  } else {
    stop("Unknown type, must be 'shows', 'shows.extended', or 'movies'")
  }

  watched$last_watched_at  <- lubridate::parse_date_time(watched$last_watched_at,
                                                           "%y-%m-%dT%H-%M-%S", truncated = 3)
  watched$last_watched.year <- lubridate::year(watched$lastwatched.posix)

  return(watched)
}
