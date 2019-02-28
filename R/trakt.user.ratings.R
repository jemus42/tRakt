#' Get a user's ratings
#'
#' `trakt.user.ratings` retrieves a user's media ratings
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
    if (!(as.numeric(rating) %in% 1:10)) {
      stop("rating must be between 1 and 10")
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

  if (type == "episodes") {
    # Keep episode and show objects as separate list items
    # the result is still data.frame-ish enough and duplicate names
    # don't cause headaches that way. Not perfectly tidy, but tidy enough.™
     response$episode$ids <- fix_ids(response$episode$ids)
     response$episode <- dplyr::bind_cols(response$episode %>% select(-ids),
                                          response$episode$ids) %>%
       as_tibble() %>%
       rename(episode = number)
     response$show <- unpack_show(response$show)

  }
  tibble::as_tibble(response)
}
