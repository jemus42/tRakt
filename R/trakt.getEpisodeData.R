#' Get a show's episode information
#'
#' \code{trakt.getEpisodeData} pulls detailed episode data.
#' Get details for a show's episodes, e.g. ratings, number of votes, 
#' airdates, urls, plot overviews…
#' @param target The \code{slug} or \code{tvdbid} of the show requested
#' @param show.episodes Show episodes dataset, normally provided by \link{initializeEpisodes}
#' @param apikey API-key used for the call. 
#' Defaults to \code{getOption("trakt.apikey")}
#' @param dropunaired If \code{TRUE}, episodes which have not aired yet are dropped.
#' @return A \code{data.frame} containing episode details
#' @export
#' @import plyr
#' @import httr
#' @note See \href{http://trakt.tv/api-docs/show-episode-summary}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' options(trakt.apikey = jsonlite::fromJSON("key.json")$apikey)
#' breakingbad.seasons  <- trakt.getSeasons("breaking-bad")
#' breakingbad.episodes <- initializeEpisodes(breakingbad.seasons)
#' breakingbad.episodes <- trakt.getEpisodeData("breaking-bad", breakingbad.episodes)
#' }

trakt.getEpisodeData <- function(target, show.episodes = NULL, apikey = getOption("trakt.apikey"), dropunaired = TRUE){
  if (is.null(show.episodes)){
    stop("No episode dataset provided, see ?trakt.getEpisodeData")
  }
  baseURL <- "http://api.trakt.tv/show/episode/summary.json/"
  # Making the API calls and storing the responses as parts of the episode set
  for (epnum in show.episodes$epnum){
    season     <- show.episodes$season[epnum]
    episode    <- show.episodes$episode[epnum]
    target.url <- paste0(baseURL, apikey, "/", target, "/", season, "/", episode)
    response   <- httr::GET(target.url)
    
    # If the episode couldn't be found, skip and delete row
    if (response$status == 400){
      warning(paste(content(response)$error, "in episode number", epnum))
      show.episodes <- show.episodes[show.episodes$epnum != epnum, ]
      next
    }
    
    apiout_text <- httr::content(response, as = "text", encoding = "UTF-8")
    response    <- jsonlite::fromJSON(apiout_text)
    
    show.episodes$title[epnum]          <- iconv(response$episode$title, "latin1", "UTF-8")
    show.episodes$url.trakt[epnum]      <- response$episode$url
    show.episodes$firstaired.utc[epnum] <- response$episode$first_aired_utc
    show.episodes$id.tvdb[epnum]        <- response$episode$tvdb_id
    show.episodes$rating[epnum]         <- response$episode$ratings$percentage
    show.episodes$votes[epnum]          <- response$episode$ratings$votes
    show.episodes$loved[epnum]          <- response$episode$ratings$loved
    show.episodes$hated[epnum]          <- response$episode$ratings$hated
    show.episodes$overview[epnum]       <- iconv(response$episode$overview, "latin1", "UTF-8")
  }
  
  if (is.null(show.episodes$id.tvdb)){
    warning("No episodes! Wut?")
    return(NULL)
  }
  show.episodes$firstaired.posix  <- as.POSIXct(show.episodes$firstaired.utc, 
                                                origin = lubridate::origin, tz = "UTC")
  show.episodes$firstaired.string <- format(show.episodes$firstaired.posix, "%F")  
  show.episodes$year              <- lubridate::year(show.episodes$firstaired.posix)
  
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
