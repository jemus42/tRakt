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
                               rating = NULL) {
  check_username(user)
  type <- match.arg(type)

  if (!is.null(rating)) {
    if (!(as.numeric(rating) %in% 1:10)) {
      stop("rating must be between 1 and 10")
    }
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "ratings", type, rating)
  response <- trakt.api.call(url = url)

  # Flattening
  if (type == "movies") {
    response <- dplyr::bind_cols(
      response %>% select(-movie),
      response$movie %>% select(-ids),
      response$movie$ids %>% fix_ids()
    )
  }

  if (type == "shows") {
    response <- response %>% select(-show) %>%
        dplyr::bind_cols(unpack_show(response$show))
  }

  if (type == "episodes") {
     response$episode$ids <- fix_ids(response$episode$ids)
     response$episode <- dplyr::bind_cols(response$episode %>% select(-ids), response$episode$ids) %>%
       as_tibble() %>%
       rename(episode = number)
     response$show <- unpack_show(response$show)

  }
  tibble::as_tibble(response)
}
