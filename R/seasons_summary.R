#' Get a show's seasons
#'
#' Get details for a show's seasons, e.g. how many seasons there are and  how many epsiodes
#' each season has. With `episodes == TRUE` and `extended == "full"`, this function
#' is also suitable to retrieve all episode data for all seasons of a show with
#' just a single API call.
#' @details
#' This function wraps [this API method](https://trakt.docs.apiary.io/#reference/seasons/summary/)
#' with the endpoint `/shows/:show_id/seasons`.
#'
#' @inheritParams trakt_api_common_parameters
#' @param episodes `logical(1) [FALSE]`: If `TRUE`, all episodes for each season
#' are appended as a list-column, with the amount of variables depending on `extended`.
#' @param drop_specials `logical(1) [TRUE]`: Special episodes (season 0) are dropped
#' @param drop_unaired `logical(1) [TRUE]`: Seasons without aired episodes are dropped.
#' Only works if `extended` is `"full"`.
#' @return A [tibble()][tibble::tibble-package].
#' @export
#' @family show data
#' @importFrom dplyr select
#' @importFrom rlang has_name
#' @importFrom tibble as_tibble
#' @importFrom purrr set_names
#' @importFrom purrr map
#' @importFrom purrr map_df
#' @examples
#' # Get just the season numbers and their IDs
#' seasons_summary("breaking-bad", extended = "min")
#' \dontrun{
#' # Get season numbers, ratings, votes, titles and other metadata as well as
#' # a list-column containing all episode data
#' seasons_summary("utopia", extended = "full", episodes = TRUE)
#' }
seasons_summary <- function(target, extended = c("min", "full"), episodes = FALSE,
                            drop_specials = TRUE, drop_unaired = TRUE) {
  extended <- match.arg(extended)

  if (length(target) > 1) {
    response <- map_df(target, function(t) {
      seasons_summary(
        target = t, extended = extended, episodes = episodes,
        drop_specials = drop_specials, drop_unaired = drop_unaired
      )
    })
    return(response)
  }

  if (episodes) {
    extended <- paste0(extended, ",episodes")
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", extended = extended)
  response <- trakt_get(url = url)

  # Data cleanup
  if (drop_specials) {
    response <- response[response$number != 0, ]
  }
  if (drop_unaired & has_name(response, "aired_episodes")) {
    response <- response[response$aired_episodes > 0, ]
  }
  # Reorganization
  names(response) <- sub("number", "season", names(response))
  # Flattening
  response <- cbind(response[names(response) != "ids"], fix_ids(response$ids))

  # If episodes are included, clean them up as a tidy list-column
  if (has_name(response, "episodes")) {
    response$episodes <- map(response$episodes, function(episodes) {
      episodes %>%
        select(-ids) %>%
        cbind(fix_ids(episodes$ids)) %>%
        fix_tibble_response() %>%
        set_names(., sub("number", "episode", names(.)))
    })
  }

  fix_tibble_response(response)
}
