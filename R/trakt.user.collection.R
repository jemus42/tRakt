#' Get a user's collected shows or movies
#'
#' `trakt.user.collection` retrieves a user's collected shows or movies.
#' It does not use OAuth2, so you can only get data for a user with a
#' public profile.
#' @param user Target user. Defaults to `getOption("trakt.username")`
#' @param type Either `shows` (default) or `movies`
#' @param unnest_episodes `logical(1) [FALSE]`: Unnests episode data using
#' `[tidyr](tidyr::unnest)` and returns one row per episode rather than one row per show.
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @note See [the trakt API docs for further info](http://docs.trakt.apiary.io/reference/users/collection/get-collection)
#' @family user data
#' @import dplyr
#' @importFrom lubridate ymd_hms
#' @examples
#' \dontrun{
#' myshows <- trakt.user.collection() # Defaults to your username if set
#' seans.movies <- trakt.user.collection(user = "sean", type = "movies")
#' }
trakt.user.collection <- function(user = getOption("trakt.username"),
                                  type = c("shows", "movies"),
                                  unnest_episodes = FALSE) {
  check_username(user)
  match.arg(type)
  if (length(type) > 1) type <- type[1]

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "collection", type)
  response <- trakt.api.call(url = url)

  if (type == "shows") {
    # Flatten out ids
    response$show <- cbind(response$show[names(response$show) != "ids"], response$show$ids)
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

      # Please R CMD check
      seasons <- number <- episodes <- collected_at <- NULL

      response <- tibble::as_tibble(response) %>%
        tidyr::unnest(seasons) %>%
        dplyr::rename(season_number = number) %>%
        tidyr::unnest(episodes) %>%
        dplyr::rename(episode_number = number) %>%
        dplyr::mutate(collected_at = lubridate::ymd_hms(collected_at))
    }
  } else if (type == "movies") {
    # Flatten out ids
    response$movie <- cbind(
      response$movie[names(response$movie) != "ids"],
      response$movie$ids
    )
    response <- cbind(response[names(response) != "movie"], response$movie)
  }
  # To be sure
  response <- convert_datetime(response)

  tibble::as_tibble(response)
}
