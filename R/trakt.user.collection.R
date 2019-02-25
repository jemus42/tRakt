#' Get a user's collected shows or movies
#'
#' `trakt.user.collection` retrieves a user's collected shows or movies.
#' It does not use OAuth2, so you can only get data for a user with a
#' public profile.
#' @inheritParams trakt_api_common_parameters
#' @param unnest_episodes `logical(1) [FALSE]`: Unnests episode data using
#' `[tidyr](tidyr::unnest)` and returns one row per episode rather than one row per show.
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @family user data
#' @import dplyr
#' @importFrom lubridate ymd_hms
#' @examples
#' \dontrun{
#' seans.movies <- trakt.user.collection(user = "sean", type = "movies")
#' }
trakt.user.collection <- function(user = getOption("trakt.username"),
                                  type = c("shows", "movies"),
                                  unnest_episodes = FALSE) {
  check_username(user)
  type <- match.arg(type)

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "collection", type)
  response <- trakt.api.call(url = url)

  if (type == "shows") {
    # Flatten out ids
    response$show <- cbind(response$show[names(response$show) != "ids"], fix_ids(response$show$ids))
    names(response$show) <- paste0("show_", names(response$show))
    response <- cbind(response[names(response) != "show"], response$show)
    response <- dplyr::select(response, -seasons, dplyr::everything(), seasons)

    # I think importing tidyr for this alone is worth it, because
    # A list structure this big and deeply nested is just wrong:
    # (response[[11]][[1]])[[2]][[1]][[2]]

    if (unnest_episodes) {
      if (!requireNamespace("tidyr", quietly = TRUE)) {
        stop("This functionality requires the tidyr package")
      }

      response <- tibble::as_tibble(response) %>%
        tidyr::unnest(seasons) %>%
        dplyr::rename(season = number) %>%
        tidyr::unnest(episodes) %>%
        dplyr::rename(episode = number) %>%
        dplyr::mutate(collected_at = lubridate::ymd_hms(collected_at))
    }
  } else if (type == "movies") {
    # Flatten out ids
    response$movie <- cbind(
      response$movie[names(response$movie) != "ids"],
      fix_ids(response$movie$ids)
    )
    response <- cbind(response[names(response) != "movie"], response$movie)
  }
  # To be sure
  response <- convert_datetime(response)

  tibble::as_tibble(response)
}
