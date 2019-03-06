#' Get a user's collected shows or movies
#'
#' `trakt.user.collection` retrieves a user's collected shows or movies.
#' It does not use OAuth2, so you can only get data for a user with a
#' public profile.
#'
#' @details
#' This function wraps [this API method](https://trakt.docs.apiary.io/#reference/users/collection/get-collection)
#' at the endpoint `/users/:user_id/collection/:type`.
#' @note The `extended = "metadata"` API parameter is not implemented. This would
#' add media information `media_type`, `resolution`, `audio`, `audio_channels` and `3D`
#' to the output, which may or may not be available. If this feature is important to
#' you, please open an issue on GitHub.
#'
#' @inheritParams trakt_api_common_parameters
#' @param unnest_episodes `logical(1) [FALSE]`: Unnests episode data using
#' `[tidyr](tidyr::unnest)` and returns one row per episode rather than one row per show.
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @family user data
#' @importFrom lubridate ymd_hms
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom dplyr bind_cols
#' @importFrom dplyr everything
#' @importFrom dplyr rename
#' @importFrom tibble as_tibble
#' @importFrom purrr map
#' @importFrom purrr map_df
#' @examples
#' \dontrun{
#' trakt.user.collection(user = "sean", type = "movies")
#' }
trakt.user.collection <- function(user = getOption("trakt.username"),
                                  type = c("shows", "movies"),
                                  extended = c("min", "full"),
                                  unnest_episodes = FALSE) {
  check_username(user)
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (length(user) > 1) {
    names(user) <- user
    return(map_df(user, ~ trakt.user.collection(user = .x, type, extended, unnest_episodes),
                  .id = "user"))
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "collection", type, extended = extended)
  response <- trakt.api.call(url = url)

  if (type == "shows") {
    response <- response %>%
      select(-show) %>%
      bind_cols(unpack_show(response$show)) %>%
      as_tibble() %>%
      select(-seasons, everything(), seasons) %>%
      mutate(seasons = map(seasons, as_tibble))

    # I think importing tidyr for this alone is worth it, because
    # A list structure this big and deeply nested is just wrong:
    # (response[[11]][[1]])[[2]][[1]][[2]]

    if (unnest_episodes) {
      if (!requireNamespace("tidyr", quietly = TRUE)) {
        stop("This functionality requires the tidyr package")
      }

      response <- as_tibble(response) %>%
        tidyr::unnest(seasons) %>%
        rename(season = number) %>%
        tidyr::unnest(episodes) %>%
        rename(episode = number) %>%
        dplyr::mutate(collected_at = ymd_hms(collected_at))
    }
  } else if (type == "movies") {
    response <- unpack_movie(response)
  }

  fix_tibble_response(response)
}
