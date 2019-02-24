#' Get a user's watched shows or movies
#'
#' `trakt.user.watched` retrieves a user's watched shows or movies.
#' It does not use OAuth2, so you can only get data for a user with a
#' **public profile**.
#'
#' If `type` is set to `shows.extended`, the resulting [tibble][tibble::tibble-package]
#' contains play stats for _every_ watched episode of _every_ show. Otherwise,
#' the returned [tibble][tibble::tibble-package] only contains play stats per show or movie respectively.
#'
#' @inheritParams user_param
#' @inheritParams type_shows_movies
#' @inheritParams extended_info
#' @param noseasons `logical(1) [TRUE]`: Only for `type = "show"`: Exclude detailed season
#' data from output. This is advisable if you do not need per-episode data and want to
#' be nice to the API.
#' @inherit return_tibble return
#' @export
#' @family user data
#' @importFrom dplyr bind_cols
#' @importFrom dplyr select_if
#' @importFrom dplyr pull
#' @examples
#' \dontrun{
#' myshows <- trakt.user.watched() # Defaults to your username if set
#'
#' # Use noseasons = TRUE to avoid receiving detailed season/episode data
#' seans.shows <- trakt.user.watched(user = "sean", noseasons = TRUE)
#' }
trakt.user.watched <- function(user = getOption("trakt.username"),
                               type = c("shows", "movies"),
                               extended = c("min", "full"),
                               noseasons = TRUE) {

  check_username(user)
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (noseasons) {
    extended = paste0(extended, ",noseasons")
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "watched", type, extended = extended)
  response <- trakt.api.call(url = url)
  response <- tibble::as_tibble(response)

  if (identical(response, tibble::tibble())) return(tibble::tibble())

  if (type == "shows") {
    # Unpack the show media object and bind it to the base tbl
    response <- dplyr::bind_cols(
      response %>% dplyr::select(-show),
      unpack_show(response$show)
    ) %>%
      dplyr::select(-dplyr::contains("seasons"),
                    dplyr::everything(),
                    dplyr::contains("seasons"))
    # This uses contains() because the seasons column might not exist
    # and this way I don't have to use an extra if statement to check "noseasons"
  }
  if (type == "movies") {
    response$movie$ids <- purrr::map_df(response$movie$ids, as.character)
    response$movie <- dplyr::bind_cols(response$movie %>% dplyr::select(-ids),
                                       response$movie %>% dplyr::select(ids) %>% dplyr::pull(ids))

    response <- dplyr::bind_cols(response %>% dplyr::select(-movie),
                                 response %>% dplyr::select(movie) %>% dplyr::pull(movie))
  }

  # To be sure
  response <- convert_datetime(response)
  tibble::as_tibble(response)
}
