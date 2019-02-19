#' Get a season of a show
#'
#' `trakt.seasons.season` pulls a season's full data.
#' Similar to \link{trakt.seasons.summary}, but this function returns full data for
#' a single season, i.e. all the episodes of the season.
#' See \href{http://docs.trakt.apiary.io/#introduction/extended-info}{the API docs} for possible values of
#' `extended` to customize output amount.
#' @param target The `id` of the show requested. Either the `slug`
#' (e.g. `"game-of-thrones"`), `trakt id` or `IMDb id`
#' @param seasons The season(s) to get. Defaults to 1. Use 0 for special episodes.
#' @param extended Use `full,images` to get season posters. Can be
#' `min` (default), `images`, `full`, `full,images`
#' @return A `data.frame` containing all of a season's episodes
#' @export
#' @importFrom lubridate origin
#' @importFrom lubridate year
#' @note See \href{http://docs.trakt.apiary.io/reference/seasons/season/get-single-season-for-a-show}{the trakt API docs for further info}.
#' If you want to quickly gather data of multiple seasons, see \link[tRakt]{trakt.get_all_episodes}
#' @family show data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.seasons <- trakt.seasons.season("breaking-bad", 1)
#' }
trakt.seasons.season <- function(target, seasons = 1, extended = "min") {
  if (length(seasons) > 1) {
    response <- purrr::map_df(seasons, function(s) {
      response <- trakt.seasons.season(target, s, extended = extended)
      return(response)
    })
    return(response)
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", seasons, extended = extended)
  season <- trakt.api.call(url = url)

  # Catch unknown season error
  if (identical(season, list())) {
    warning(paste("Season", seasons, " of ", target, "does not appear to exist"))
    return(NULL)
  }
  # Reorganization
  names(season) <- sub("number", "episode", names(season))

  # Spreading out ids to get a flat data.frame
  season <- cbind(season[names(season) != "ids"], season$ids)

  # If full data is pulled, ehance the dataset a little
  if ("first_aired" %in% names(season)) {
    season$year <- lubridate::year(season$first_aired)
  }
  if ("images" %in% names(season)) {
    names(season$images$screenshot) <- paste0("screenshot.", names(season$images$screenshot))
    season <- cbind(season[names(season) != "images"], season$images$screenshot)
  }

  return(season)
}

#' Get a show's season information
#'
#' `trakt.seasons.summary` pulls season data.
#' Get details for a show's seasons, e.g. how many seasons there are, how many epsiodes
#' each season has, and season posters.
#' See \href{http://docs.trakt.apiary.io/#introduction/extended-info}{the API docs} for possible values of
#' `extended` to customize output amount.
#' @param target The `id` of the show requested. Either the `slug`
#' (e.g. `"game-of-thrones"`), `trakt id` or `IMDb id`
#' @param extended Use `full,images` to get season posters. Can be
#' `min` (default), `images`, `full`, `full,images`
#' @param drop.specials If `TRUE` (default), special episodes (listed as 'season 0') are dropped
#' @param drop.unaired If `TRUE` (default), seasons with `aired_episodes == 0` are dropped.
#' Only works if `extended` is set to more than `min`.
#' @return A `data.frame` containing season details (nested in `list` objects)
#' @export
#' @note See \href{http://docs.trakt.apiary.io/reference/seasons/summary}{the trakt API docs}
#' for further info
#' @family show data
#' @examples
#' \dontrun{
#' get_trakt_credentials() # Set required API data/headers
#' breakingbad.seasons <- trakt.seasons.summary("breaking-bad", extended = "min")
#' }
trakt.seasons.summary <- function(target, extended = "min", drop.specials = TRUE, drop.unaired = TRUE) {
  if (length(target) > 1) {
    response <- purrr::map_df(target, function(t) {
      response <- trakt.seasons.summary(
        target = t, extended = extended,
        drop.specials = drop.specials, drop.unaired = drop.unaired
      )
      response$show <- t
      return(response)
    })
    return(response)
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", extended = extended)
  seasons <- trakt.api.call(url = url)

  # Data cleanup
  if (drop.specials) {
    seasons <- seasons[seasons$number != 0, ]
  }
  if (drop.unaired & "aired_episodes" %in% names(seasons)) {
    seasons <- seasons[seasons$aired_episodes > 0, ]
  }
  # Reorganization
  names(seasons) <- sub("number", "season", names(seasons))
  # Flattening
  seasons <- cbind(seasons[names(seasons) != "ids"], seasons$ids)
  if ("images" %in% names(seasons)) {
    names(seasons$images$poster) <- paste0("poster.", names(seasons$images$poster))
    seasons$images <- cbind(seasons$images[names(seasons$images) != "poster"], seasons$images$poster)
    names(seasons$images$thumb) <- paste0("thumb.", names(seasons$images$thumb))
    seasons$images <- cbind(seasons$images[names(seasons$images) != "thumb"], seasons$images$thumb)
    names(seasons$images) <- paste0("images.", names(seasons$images))
    seasons <- cbind(seasons[names(seasons) != "images"], seasons$images)
  }

  return(seasons)
}
