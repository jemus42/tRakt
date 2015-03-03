#' Get a user's collected shows or movies
#'
#' \code{trakt.user.collection} pulls a user's watched shows or movies.
#' It does not use OAuth2, so you can only get data for a user with a
#' public profile.
#' @param user Target user. Defaults to \code{getOption("trakt.username")}
#' @param type Either \code{shows} (default) or \code{movies}
#' @return A \code{data.frame} containing stats
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/collection/get-collection}{the trakt API docs for further info}
#' @family user
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' myshows      <- trakt.user.collection() # Defaults to your username if set
#' seans.movies <- trakt.user.collection(user = "sean", type = "movies)
#' }
trakt.user.collection <- function(user = getOption("trakt.username"), type = "shows"){
  if (is.null(user) && is.null(getOption("trakt.username"))){
    stop("No username is set.")
  }

  # Construct URL, make API call
  baseURL   <- "https://api-v2launch.trakt.tv/users"
  url       <- paste0(baseURL, "/", user, "/collection/", type)
  response  <- trakt.api.call(url = url)

  if (type == "shows"){

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
      epstats <- rbind(temp, epstats)
    }
    watched <- epstats[c("title", "season", "episode", "collected_at")]
  } else if (type == "movies"){
    # Flatten out ids
    movies           <- response$movie[c("title", "year")]
    movies$id.slug      <- response$movie$ids$slug
    movies$id.trakt  <- response$movie$ids$trakt
    movies$id.imdb   <- response$movie$ids$imdb
    movies$id.tmdb   <- response$movie$ids$tmdb

    watched <- cbind(response["collected_at"], movies)
  } else {
    stop("Unknown type, must be 'shows' or 'movies'")
  }
  # To be sure
  watched                <- convert_datetime(watched)
  watched$collected.year <- lubridate::year(watched$collected_at)

  return(watched)
}
