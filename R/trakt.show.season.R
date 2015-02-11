#' Get a season of a show
#'
#' \code{trakt.show.season} pulls a season's full data.
#' Similar to \link{trakt.getSeasons}, but this function returns full data for
#' a single season, i.e. all the episodes of the season.
#' See \href{http://docs.trakt.apiary.io/#introduction/extended-info}{the API docs} for possible values of
#' \code{extended} to customize output amount.
#' @param target The \code{slug} of the show requested
#' @param seasons The season to get. Defaults to 1. Use 0 for special episodes.
#' @param extended Defaults to \code{full,images} to get season posters. Can be 
#' \code{min}, \code{images}, \code{full}, \code{full,images}
#' @return A \code{data.frame} containing all of a season's episodes
#' @export
#' @importFrom lubridate origin
#' @importFrom lubridate year
#' @note See \href{http://docs.trakt.apiary.io/reference/seasons/season/get-single-season-for-a-show}{the trakt API docs for further info}
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.seasons <- trakt.show.season("breaking-bad", 1)
#' }
trakt.show.season <- function(target, seasons = 1, extended = "min"){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }
  baseURL            <- "https://api-v2launch.trakt.tv/shows/"
  url                <- paste0(baseURL, "/", target, "/seasons/", seasons, "?extended=", extended)
  
  # Actual API call
  headers     <- getOption("trakt.headers")
  response    <- httr::GET(url, headers)
  httr::stop_for_status(response) # In case trakt fails
  season      <- httr::content(response, as = "text")
  season      <- jsonlite::fromJSON(season)
  
  # Catch unknown season error
  if (identical(season, list())){
    warning(paste("Season", seasons, "does not appear to exist"))
    return(NULL)
  }
  # Reorganization
  names(season) <- sub("number", "episode", names(season))
  
  # Spreading out ids to get a flat data.frame
  names(season$ids) <- paste0("id.", names(season$ids))
  season            <- cbind(subset(season, select = -ids), season$ids)
  
  # If full data is pulled, ehance the dataset a little
  if (extended %in% c("full", "full,images", "images,full")){
    season$firstaired.posix      <- as.POSIXct(season$first_aired, 
                                               origin = lubridate::origin, tz = "UTC")
    season$firstaired.string     <- format(season$firstaired.posix, "%F")  
    season$year                  <- lubridate::year(season$firstaired.posix)
    # Just in case, sub ' with ’
    season$overview              <- gsub("'", "’", season$overview)
  }
  return(season)
}
