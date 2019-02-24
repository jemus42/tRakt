#' Get a season of a show
#'
#' `trakt.seasons.season` pulls a season's full data.
#' Similar to \link{trakt.seasons.summary}, but this function returns full data for
#' a single season, i.e. all the episodes of the season.
#' See \href{http://docs.trakt.apiary.io/#introduction/extended-info}{the API docs} for possible values of
#' `extended` to customize output amount.
#' @inheritParams id_movie_show
#' @param seasons `integer(1) [1L]`: The season(s) to get. Use 0 for special episodes.
#' @inheritParams trakt.seasons.summary
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @importFrom lubridate year
#' @note See \href{http://docs.trakt.apiary.io/reference/seasons/season/get-single-season-for-a-show}{the trakt API docs for further info}.
#' If you want to quickly gather data of multiple seasons, see \link[tRakt]{trakt.get_all_episodes}
#' @family show data
#' @examples
#' \dontrun{
#' breakingbad.seasons <- trakt.seasons.season("breaking-bad", 1)
#' }
trakt.seasons.season <- function(target, seasons = 1L, extended = c("min", "full")) {
  extended <- match.arg(extended)

  # Vectorize
  if (length(seasons) > 1) {
    response <- purrr::map_df(seasons, function(s) {
      trakt.seasons.season(target, s, extended = extended)
    })
    return(response)
  }

  # Basic sanity check
  # Do this after vectorization due to scalar ifs
  seasons <- suppressWarnings(as.integer(seasons))
  if (seasons < 0 | is.na(seasons) | is.null(seasons)) {
    stop("'seasons' cannot be coerced to non-negative integer: '", seasons, "'")
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", target, "seasons", seasons, extended = extended)
  season <- trakt.api.call(url = url)

  # Reorganization
  names(season) <- sub("number", "episode_number", names(season))

  # Spreading out ids to get a flat data.frame
  season <- cbind(season[names(season) != "ids"], season$ids)

  # If full data is pulled, ehance the dataset a little
  if ("first_aired" %in% names(season)) {
    season$year <- lubridate::year(season$first_aired)
  }

  tibble::as_tibble(season)
}

#' Get a show's season information
#'
#' Get details for a show's seasons, e.g. how many seasons there are and  how many epsiodes
#' each season has.
#' @inheritParams id_movie_show
#' @inheritParams extended_info
#' @param drop.specials `logical(1) [TRUE]`: Special episodes (season 0) are dropped
#' @param drop.unaired `logical(1) [TRUE]`: Seasons without aired episodes are dropped.
#' Only works if `extended` is `"full"`.
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @family show data
#' @examples
#' \dontrun{
#' breakingbad.seasons <- trakt.seasons.summary("breaking-bad", extended = "min")
#' breakingbad.seasons.more <- trakt.seasons.summary("breaking-bad", extended = "full")
#' }
trakt.seasons.summary <- function(target, extended = c("min", "full"),
                                  drop.specials = TRUE, drop.unaired = TRUE) {
  extended <- match.arg(extended)

  if (length(target) > 1) {
    response <- purrr::map_df(target, function(t) {
      trakt.seasons.summary(
        target = t, extended = extended,
        drop.specials = drop.specials, drop.unaired = drop.unaired
      )
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
  names(seasons) <- sub("number", "season_number", names(seasons))
  # Flattening
  seasons <- cbind(seasons[names(seasons) != "ids"], seasons$ids)

  tibble::as_tibble(seasons)
}
