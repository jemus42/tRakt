#' Get a user's watch history
#'
#' Retrieve a the last `limit` items a user has watched, including the method by
#' which it was logged (e.g. *scrobble* or *checkin*).
#' @inheritParams trakt_api_common_parameters
#' @param start_at,end_at `character(1)`: A time-window to filter by. Must be coercible
#' to a datetime object of class `POSIXct`. See [ISOdate] for further information.
#' @family user data
#' @importFrom dplyr bind_cols
#' @importFrom dplyr select
#' @importFrom dplyr bind_cols
#' @importFrom dplyr rename
#' @return A [tibble][tibble::tibble-package]. For `type == "show"`, the `tibble` contains
#' two list-columns `show` and `episode` which are *not* unnested by default due to
#' duplicate variable names, the preferref handling of which is left to the user.
#' @export
#' @examples
#' \dontrun{
#' # The last 5 movies that user "jemus42" has watched
#' trakt.user.history(user = "jemus42", type = "movies", limit = 5)
#' }
trakt.user.history <- function(user = getOption("trakt.username"),
                               type = c("shows", "movies"),
                               limit = 10L, start_at = NULL, end_at = NULL,
                               extended = c("min", "full")) {

  check_username(user)
  type <- match.arg(type)
  extended <- match.arg(extended)

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "history", type,
                         extended = extended, limit = limit)
  response <- trakt.api.call(url = url)
  response <- tibble::as_tibble(response)

  if (identical(response, tibble::tibble())) return(response)

  if (type == "shows") {
    # Fix episodes first
    response$episode <- response$episode %>%
      dplyr::select(-ids) %>%
      dplyr::bind_cols(fix_ids(response$episode$ids)) %>%
      dplyr::rename(episode = number) %>%
      tibble::as_tibble() %>%
      fix_datetime()

    # Unpack the show media object and bind it to the base tbl
    response$show <- unpack_show(response$show) %>% fix_datetime()
  }
  if (type == "movies") {
    response$movie$ids <- fix_ids(response$movie$ids)
    response$movie <- response$movie %>%
      dplyr::select(-ids) %>%
      dplyr::bind_cols(response$movie$ids)

    response <- response %>%
      dplyr::select(-movie) %>%
      dplyr::bind_cols(response$movie) %>%
      fix_datetime()
  }

  tibble::as_tibble(response)
}
