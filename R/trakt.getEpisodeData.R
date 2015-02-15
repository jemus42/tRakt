#' Get a show's episode information
#'
#' \code{trakt.getEpisodeData} pulls detailed episode data.
#' Get details for a show's episodes, e.g. ratings, number of votes, 
#' airdates, urls, plot overviews…
#' 
#' This is basically just an extension of \link[tRakt]{trakt.show.season}, which is used in 
#' this function to collect all the episode data.
#' If you only want the episode data for a single season anyway, \code{trakt.show.season}
#' is recommended.
#' @param target The \code{slug} of the show requested
#' @param season_nums Vector of season numbers, e.g. \code{c(1, 2)}
#' @param extended Defaults to \code{full,images} to get season posters. Can be 
#' \code{min}, \code{images}, \code{full}, \code{full,images}
#' @param dropunaired If \code{TRUE}, episodes which have not aired yet are dropped.
#' @return A \code{data.frame} containing episode details
#' @export
#' @import plyr
#' @import httr
#' @note This function is mainly for convenience.
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.episodes <- trakt.getEpisodeData("breaking-bad", c(1, 2, 3, 4, 5))
#' }

trakt.getEpisodeData <- function(target, season_nums, extended = "full", dropunaired = TRUE){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  # Bind variables later used to please R CMD CHECK
  episode <- NULL
  season  <- NULL
  rating  <- NULL
 
  for (s in season_nums){
    temp <- trakt.show.season(target, s, extended)
    
    if (!exists("episodes")){
      episodes <- temp
    } else {
      episodes <- rbind(temp, episodes)
    }
  }

  # Arrange appropriately
  episodes            <- plyr::arrange(episodes, season, episode)
  show.episodes       <- transform(episodes, epid = tRakt::pad(season, episode))
  show.episodes$epnum <- 1:(nrow(show.episodes))
  
  # Convert seasons to factors because ordering
  show.episodes$season <- factor(show.episodes$season, 
                                 levels = as.character(1:max(show.episodes$season)), 
                                 ordered = T)
  
  # Add z-scaled episode ratings, scale per season
  if (extended != "min"){
    show.episodes$zrating.season <- plyr::ddply(show.episodes, "season", 
                                                plyr::summarize, zrating.season = scale(rating))$zrating.season
    show.episodes$zrating.season <- as.numeric(show.episodes$zrating.season)
    
    # Drop episodes with a timestamp of 0, probably faulty data or unaired
    if (nrow(show.episodes[show.episodes$firstaired.posix != 0, ]) > 0){
      show.episodes <- show.episodes[show.episodes$firstaired.posix != 0, ]
    } else {
      warning("Data is probably faulty.")
    }
    
    if (dropunaired){
      show.episodes <- show.episodes[show.episodes$firstaired.posix <= lubridate::now(tzone = "UTC"), ]
    }
  }

  
  show.episodes$src  <- "Trakt.tv"
  
  return(show.episodes)
}
