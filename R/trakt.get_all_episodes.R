#' Get a show's episodes. All of them.
#'
#' `trakt.get_all_episodes` pulls detailed episode data.
#' Get details for a show's episodes, e.g. ratings, number of votes,
#' airdates, images, plot overviews…
#'
#' This is basically just an extension of \link[tRakt]{trakt.seasons.season}, which is used in
#' this function to collect all the episode data.
#' If you only want the episode data for a single season anyway, `trakt.seasons.season`
#' is recommended, yet this function makes some additions.
#' The use case of this function is to quickly gather episode data of all seasons of a show.
#' @param target The `id` of the show requested. Either the `slug`
#' (e.g. `"game-of-thrones"`), `trakt id` or `IMDb id`.
#' @param season_nums Vector of season numbers, e.g. `c(1, 2)`. If `NULL`, all the seasons
#' are retrieved by calling \link{trakt.seasons.summary} to determine the number of seasons.
#' If a vector of length 1 (e.g. `5`) is supplied, it is extended to `seq_len(season_nums)`.
#' @param extended Use `full,images` to get season posters. Can be
#' `min`, `images`, `full` (default), `full,images`.
#' @param drop.unaired If `TRUE` (default), episodes which have not aired yet are dropped.
#' @param drop.translations `logical(1) [TRUE]`: Remove list-column containing country-
#' codes for available translation. This column is unlikely to be of interest and
#' therefore excluded by default.
#' @return A `data.frame` containing episode details
#' @export
#' @importFrom purrr map_df
#' @note This function is mainly for convenience.
#' @family show data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' # Manually specifiy seasons
#' breakingbad.episodes <- trakt.get_all_episodes("breaking-bad", season_nums = c(1, 2, 3, 4, 5))
#' # Get all the seasons
#' breakingbad.episodes <- trakt.get_all_episodes("breaking-bad")
#' # Get first to 3rd season
#' breakingbad.episodes <- trakt.get_all_episodes("breaking-bad", season_nums = 3)
#' }
trakt.get_all_episodes <- function(target, season_nums = NULL, extended = "full",
                                   drop.unaired = TRUE, drop.translations = TRUE) {
  if (length(target) > 1) {
    response <- purrr::map_df(target, function(t) {
      response <- trakt.get_all_episodes(
        target = t, season_nums = season_nums, extended = extended,
        drop.unaired = drop.unaired
      )
      response$show <- t
      return(response)
    })
    return(response)
  }
  if (is.null(season_nums)) {
    show.seasons <- trakt.seasons.summary(
      target = target, extended = extended,
      drop.specials = TRUE, drop.unaired = drop.unaired
    )
    season_nums <- show.seasons$season
  } else if (length(season_nums) == 1) {
    if (season_nums > 1) season_nums <- seq_len(season_nums)
  }

  # Bind variables later used to please R CMD CHECK
  utils::globalVariables("rating")

  show.episodes <- trakt.seasons.season(target = target, seasons = season_nums,
                                        extended = extended)

  # Arrange appropriately
  show.episodes$epid <- tRakt::pad(show.episodes$season, show.episodes$episode)
  show.episodes$epnum <- seq_len(nrow(show.episodes))

  # Convert seasons to factors because ordering
  # show.episodes$season <- factor(show.episodes$season,
  #   levels = as.character(1:max(show.episodes$season)),
  #   ordered = TRUE
  # )

  # Add things
  if (extended == "full") {
    # Drop episodes with a timestamp of 0, probably faulty data or unaired
    if (nrow(show.episodes[show.episodes$first_aired != 0, ]) > 0) {
      show.episodes <- show.episodes[show.episodes$first_aired != 0, ]
    } else {
      warning("Data is probably faulty: Some first_aired values are 0")
    }

    if (drop.unaired) {
      show.episodes <- show.episodes[show.episodes$first_aired <= lubridate::now(tzone = "UTC"), ]
    }

    if (drop.translations) {
      show.episodes <- show.episodes[names(show.episodes) != "available_translations"]
    }

    show.episodes <- show.episodes[!(is.na(show.episodes$first_aired)), ]
  }

  # A little extra cleanup
  if (!is.null(show.episodes$episode_abs)) {
    if (all(is.na(show.episodes$episode_abs))) {
      show.episodes$episode_abs <- show.episodes$epnum
    }
  }

  # Append source
  # show.episodes$src <- "trakt.tv"

  return(show.episodes)
}
