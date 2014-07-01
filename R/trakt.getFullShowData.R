#' Get all the show data
#'
#' \code{trakt.getFullShowData} is a combination function of multiple
#' functions in this package. The idea is to easily execute all major functions
#' required to get a full show dataset.
#' 
#' It's assumed that \code{getOption("trakt.apikey")} is already set, otherwise
#' the function will stop and tell you to.
#' @param searchquery Keyword used for \link{trakt.search}. Optional.
#' @param tvdb_id Used if \code{searchquery} is not specified. Optional.
#' @param dropunaired If \code{TRUE}, episodes which have not aired yet are dropped.
#' @return A \code{list} containing multiple \code{lists} and \code{data.frames} with show info.
#' @export
#' @note This is primarily intended to be a convenience function for the case where you
#' really want all that data. If you're just derping around, maybe you should consider interactively
#' calling the other functions.
#' @examples
#' \dontrun{
#' options(trakt.apikey = jsonlite::fromJSON("key.json")$apikey)
#' breakingbad.seasons  <- trakt.getFullShowData("Breaking Bad")
#' }
#' 
trakt.getFullShowData <- function(searchquery = NULL, tvdb_id = NULL, dropunaired = TRUE){
  if (is.null(getOption("trakt.apikey"))){
    stop("No API key set! Use options(trakt.apikey = <you key>) to set it.")
  }
  show               <- list()
  if (!is.null(searchquery)){
    show$info        <- trakt.search(searchquery)
    tvdb_id          <- show$info$tvdb_id
  } else if (is.null(searchquery) & is.null(tvdb_id)){
    stop("You must provide either a search query or a TVDB ID")
  }
  show$summary         <- trakt.show.summary(tvdb_id)
  show$seasons         <- trakt.getSeasons(tvdb_id)
  show$episodes        <- initializeEpisodes(show$seasons)
  show$episodes        <- trakt.getEpisodeData(tvdb_id, show$episodes, dropunaired = dropunaired)
  show$seasons         <- plyr::join(show$seasons , plyr::ddply(show$episodes, .(season), plyr::summarize, 
                                                    avg.rating.season     = round(mean(rating), 1),
                                                    rating.sd             = sd(rating),
                                                    top.rating.episode    = max(rating),
                                                    lowest.rating.episode = min(rating)))
  show$seasons$season  <- factor(show$seasons$season, 
                                 levels = as.character(1:nrow(show$seasons)), ordered = T)
  show$episodes$series <- show$summary$title
  show$summary$tpulled <- lubridate::now(tzone = "UTC")
  
  return(show)
}
