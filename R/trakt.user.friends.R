#' Get a user's friends
#'
#' \code{trakt.user.friends} pulls a user's friends, the two-way relationship
#' of both following and being followed by a user.
#' Since no OAuth2 methods are supported yet, the specified user mustn't be private.
#' @param user Target user. Defaults to \code{getOption("trakt.username")}
#' @return A \code{data.frame} containing user information.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/friends/get-friends}{the trakt API docs for further info}
#' @family user
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.user.friends("jemus42")
#' }
trakt.user.friends <- function(user = getOption("trakt.username")){
  if (is.null(user) && is.null(getOption("trakt.username"))){
    stop("No username is set.")
  }

  # Construct URL, make API call
  baseURL  <- "https://api-v2launch.trakt.tv/users"
  url      <- paste0(baseURL, "/", user, "/friends")
  response <- trakt.api.call(url = url)
  
  # Flatten the data.frame
  response <- cbind(subset(response, select = -user), response$user)
  return(response)
}
