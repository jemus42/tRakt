#' Get all the show data
#'
#' \code{trakt.getFullShowData} is a combination function of multiple
#' functions in this package. The idea is to easily execute all major functions
#' required to get a full show dataset.
#'
#' @param query Keyword used for \link{trakt.search}. Optional.
#' @param slug Used if \code{query} is not specified. Optional, but gives exact results.
#' @param dropunaired If \code{TRUE}, episodes which have not aired yet are dropped.
#' @return A \code{list} containing multiple \code{lists} and \code{data.frames} with show info.
#' @export
#' @note This is primarily intended to be a convenience function for the case where you
#' really want all that data. If you're just derping around, maybe you should consider interactively
#' calling the other functions.
#' @family show
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' # Use the search within the function
#' breakingbad <- trakt.getFullShowData("Breaking Bad")
#' # Alternatively, us a slug for explicit results
#' breakingbad <- trakt.getFullShowData(slug = "breaking-bad")
#' }
trakt.getFullShowData <- function(query = NULL, slug = NULL, dropunaired = TRUE){

  # Bind variables later used to please R CMD CHECK
  rating  <- NULL

  # Construct show object
  show        <- list()
  if (!is.null(query)){
    show$info <- trakt.search(query)
    slug      <- show$info$ids$slug
  } else if (is.null(query) & is.null(slug)){
    stop("You must provide either a search query or a trakt.tv slug")
  }
  show$summary  <- trakt.show.summary(slug, extended = "full")
  show$seasons  <- trakt.seasons.summary(slug, extended = "full", dropspecials = T)
  show$episodes <- trakt.getEpisodeData(slug, show$seasons$season,
                                        dropunaired = dropunaired, extended = "full")
  show$seasons  <- plyr::join(show$seasons , plyr::ddply(show$episodes, "season", plyr::summarize,
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
