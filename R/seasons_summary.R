#' Get a show's seasons
#'
#' Get details for a show's seasons, e.g. how many seasons there are and  how many epsiodes
#' each season has. With `episodes == TRUE` and `extended == "full"`, this function
#' is also suitable to retrieve all episode data for all seasons of a show with
#' just a single API call.
#' @inheritParams trakt_api_common_parameters
#' @param episodes `logical(1) [FALSE]`: If `TRUE`, all episodes for each season
#' are appended as a list-column, with the amount of variables depending on `extended`.
#' @param drop_specials `logical(1) [TRUE]`: Special episodes (season 0) are dropped
#' @param drop_unaired `logical(1) [TRUE]`: Seasons without aired episodes are dropped.
#' Only works if `extended` is `"full"`.
#' @inherit trakt_api_common_parameters return
#' @export
#' @family season data
#' @family episode data
#' @family summary methods
#' @eval apiurl("seasons", "summary")
#' @importFrom dplyr select
#' @importFrom rlang has_name is_empty
#' @importFrom purrr map map_df
#' @importFrom dplyr rename
#' @examples
#' # Get just the season numbers and their IDs
#' seasons_summary("breaking-bad", extended = "min")
#' \dontrun{
#' # Get season numbers, ratings, votes, titles and other metadata as well as
#' # a list-column containing all episode data
#' seasons_summary("utopia", extended = "full", episodes = TRUE)
#' }
seasons_summary <- function(id, episodes = FALSE,
                            drop_specials = TRUE, drop_unaired = TRUE,
                            extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (length(id) > 1) {
    response <- map_df(id, ~ {
      seasons_summary(
        id = .x, extended = extended, episodes = episodes,
        drop_specials = drop_specials, drop_unaired = drop_unaired
      )
    })
    return(response)
  }

  if (episodes) {
    extended <- paste0(extended, ",episodes")
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", id, "seasons", extended = extended)
  response <- trakt_get(url = url)

  if (is_empty(response)) {
    return(tibble())
  }

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
        select(-"ids") %>%
        cbind(fix_ids(episodes$ids)) %>%
        fix_tibble_response() %>%
        rename(
          episode = "number",
          episode_abs = "number_abs" # Not sure if this renaming should be done
        )
    })
  }

  fix_tibble_response(response)
}
