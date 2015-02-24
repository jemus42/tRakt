#' Get a season of a show
#'
#' \code{trakt.show.season} pulls a season's full data.
#' Similar to \link{trakt.getSeasons}, but this function returns full data for
#' a single season, i.e. all the episodes of the season.
#' See \href{http://docs.trakt.apiary.io/#introduction/extended-info}{the API docs} for possible values of
#' \code{extended} to customize output amount.
#' @param target The \code{id} of the show requested. Either the \code{slug}
#' (e.g. \code{"game-of-thrones"}), \code{trakt id} or \code{IMDb id}
#' @param seasons The season to get. Defaults to 1. Use 0 for special episodes.
#' @param extended Defaults to \code{full,images} to get season posters. Can be
#' \code{min}, \code{images}, \code{full}, \code{full,images}
#' @return A \code{data.frame} containing all of a season's episodes
#' @export
#' @importFrom lubridate origin
#' @importFrom lubridate year
#' @note See \href{http://docs.trakt.apiary.io/reference/seasons/season/get-single-season-for-a-show}{the trakt API docs for further info}.
#' If you want to quickly gather data of multiple seasons, see \link[tRakt]{trakt.getEpisodeData}
#' @family show
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.seasons <- trakt.show.season("breaking-bad", 1)
#' }
trakt.show.season <- function(target, seasons = 1, extended = "full,images"){
  if (is.null(getOption("trakt.headers"))){
    stop("HTTP headers not set, see ?get_trakt_credentials")
  }

  if (length(seasons) > 1){
    warning("seasons must be of length 1, only first value will be used")
    season <- season[1]
  }

  # Please R CMD CHECK
  ids <- NULL

  # Construct URL
  baseURL <- "https://api-v2launch.trakt.tv/shows/"
  url     <- paste0(baseURL, "/", target, "/seasons/", seasons, "?extended=", extended)

  # Actual API call
  season  <- trakt.api.call(url = url)

  # Catch unknown season error
  if (identical(season, list())){
    warning(paste("Season", seasons, "does not appear to exist"))
    return(NULL)
  }
  # Reorganization
  names(season) <- sub("number", "episode", names(season))

  # Spreading out ids to get a flat data.frame
  season        <- cbind(subset(season, select = -ids), season$ids)

  # If full data is pulled, ehance the dataset a little
  if (extended %in% c("full", "full,images", "images,full")){
    season$first_aired        <- lubridate::parse_date_time(season$first_aired,
                                                           "%y-%m-%dT%H-%M-%S", truncated = 3)
    season$first_aired.string <- format(season$first_aired, "%F")
    season$year               <- lubridate::year(season$first_aired)
  }
  if ("updated_at" %in% names(season)){
    season$updated_at <- lubridate::parse_date_time(season$updated_at,
                                                    "%y-%m-%dT%H-%M-%S", truncated = 3)
  }
  return(season)
}
