#' Get a user's ratings
#'
#' Retrieve a user's media ratings
#' @inheritParams trakt_api_common_parameters
#' @param rating `integer(1L)`: Rating to filter by. Can be `1` through `10`, default is `NULL`
#' @return A [tibble][tibble::tibble-package].
#' @export
#' @family user data
#' @examples
#' \dontrun{
#' trakt.user.ratings(user = "jemus42")
#' trakt.user.ratings(user = "jemus42", type = "movies")
#' }
trakt.user.ratings <- function(user = getOption("trakt.username"),
                               type = c("movies", "seasons", "shows", "episodes"),
                               rating = NULL, extended = c("min", "full")) {
  check_username(user)
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (!is.null(rating)) {
    if (!(as.integer(rating) %in% 1:10)) {
      stop("rating must be a whole number between 1 and 10")
    }
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "ratings", type, rating, extended = extended)
  response <- trakt.api.call(url = url)

  # Flattening
  if (type == "movies") {
    response <- unpack_movie(response)
  }

  if (type == "shows") {
    response <- response %>% select(-show) %>%
        dplyr::bind_cols(unpack_show(response$show))
  }

  if (type == "seasons") {
    # Also keeping seasons and show object separate, see comment below
    response$season <- dplyr::bind_cols(response$season %>% select(-ids),
                                         fix_ids(response$season$ids)) %>%
      as_tibble() %>%
      rename(season = number) %>%
      fix_datetime()

    response$show <- unpack_show(response$show)
  }

  if (type == "episodes") {
    # Keep episode and show objects as separate list-like items so
    # the result is still data.frame-ish enough and duplicate names
    # don't cause headaches that way. Not perfectly tidy, but tidy enough.
     response$episode <- dplyr::bind_cols(response$episode %>% select(-ids),
                                          fix_ids(response$episode$ids)) %>%
       as_tibble() %>%
       set_names(., sub("number", "episode", names(.)))

     response$show <- unpack_show(response$show)
  }
  tibble::as_tibble(response)
}
