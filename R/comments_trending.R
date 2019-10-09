#' Get trending, recent or recently updated comments
#'
#' @name comments_trending
#' @inheritParams user_comments
#' @inheritParams search_filters
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
#'
#' # Recently updated comments
#' comments_updates()
#' }
NULL

#' @describeIn comments_trending Get trending comments.
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

#' @describeIn comments_trending Get recently made comments.
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

#' @describeIn comments_trending Get recently updated comments.
#' @export
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
