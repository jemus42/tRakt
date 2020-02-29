#' Get a season of a show
#'
#' Similar to [seasons_summary], but this function returns full data for
#' a single season, i.e. all the episodes of the season
#' @inheritParams trakt_api_common_parameters
#' @param seasons `integer(1) [1L]`: The season(s) to get. Use `0` for specials.
#' @inheritParams seasons_summary
#' @inherit trakt_api_common_parameters return
#' @export
#' @importFrom lubridate year
#' @importFrom rlang is_integerish
#' @importFrom purrr is_integer
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
#' @note If you want to quickly gather episode data of all available seasons,
#' see [seasons_summary] and use the `episodes = TRUE` parameter.
#' @family season data
#' @family episode data
#' @eval apiurl("seasons", "season")
#' @examples
#' \dontrun{
#' seasons_season("breaking-bad", 1)
#'
#' # Including all episode data:
#' seasons_season("breaking-bad", 1, extended = "full")
#' }
seasons_season <- function(id, seasons = 1L, extended = c("min", "full")) {
  extended <- match.arg(extended)

  # Vectorize
  if (length(seasons) > 1) {
    return(map_df(seasons, ~ seasons_season(id, .x, extended)))
  }

  # Basic sanity check
  # Do this after vectorization due to scalar ifs
  if (!rlang::is_integerish(seasons)) {
    stop("'seasons' cannot be coerced to integer: '", seasons, "'")
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", id, "seasons", seasons, extended = extended)
  response <- trakt_get(url = url)

  if (identical(response, tibble())) {
    return(tibble())
  }

  response <- response %>%
    select(-"ids") %>%
    cbind(fix_ids(response$ids)) %>%
    fix_tibble_response() %>%
    rename(episode = "number")

  if (has_name(response, "number_abs")) {
    response <- response %>%
      rename(episode_abs = "number_abs")
  }

  response
}
