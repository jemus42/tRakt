#' Get a user's followings
#'
#' \code{trakt.user.following} pulls a user's followings.
#' Since no OAuth2 methods are supported yet, the specified user mustn't be private.
#' @param user Target user. Defaults to \code{getOption("trakt.username")}
#' @return A \code{data.frame} containing user information.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/following/get-following}{the trakt API docs for further info}
#' @family user
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.user.following("jemus42")
#' }
trakt.user.following <- function(user = getOption("trakt.username")){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  if (is.null(user) && is.null(getOption("trakt.username"))){
    stop("No username is set.")
  }

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/users"
  url      <- paste0(baseURL, "/", user, "/following")
  response <- trakt.api.call(url = url)
  
  # Flatten the data.frame
  response <- cbind(subset(response, select = -user), response$user)
  return(response)
}
