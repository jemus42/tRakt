#' Get a user's watched shows or movies
#'
#' `trakt.user.watched` retrieves a user's watched shows or movies.
#' It does not use OAuth2, so you can only get data for a user with a
#' **public profile**.
#'
#' @details
#' This function wraps the API method
#' [`/users/:id/watched/:type`](https://trakt.docs.apiary.io/#reference/users/watched/get-watched).
#' @inheritParams trakt_api_common_parameters
#' @param noseasons `logical(1) [TRUE]`: Only for `type = "show"`: Exclude detailed season
#' data from output. This is advisable if you do not need per-episode data and want to
#' be nice to the API.
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @family user data
#' @importFrom dplyr bind_cols
#' @importFrom dplyr select
#' @importFrom dplyr contains
#' @importFrom dplyr everything
#' @importFrom tibble tibble
#' @importFrom tibble as_tibble
#' @examples
#' \dontrun{
#' # Use noseasons = TRUE to avoid receiving detailed season/episode data
#' trakt.user.watched(user = "sean", noseasons = TRUE)
#' }
trakt.user.watched <- function(user = getOption("trakt_username"),
                               type = c("shows", "movies"),
                               noseasons = TRUE) {
  check_username(user)
  type <- match.arg(type)
  extended <- if (type == "shows" & noseasons) "noseasons" else ""

  if (length(user) > 1) {
    names(user) <- user
    return(map_df(user, ~ trakt.user.watched(user = .x, type, noseasons), .id = "user"))
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "watched", type, extended = extended)
  response <- trakt_get(url = url)

  if (identical(response, tibble())) return(response)

  if (type == "shows") {
    # Unpack the show media object and bind it to the base tbl
    response <- response %>%
      select(-show) %>%
      bind_cols(unpack_show(response$show)) %>%
      select(
        -contains("seasons"),
        everything(),
        contains("seasons")
      )
    # This uses contains() because the seasons column might not exist
    # and this way I don't have to use an extra if-statement to check "noseasons == TRUE"
  } else if (type == "movies") {
    response <- unpack_movie(response)
  }

  fix_tibble_response(response)
}
