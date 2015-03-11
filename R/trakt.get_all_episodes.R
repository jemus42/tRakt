#' Get a show's episodes. All of them.
#'
#' \code{trakt.get_all_episodes} pulls detailed episode data.
#' Get details for a show's episodes, e.g. ratings, number of votes,
#' airdates, images, plot overviews…
#'
#' This is basically just an extension of \link[tRakt]{trakt.seasons.season}, which is used in
#' this function to collect all the episode data.
#' If you only want the episode data for a single season anyway, \code{trakt.seasons.season}
#' is recommended, yet this function makes some additions.
#' The use case of this function is to quickly gather episode data of all seasons of a show.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}.
#' @param season_nums Vector of season numbers, e.g. \code{c(1, 2)}. If \code{NULL}, all the seasons
#' are pulled by calling \link{trakt.seasons.summary} to determine the number of seasons. If a
#' vector of length 1 is supplied, it is extended to 1:season_nums.
#' @param extended Use \code{full,images} to get season posters. Can be
#' \code{min}, \code{images}, \code{full} (default), \code{full,images}.
#' @param dropunaired If \code{TRUE} (default), episodes which have not aired yet are dropped.
#' @return A \code{data.frame} containing episode details
#' @export
#' @import plyr
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
trakt.get_all_episodes <- function(target, season_nums = NULL, extended = "full", dropunaired = TRUE){

  if (is.null(season_nums)){
    show.seasons <- trakt.seasons.summary(target = target, extended = "full",
                                          dropspecials = TRUE, dropunaired = dropunaired)
    season_nums <- show.seasons$season
  } else if (length(season_nums) == 1){
    if (season_nums > 1) season_nums <- 1:season_nums
  }

  # Bind variables later used to please R CMD CHECK
  rating  <- NULL

  show.episodes <- trakt.seasons.season(target = target, seasons = season_nums, extended = extended)

  # Arrange appropriately
  show.episodes$epid  <- tRakt::pad(show.episodes$season, show.episodes$episode)
  show.episodes$epnum <- 1:(nrow(show.episodes))

  # Convert seasons to factors because ordering
  show.episodes$season <- factor(show.episodes$season,
                                 levels = as.character(1:max(show.episodes$season)),
                                 ordered = T)

  # Add z-scaled episode ratings, scale per season
  if (extended != "min"){
    show.episodes <- plyr::ddply(show.episodes, "season",
                                 transform, zrating.season = as.numeric(scale(rating)))

    # Drop episodes with a timestamp of 0, probably faulty data or unaired
    if (nrow(show.episodes[show.episodes$first_aired != 0, ]) > 0){
      show.episodes <- show.episodes[show.episodes$first_aired != 0, ]
    } else {
      warning("Data is probably faulty: Some first_aired values are 0")
    }

    if (dropunaired){
      show.episodes <- show.episodes[show.episodes$first_aired <= lubridate::now(tzone = "UTC"), ]
    }
    show.episodes <- show.episodes[!(is.na(show.episodes$first_aired)), ]
  }

  # A little extra cleanup
  if (!is.null(show.episodes$episode_abs)){
    if (all(is.na(show.episodes$episode_abs))){
      show.episodes$episode_abs <- show.episodes$epnum
    }
  }

  # Append source
  show.episodes$src  <- "trakt.tv"

  return(show.episodes)
}
