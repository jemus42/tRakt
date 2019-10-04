#' Get a single episode's details
#'
#' This retrieves a single episode. See [seasons_season] for a whole season, and
#' [seasons_summary] for (potentially) all episodes of a show.
#' @details
#' This function wraps [this API method](https://trakt.docs.apiary.io/#reference/episodes/summary)
#' with the endpoint `/shows/:id/seasons/episodes/:episode`.
#'
#' @inheritParams trakt_api_common_parameters
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @family show data
#' @importFrom dplyr select rename bind_cols mutate everything
#' @importFrom rlang has_name
#' @importFrom tibble as_tibble
#' @importFrom purrr map
#' @examples
#' # Get just this one episode with its ratings, votes, etc.
#' episodes_summary("breaking-bad", season = 1, episode = 1, extended = "full")
episodes_summary <- function(id, season = 1L, episode = 1L,
                             extended = c("min", "full")) {
  if (length(id) > 1) {
    return(map_df(id, ~ episodes_summary(.x, season, episode, extended = extended)))
  }

  if (length(season) > 1) {
    return(map_df(season, ~ episodes_summary(id, .x, episode, extended = extended)))
  }

  if (length(episode) > 1) {
    return(map_df(episode, ~ episodes_summary(id, season, .x, extended = extended)))
  }

  extended <- match.arg(extended)

  # Construct URL, make API call
  url <- build_trakt_url(
    "shows", id, "seasons", season, "episodes", episode,
    extended = extended
  )
  response <- trakt_get(url = url)

  if (has_name(response, "available_translations")) {
    response$available_translations <- list(response$available_translations)
  }

  response <- bind_cols(
    as_tibble(response[names(response) != "ids"]),
    as_tibble(fix_ids(response$ids))
  ) %>%
    rename(episode = number) %>%
    mutate(id = id) %>%
    select(id, everything())

  fix_tibble_response(response)
}
