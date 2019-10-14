#' Get trending or recently made comments
#'
#' @name comments_trending
#' @eval apiurl("comments", "trending")
#' @family comment methods
#' @inheritParams user_comments
#' @inheritParams trakt_api_common_parameters
#' @inherit user_comments return
#' @export
#'
#' @examples
#' \dontrun{
#' # Trending reviews
#' comments_trending("reviews")
#'
#' # Recent shouts (short comments)
#' comments_recent("shouts")
#' }
NULL

#' @name comments_trending
#' @export
comments_trending <- function(comment_type = c("all", "reviews", "shouts"),
                              type = c(
                                "all", "movies", "shows", "seasons",
                                "episodes", "lists"
                              ),
                              include_replies = FALSE,
                              limit = 10L) {
  comment_type <- match.arg(comment_type)
  type <- match.arg(type)

  url <- build_trakt_url(
    "comments/trending", comment_type, type,
    include_replies = include_replies, limit = limit
  )
  response <- trakt_get(url = url)

  unpack_comments_multitype(response)
}

#' @name comments_trending
#' @eval apiurl("comments", "recent")
#' @family comment methods
#' @export
comments_recent <- function(comment_type = c("all", "reviews", "shouts"),
                            type = c(
                              "all", "movies", "shows", "seasons",
                              "episodes", "lists"
                            ),
                            include_replies = FALSE,
                            limit = 10L) {
  comment_type <- match.arg(comment_type)
  type <- match.arg(type)

  url <- build_trakt_url(
    "comments/recent", comment_type, type,
    include_replies = include_replies, limit = limit
  )
  response <- trakt_get(url = url)

  unpack_comments_multitype(response)
}

#' Get recently updated/edited comments
#'
#' @inheritParams user_comments
#' @inheritParams trakt_api_common_parameters
#' @inherit user_comments return
#' @export
#' @eval apiurl("comments", "updates")
#' @family comment methods
#' @export
#' @examples
#' # Recently updated comments
#' comments_updates()
comments_updates <- function(comment_type = c("all", "reviews", "shouts"),
                             type = c(
                               "all", "movies", "shows", "seasons",
                               "episodes", "lists"
                             ),
                             include_replies = FALSE,
                             limit = 10L) {
  comment_type <- match.arg(comment_type)
  type <- match.arg(type)

  url <- build_trakt_url(
    "comments/updates", comment_type, type,
    include_replies = include_replies, limit = limit
  )
  response <- trakt_get(url = url)

  unpack_comments_multitype(response)
}
