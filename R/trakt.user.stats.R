#' Get a user's stats
#'
#' \code{trakt.user.stats} pulls a user's stats.

#' @param user Target user. Defaults to \code{getOption("trakt.username")}
#' @return A \code{data.frame} containing stats.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/stats/get-stats}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' mystats   <- trakt.user.stats() # Defaults to your username if set
#' seanstats <- trakt.user.stats(user = "sean")
#' }
trakt.user.stats <- function(user = getOption("trakt.username")){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  if (is.null(getOption("trakt.username"))){
    stop("No username is set.")
  }

  # Construct URL
  baseURL   <- "https://api-v2launch.trakt.tv/users"
  url       <- paste0(baseURL, "/", user, "/stats")

  # Actual API call
  response  <- trakt.api.call(url = url)

  return(response)
}
