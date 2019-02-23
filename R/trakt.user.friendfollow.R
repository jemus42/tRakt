#' Get a user's friends, followers or followings
#'
#' `trakt.user.friends` retrieves a user's friends, the two-way relationship
#' of both following and being followed by a user.
#' @inheritParams user_param
#' @inheritParams extended_info
#' @inherit return_tibble return
#' @export
#' @note Since no OAuth2 methods are supported yet, the specified user must not be private.
#' @family user data
#' @examples
#' \dontrun{
#' trakt.user.friends("jemus42")
#' trakt.user.followers("jemus42")
#' trakt.user.following("jemus42")
#' }
trakt.user.network <- function(relationship = c("friends", "followers", "following"),
                                    user = getOption("trakt.username"),
                                    extended = c("min", "full")) {

  check_username(user)
  extended <- match.arg(extended)
  relationship <- match.arg(relationship)

  if (length(user) > 1) {
    response <- purrr::map_df(user, function(user) {
      trakt_user_friendfollow(relationship = relationship, user = user, extended = extended)
    })
    return(response)
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, relationship, extended = extended)
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

# Aliased/derived ----

#' @rdname trakt.user.network
#' @export
trakt.user.friends <- function(user = getOption("trakt.username"),
                               extended = c("min", "full")) {

  trakt_user_friendfollow(relationship = "friends", user = user, extended = extended)
}

#' @rdname trakt.user.network
#' @export
trakt.user.followers <- function(user = getOption("trakt.username"),
                                 extended = c("min", "full")) {

  trakt_user_friendfollow(relationship = "followers", user = user, extended = extended)
}

#' @rdname trakt.user.network
#' @export
trakt.user.following <- function(user = getOption("trakt.username"),
                                 extended = c("min", "full")) {

  trakt_user_friendfollow(relationship = "following", user = user, extended = extended)
}
