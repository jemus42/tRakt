#' Get a user's stats
#'
#' \code{trakt.user.stats} pulls a user's stats.

#' @param user Target user. Defaults to \code{getOption("trakt.username")}
#' @param to.data.frame if \code{TRUE}, coerces the output to \code{data.frame}
#' using \pkg{plyr}'s \code{rbind.fill}. Defaults to \code{FALSE}.
#' @return A \code{list} or \code{data.frame} containing stats.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/stats/get-stats}{the trakt API docs for further info}
#' @family user
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' mystats   <- trakt.user.stats() # Defaults to your username if set
#' seanstats <- trakt.user.stats(user = "sean")
#' }
trakt.user.stats <- function(user = getOption("trakt.username"), to.data.frame = FALSE){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  if (is.null(user) && is.null(getOption("trakt.username"))){
    stop("No username is set.")
  }

  # Construct URL, make API call
  baseURL   <- "https://api-v2launch.trakt.tv/users"
  url       <- paste0(baseURL, "/", user, "/stats")
  response  <- trakt.api.call(url = url)

  if (to.data.frame){
    response <- plyr::ldply(response, as.data.frame, .id = "type")
  }
  return(response)
}
