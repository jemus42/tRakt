#' Get a user's collected shows or movies
#'
#' `trakt.user.collection` pulls a user's watched shows or movies.
#' It does not use OAuth2, so you can only get data for a user with a
#' public profile.
#' @param user Target user. Defaults to `getOption("trakt.username")`
#' @param type Either `shows` (default) or `movies`
#' @return A `data.frame` containing stats
#' @export
#' @note See [the trakt API docs for further info](http://docs.trakt.apiary.io/reference/users/collection/get-collection)
#' @family user data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' myshows <- trakt.user.collection() # Defaults to your username if set
#' seans.movies <- trakt.user.collection(user = "sean", type = "movies")
#' }
trakt.user.collection <- function(user = getOption("trakt.username"), type = "shows") {
  if (is.null(user) && is.null(getOption("trakt.username"))) {
    stop("No username is set.")
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "collection", type)
  response <- trakt.api.call(url = url)

  if (type == "shows") {

    # Drop specials (s00)
    for (i in nrow(response$show)) {
      response$seasons[[i]]$episodes <- response$seasons[[i]]$episodes[response$seasons[[i]]$number != 0]
    }

    epstats <- plyr::ldply(1:nrow(response), function(show) {
      title <- response[show, ]$show$title
      # print(paste(show, title))
      x <- response$seasons[[show]]
      season_nums <- x[[1]]
      # Create per-season datasets, append season number
      if (length(x[[1]]) > 1) {
        for (s in 1:length(season_nums)) {
          x[[2]][[s]][["season"]] <- season_nums[[s]]
        }
        # Bind it all together
        temp <- plyr::ldply(x[[2]], as.data.frame)
        temp <- temp[temp$season != 0, ]
      } else {
        temp <- as.data.frame(x[[2]])
        temp[["season"]] <- season_nums
      }

      temp$title <- title
      names(temp) <- sub("number", "episode", names(temp))
      return(temp)
    })

    watched <- epstats[c("title", "season", "episode", "collected_at")]
  } else if (type == "movies") {
    # Flatten out ids
    movies <- cbind(response$movie[names(response$movie) != "ids"], response$movie$ids)

    watched <- cbind(response[names(response) != "movie"], movies)
  } else {
    stop("Unknown type, must be 'shows' or 'movies'")
  }
  # To be sure
  watched <- convert_datetime(watched)
  watched$collected.year <- lubridate::year(watched$collected_at)

  return(watched)
}
