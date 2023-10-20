#' Get a user's collected shows or movies
#'
#'
#' @details
#' This function wraps the API method
#' [`/users/:user_id/collection/:type`](https://trakt.docs.apiary.io/#reference/users/collection/get-collection).
#' @note The `extended = "metadata"` API parameter is not implemented. This would
#' add media information `media_type`, `resolution`, `audio`, `audio_channels` and `3D`
#' to the output, which may or may not be available. If this feature is important to
#' you, please open an issue on GitHub.
#'
#' @inheritParams trakt_api_common_parameters
#' @param unnest_episodes `logical(1) [FALSE]`: Unnests episode data using
#' [tidyr::unnest()] and returns one row per episode rather than one row per show.
#' @inherit trakt_api_common_parameters return
#' @export
#' @family user data
#' @eval apiurl("users", "collection")
#' @importFrom lubridate ymd_hms
#' @importFrom dplyr mutate select bind_cols rename everything
#' @importFrom purrr map map_df pluck
#' @importFrom rlang is_empty
#' @examples
#' \dontrun{
#' user_collection(user = "sean", type = "movies")
#' user_collection(user = "sean", type = "shows")
#' }
user_collection <- function(user = "me",
                            type = c("shows", "movies"),
                            unnest_episodes = FALSE,
                            extended = c("min", "full")) {
  check_username(user)
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (type == "movie" && unnest_episodes) {
    warning("'unnest_episodes' only applies to type = 'shows'")
  }

  if (length(user) > 1) {
    names(user) <- user
    return(map_df(user, ~ user_collection(
      user = .x, type = type, unnest_episodes = unnest_episodes, extended = extended
    ),
    .id = "user"
    ))
  }

  if (extended == "min") {
    # extended = "min" causes weird output, expected result without param though
    extended <- ""
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "collection", type, extended = extended)
  response <- trakt_get(url = url)

  if (is_empty(response)) {
    return(tibble())
  }

  if (type == "shows") {
    response <- response |>
      select(-"show") |>
      bind_cols(
        pluck(response, "show") |>
          unpack_show()
      ) |>
      as_tibble() |>
      select(-"seasons", everything(), "seasons") |>
      mutate(seasons = map(.data[["seasons"]], as_tibble))

    # I think importing tidyr for this alone is worth it, because
    # A list structure this big and deeply nested is just wrong:
    # (response[[11]][[1]])[[2]][[1]][[2]]

    if (unnest_episodes) {
      if (!requireNamespace("tidyr", quietly = TRUE)) {
        stop("This functionality requires the tidyr package")
      }

      response <- as_tibble(response) |>
        tidyr::unnest(cols = "seasons") |>
        rename(season = "number") |>
        tidyr::unnest(cols = "episodes") |>
        rename(episode = "number") |>
        mutate(collected_at = ymd_hms(.data[["collected_at"]]))
    }
  } else if (type == "movies") {
    response <- unpack_movie(response)
  }

  fix_tibble_response(response)
}
