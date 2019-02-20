#' Get a user's friends
#'
#' `trakt.user.friends` pulls a user's friends, the two-way relationship
#' of both following and being followed by a user.
#' Since no OAuth2 methods are supported yet, the specified user mustn't be private.
#' @param user Target user. Defaults to `getOption("trakt.username")`. If multiple users
#' are specified, the results will be `rbind`ed together and a `source_user` variable is
#' appended to indicated which user belongs to wich input user.
#' @param extended Either `min` for standard info, `full` for details or `full,images`
#' for additional avatar URLs.
#' @return A `data.frame` containing user information.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/friends/get-friends}{the trakt API docs for further info}
#' @family user data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.user.friends("jemus42")
#' }
trakt.user.friends <- function(user = getOption("trakt.username"), extended = "min") {
  if (length(user) > 1) {
    response <- purrr::map_df(user, function(user) {
      response <- trakt.user.friends(user = user, extended = extended)
      return(response)
    })
    return(response)
  }

  if ((is.null(user) && is.null(getOption("trakt.username"))) | user == "" | is.numeric(user)) {
    stop("No username is set.")
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "friends", extended = extended)
  response <- trakt.api.call(url = url)

  response <- tibble::as_tibble(response)

  # Flatten the tbl
  response <- cbind(response[names(response) != "user"], response$user)
  response <- cbind(response[names(response) != "ids"], response$ids)

  # Drop avatars because no.
  response <- response[names(response) != "images"]

  # Ensure datetime conversion
  response <- convert_datetime(response)

  tibble::as_tibble(tibble::remove_rownames(response))
}

#' Get a user's followers
#'
#' `trakt.user.followers` pulls a user's followers
#' Since no OAuth2 methods are supported yet, the specified user mustn't be private.
#' @param user Target user. Defaults to `getOption("trakt.username")`. If multiple users
#' are specified, the results will be `rbind`ed together and a `source_user` variable is
#' appended to indicated which user belongs to wich input user.
#' @param extended Either `min` for standard info, `full` for details or `full,images`
#' for additional avatar URLs.
#' @return A `[tibble](tibble::tibble-package)` containing user information.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/followers/get-followers}{the trakt API docs for further info}
#' @family user data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.user.followers("jemus42")
#' }
trakt.user.followers <- function(user = getOption("trakt.username"), extended = "min") {
  if (length(user) > 1) {
    response <- purrr::map_df(user, function(user) {
      response <- trakt.user.followers(user = user, extended = extended)
      return(response)
    })
    return(response)
  }

  if ((is.null(user) && is.null(getOption("trakt.username"))) | user == "" | is.numeric(user)) {
    stop("No username is set.")
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "followers", extended = extended)
  response <- trakt.api.call(url = url)

  response <- tibble::as_tibble(response)

  # Flatten the tbl
  response <- cbind(response[names(response) != "user"], response$user)
  response <- cbind(response[names(response) != "ids"], response$ids)

  # Drop avatars because no.
  response <- response[names(response) != "images"]

  # Ensure datetime conversion
  response <- convert_datetime(response)

  tibble::as_tibble(tibble::remove_rownames(response))
}

#' Get a user's followings
#'
#' `trakt.user.following` pulls a user's followings.
#' Since no OAuth2 methods are supported yet, the specified user mustn't be private.
#' @param user Target user. Defaults to `getOption("trakt.username")`. If multiple users
#' are specified, the results will be `rbind`ed together and a `source_user` variable is
#' appended to indicated which user belongs to wich input user.
#' @param extended Either `min` for standard info, `full` for details or `full,images`
#' for additional avatar URLs.
#' @return A `data.frame` containing user information.
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/users/following/get-following}{the trakt API docs for further info}
#' @family user data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' trakt.user.following("jemus42")
#' }
trakt.user.following <- function(user = getOption("trakt.username"), extended = "min") {
  if (length(user) > 1) {
    response <- purrr::map_df(user, function(user) {
      response <- trakt.user.following(user = user, extended = extended)
      return(response)
    })
    return(response)
  }

  if ((is.null(user) && is.null(getOption("trakt.username"))) | user == "" | is.numeric(user)) {
    stop("No username is set.")
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "following", extended = extended)
  response <- trakt.api.call(url = url)

  response <- tibble::as_tibble(response)

  # Flatten the tbl
  response <- cbind(response[names(response) != "user"], response$user)
  response <- cbind(response[names(response) != "ids"], response$ids)

  # Drop avatars because no.
  response <- response[names(response) != "images"]

  # Ensure datetime conversion
  response <- convert_datetime(response)

  tibble::as_tibble(tibble::remove_rownames(response))
}
