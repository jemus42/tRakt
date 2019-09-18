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
#' @importFrom dplyr rename_all
#' @importFrom tibble tibble
#' @importFrom tibble as_tibble
#' @importFrom purrr map_df
#' @return A [tibble()][tibble::tibble-package].
#' @note For `type = "shows"`, the
#' original output contains a nested object with `show` and `episode` data,
#' which are unnested by this function. Due to duplicate variable names,
#' all episode-related variables are prefixed with `episode_`.
#' @export
#' @examples
#' \dontrun{
#' # The last 5 movies that user "jemus42" has watched
#' trakt.user.history(user = "jemus42", type = "movies", limit = 5)
#' }
trakt.user.history <- function(user = getOption("trakt_username"),
                               type = c("shows", "movies"),
                               limit = 10L, start_at = NULL, end_at = NULL,
                               extended = c("min", "full")) {
  check_username(user)
  type <- match.arg(type)
  extended <- match.arg(extended)

  # start_at <- "2019-01-01"
  # end_at <- "2019-12-31"
  # limit <- 10100

  start_at <- if (!is.null(start_at)) format(as.POSIXct(start_at), "%FT%T.000Z", tz = "UTC")
  end_at   <- if (!is.null(end_at))   format(as.POSIXct(end_at),   "%FT%T.000Z", tz = "UTC")

  if (length(user) > 1) {
    names(user) <- user
    return(map_df(user, ~ trakt.user.history(user = .x, type, limit, start_at, end_at, extended),
                  .id = "user"))
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "history", type,
    extended = extended, limit = limit, start_at = start_at, end_at = end_at
  )
  response <- trakt_get(url = url)
  response <- as_tibble(response)

  if (identical(response, tibble())) return(response)

  if (type == "shows") {
    response <- bind_cols(
      # History metadata
      response %>%
        select(-show, -episode),
      # Unpacked show data
      unpack_show(response$show),
      # Unpacked episode data
      response$episode %>%
        select(-ids) %>%
        bind_cols(fix_ids(response$episode$ids)) %>%
        rename(episode = number) %>%
        fix_tibble_response() %>%
        rename_all(~paste0("episode_", .x))
    )
  }
  if (type == "movies") {
    response <- unpack_movie(response)
  }

  fix_tibble_response(response)
}
