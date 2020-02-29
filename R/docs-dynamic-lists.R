#' See which movies / shows are popular across various metrics
#'
#' According to the API docs, popularity is calculated based both on ratings
#' and the number of ratings (i.e., votes). Trending items are those being
#' watched right now, where items with the most users currently watching are
#' returned first. Anticipation is measured by the number of user-created lists
#' an items is part of while not being released yet.
#'
#' @name dynamic_lists
#' @keywords internal
#'
#' @section The Dynamic Lists on trakt.tv:
#'
#' These functions access the automatically updated lists provided by trakt.tv.
#' Each function comes in two flavors: Shows or movies. The following descriptions
#' are adapted directly from the
#' [API reference](https://trakt.docs.apiary.io/#reference/movies/popular/get-popular-movies).
#'
#' - [Popular][popular_media]: Popularity is calculated using the rating percentage and the number of
#' ratings.
#' - [Trending][trending_media]: Returns all movies/shows being watched right now.
#' Movies/shows with the most users are returned first.
#' - [Played][played_media]: Returns the most played (a single user can watch multiple times)
#' movies/shows in the specified time `period`.
#' - [Watched][watched_media]: Returns the most watched (unique users) movies/shows in the specified
#' time `period`.
#' - [Collected][collected_media]: Returns the most collected (unique users) movies/shows in the
#' specified time `period`.
#' - [Anticipated][anticipated_media]: Returns the most anticipated movies/shows based on the number of
#' lists a movie/show appears on.
#' - [Updates][updated_media]: Returns all movies/shows updated since the specified UTC `start_date`.
#' In this case, the upper bound for `limit` is 100.
#'
#' The functions for **Played**, **Watched**, **Collected** and **Played** each return
#' the same additional variables besides the media information: `watcher_count`,
#' `play_count`, `collected_count`, `collector_count`.
NULL
