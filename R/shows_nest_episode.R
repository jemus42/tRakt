#' Get a shows next or latest episode
#'
#' @inheritParams trakt_api_common_parameters
#'
#' @inherit trakt_api_common_parameters return
#' @export
#' @eval apiurl("shows", "next episode")
#' @family show data
#' @family episode data
#' @importFrom dplyr bind_cols vars matches
#' @importFrom purrr discard modify_if modify_at pluck
#' @examples
#' shows_next_episode("one-piece")
#' shows_last_episode("one-piece")
shows_next_episode <- function(id, extended = c("min", "full")) {
  extended <- match.arg(extended)

  url <- build_trakt_url("shows", id, "next_episode", extended = extended)
  response <- trakt_get(url)

  response %>%
    discard(is.list) %>%
    modify_if(is.null, ~NA_character_) %>%
    modify_at(vars(matches("^available_translations$"), matches("^genres$")), list) %>%
    as_tibble() %>%
    bind_cols(
      pluck(response, "ids") %>% fix_ids()
    )
}

#' @rdname shows_next_episode
#' @eval apiurl("shows", "last episode")
#' @family show data
#' @family episode data
#' @export
shows_last_episode <- function(id, extended = c("min", "full")) {
  extended <- match.arg(extended)

  url <- build_trakt_url("shows", id, "last_episode", extended = extended)
  response <- trakt_get(url)

  response %>%
    discard(is.list) %>%
    modify_if(is.null, ~NA_character_) %>%
    modify_at(vars(matches("^available_translations$"), matches("^genres$")), list) %>%
    as_tibble() %>%
    bind_cols(
      pluck(response, "ids") %>% fix_ids()
    )
}
