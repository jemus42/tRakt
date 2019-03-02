#' Get a season of a show
#'
#' `trakt.seasons.season` gets a season's full data.
#' Similar to [trakt.seasons.summary], but this function returns full data for
#' a single season, i.e. all the episodes of the season
#' @details
#' This function accesses [this API method](https://trakt.docs.apiary.io/#reference/seasons/season/get-single-season-for-a-show)
#' at the endpoint `/shows/:show_id/seasons/:season_num`.
#'
#' @inheritParams trakt_api_common_parameters
#' @param seasons `integer(1) [1L]`: The season(s) to get. Use 0 for special episodes.
#' @inheritParams trakt.seasons.summary
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @importFrom lubridate year
#' @importFrom purrr is_integer
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
#' @note If you want to quickly gather data of multiple seasons, see [trakt.get_all_episodes].
#' @family show data
#' @examples
#' \dontrun{
#' trakt.seasons.season("breaking-bad", 1)
#' }
trakt.seasons.season <- function(target, seasons = 1L, extended = c("min", "full")) {
  extended <- match.arg(extended)

  # Vectorize
  if (length(seasons) > 1) {
    return(map_df(seasons, ~trakt.seasons.season(target, .x, extended)))
  }

  # Basic sanity check
  # Do this after vectorization due to scalar ifs
  seasons <- suppressWarnings(as.integer(seasons))
  if (!is_integer(seasons) | seasons == 0) {
    stop("'seasons' cannot be coerced to non-negative integer: '", seasons, "'")
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", seasons, extended = extended)
  response <- trakt.api.call(url = url)

  # Reorganization
  names(response) <- sub("number", "episode", names(response))

  # Spreading out ids to get a flat data.frame
  response <- cbind(response[names(response) != "ids"], fix_ids(response$ids))

  response %>%
    fix_ratings() %>%
    as_tibble()
}

#' Get a show's season information
#'
#' Get details for a show's seasons, e.g. how many seasons there are and  how many epsiodes
#' each season has. With `episodes == TRUE` and `extended == "full"`, this function
#' is also suitable to retrieve all episode ratings for all seasons of a show with
#' just a single API call.
#' @details
#' This function wraps [this API method](https://trakt.docs.apiary.io/#reference/seasons/summary/get-all-seasons-for-a-show)
#' with the endpoint `/shows/:show_id/seasons`.
#' @inheritParams trakt_api_common_parameters
#' @param episodes `logical(1) [FALSE]`: If `TRUE`, all episodes for each season
#' are appended as a list-column, with the amount of variables depending on `extended`.
#' @param drop.specials `logical(1) [TRUE]`: Special episodes (season 0) are dropped
#' @param drop.unaired `logical(1) [TRUE]`: Seasons without aired episodes are dropped.
#' Only works if `extended` is `"full"`.
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @family show data
#' @importFrom dplyr select
#' @importFrom tibble has_name
#' @importFrom tibble as_tibble
#' @importFrom purrr set_names
#' @importFrom purrr map
#' @importFrom purrr map_df
#' @examples
#' \dontrun{
#' trakt.seasons.summary("breaking-bad", extended = "min")
#' trakt.seasons.summary("utopia", extended = "full", episodes = TRUE)
#' }
trakt.seasons.summary <- function(target, extended = c("min", "full"), episodes = FALSE,
                                  drop.specials = TRUE, drop.unaired = TRUE) {
  extended <- match.arg(extended)

  if (episodes) {
    extended <- paste0(extended, ",episodes")
  }

  if (length(target) > 1) {
    response <- map_df(target, function(t) {
      trakt.seasons.summary(
        target = t, extended = extended, episodes = episodes,
        drop.specials = drop.specials, drop.unaired = drop.unaired
      )
    })
    return(response)
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", extended = extended)
  response <- trakt.api.call(url = url)

  # Data cleanup
  if (drop.specials) {
    response <- response[response$number != 0, ]
  }
  if (drop.unaired & has_name(response, "aired_episodes")) {
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
        as_tibble() %>%
        fix_ratings() %>%
        set_names(., sub("number", "episode", names(.)))
    })
  }

  response %>%
    fix_ratings() %>%
    as_tibble()
}
