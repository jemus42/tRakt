#' Get a show's episode information
#'
#' \code{trakt.getEpisodeData2} pulls detailed episode data (differently).
#' Get details for a show's episodes, e.g. ratings, number of votes, 
#' airdates, urls, plot overviews…
#' @param target The \code{slug} or \code{tvdbid} of the show requested
#' @param show.seasons Only used for the number of seasons.
#' @param apikey API-key used for the call. 
#' Defaults to \code{getOption("trakt.apikey")}
#' @param dropunaired If \code{TRUE}, episodes which have not aired yet are dropped.
#' @return A \code{data.frame} containing episode details
#' @export
#' @import plyr
#' @import httr
#' @note This function uses much less API calls than \link{trakt.getEpisodeData}.
#' @examples
#' \dontrun{
#' options(trakt.apikey = jsonlite::fromJSON("key.json")$apikey)
#' breakingbad.seasons  <- trakt.getSeasons("breaking-bad")
#' breakingbad.episodes <- trakt.getEpisodeData2("breaking-bad", breakingbad.seasons)
#' }

trakt.getEpisodeData2 <- function(target, show.seasons = NULL, apikey = getOption("trakt.apikey"), dropunaired = TRUE){
  if (is.null(show.seasons)){
    stop("No season dataset provided, see ?trakt.getEpisodeData2")
  }
 
  for (season in show.seasons$season){
    temp <- trakt.getSeason(target, season = season)
    
    if (!exists("episodes")){
      episodes <- temp
    } else {
      episodes <- rbind(temp, episodes)
    }
  }
  
  # Arrange appropriately
  episodes <- plyr::arrange(episodes, season, episode)
  show.episodes <- transform(episodes, epnum = paste0("s", pad(season), "e", pad(episode)))
  
  # Convert seasons to factors because ordering
  show.episodes$season           <- factor(show.episodes$season, 
                                           levels = as.character(1:max(show.episodes$season)), 
                                           ordered = T)
  # Add z-scaled episode ratings, scale per season
  show.episodes$zrating.season <- plyr::ddply(show.episodes, .(season), 
                                        plyr::summarize, zrating.season = scale(rating))$zrating.season
  show.episodes$zrating.season <- as.numeric(show.episodes$zrating.season)
  
  # Drop episodes with a timestamp of 0, probably faulty data or unaired
  if (nrow(show.episodes[show.episodes$firstaired.posix != 0, ]) > 0){
    show.episodes <- show.episodes[show.episodes$firstaired.posix != 0, ]
  } else {
    warning("Data is probably faulty.")
  }
  
  show.episodes$src  <- "Trakt.tv"
  
  if (dropunaired){
    show.episodes <- show.episodes[show.episodes$firstaired.posix <= lubridate::now(tzone = "UTC"), ]
  }
  return(show.episodes)
}
