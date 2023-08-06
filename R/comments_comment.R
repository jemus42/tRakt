#' Get a single comment
#'
#' @inheritParams trakt_api_common_parameters
#' @eval apiurl("comments", "comment")
#' @family comment methods
#' @family summary methods
#' @inherit trakt_api_common_parameters return
#' @export
#' @examples
#' # A single comment
#' comments_comment("236397")
#'
#' # Multiple comments
#' comments_comment(c("236397", "112561"))
comments_comment <- function(id, extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (length(id) > 1) {
    res <- map_df(id, ~ {
      comments_comment(.x, extended = extended)
    })
    return(res)
  }

  url <- build_trakt_url("comments", id, extended = extended)
  response <- trakt_get(url)

  unpack_comments(response)
}

#' @describeIn comments_comment Get a comment's replies
#' @export
#' @eval apiurl("comments", "replies")
#' @family comment methods
#' @examples
#' \dontrun{
#' comments_replies("236397")
#' }
comments_replies <- function(id, extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (length(id) > 1) {
    res <- map_df(id, ~ {
      comments_replies(.x, extended = extended)
    })
    return(res)
  }

  url <- build_trakt_url("comments", id, "replies", extended = extended)
  response <- trakt_get(url)

  unpack_comments(response)
}

#' @describeIn comments_comment Get users who liked a comment.
#' @export
#' @eval apiurl("comments", "likes")
#' @family comment methods
#' @importFrom purrr discard pluck
#' @importFrom dplyr bind_cols
#' @examples
#' \dontrun{
#' comments_likes("236397")
#' }
comments_likes <- function(id, extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (length(id) > 1) {
    res <- map_df(id, ~ {
      comments_likes(.x, extended = extended)
    })
    return(res)
  }

  url <- build_trakt_url("comments", id, "likes", extended = extended)
  response <- trakt_get(url)

  response |>
    discard(is.list) |>
    bind_cols(
      pluck(response, "user") |>
        unpack_user()
    ) |>
    fix_tibble_response()
}

#' @describeIn comments_comment Get the media item attached to the comment.
#' @export
#' @eval apiurl("comments", "item")
#' @family comment methods
#' @importFrom dplyr mutate select everything bind_cols
#' @importFrom purrr map_df pluck
#' @examples
#' \dontrun{
#' # A movie
#' comments_item("236397")
#' comments_item("236397", extended = "full")
#'
#' # A show
#' comments_item("120768")
#' comments_item("120768", extended = "full")
#'
#' # A season
#' comments_item("140265")
#' comments_item("140265", extended = "full")
#'
#' # An episode
#' comments_item("136632")
#' comments_item("136632", extended = "full")
#' }
comments_item <- function(id, extended = c("min", "full")) {
  extended <- match.arg(extended)

  if (length(id) > 1) {
    res <- map_df(id, ~ {
      comments_item(.x, extended = extended)
    })
    return(res)
  }

  url <- build_trakt_url("comments", id, "item", extended = extended)
  response <- trakt_get(url)

  item_type <- pluck(response, "type")

  response |>
    flatten_single_media_object(type = item_type) |>
    mutate(type = item_type) |>
    select("type", everything())
}
