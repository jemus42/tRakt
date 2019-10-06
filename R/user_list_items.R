#' Get a user's list's items
#'
#' @inheritParams trakt_api_common_parameters
#' @param list_id The list identifier, either `trakt` ID or `slug` of the list.
#'   Can be optained via the website (URL `slug`) or e.g. [user_lists].
#' @param type `character(1) [NULL]`: If not `NULL`, only items of that media type are
#' returned. Possible values are `"movie"`, `"show"`, `"season"`, `"episode"`, `"person"`.
#' @return A [tibble()][tibble::tibble-package].
#'
#' @export
#' @importFrom dplyr select one_of filter bind_cols arrange
#' @importFrom purrr map_df
#' @examples
#' \dontrun{
#' # A large list with various media types
#' user_list_items("sp1ti", list_id = "anime-winter-season-2018-2019", extended = "min")
#' }
user_list_items <- function(user = getOption("trakt_username"),
                            list_id, type = NULL,
                            extended = c("min", "full")) {

  check_username(user)

  type <- check_types(type, several.ok = TRUE)

  extended <- match.arg(extended)

  url <- build_trakt_url("users", user, "lists", list_id,
                         "items", type, extended = extended)
  response <- trakt_get(url)


  # What types are present in the list
  list_types <- unique(response$type)

  # Get the list "base" without media items
  list_base <- response %>%
    select(-one_of(list_types))

  # Row-bind the list base to the unpackaed media items
  map_df(list_types, ~{
      bind_cols(
        list_base %>%
          filter(type == .x),
        flatten_media_object(response, .x) %>%
          filter(!is.na(trakt))
      )
  }) %>%
    arrange(rank) %>%
    fix_tibble_response()

}

