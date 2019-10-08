#' Get a single comment
#'
#' @inheritParams trakt_api_common_parameters
#'
#' @return A [tibble()][tibble::tibble-package].
#' @export
#'
#' @examples
#' # A single comment
#' comments_summary("236397")
#'
#' # Multiple comments
#' comments_comment(c("236397", "112561"))
comments_comment <- function(id, extended = c("min", "full")) {

  extended <- match.arg(extended)

  if (length(id) > 1) {
    res <- map_df(id, ~{
      comments_comment(.x, extended = extended)
    })
    return(res)
  }

  url <- build_trakt_url("comments", id)
  response <- trakt_get(url)

  response %>%
    discard(is.list) %>%
    as_tibble() %>%
    bind_cols(
      pluck(response, "user") %>%
        as_tibble() %>%
        unpack_user()
    ) %>%
    fix_tibble_response()
}
