#' Get a user's watched shows or movies
#'
#' For private users, an [authenticated request][trakt_credentials] is required.
#'
#' @inheritParams trakt_api_common_parameters
#' @param noseasons `logical(1) [TRUE]`: Only for `type = "show"`: Exclude detailed season
#' data from output. This is advisable if you do not need per-episode data and want to
#' be nice to the API.
#' @inherit trakt_api_common_parameters return
#' @export
#' @family user data
#' @eval apiurl("users", "watched")
#' @importFrom dplyr bind_cols select matches everything
#' @importFrom purrr pluck
#' @importFrom rlang is_empty
#' @examples
#' \dontrun{
#' # Use noseasons = TRUE to avoid receiving detailed season/episode data
#' user_watched(user = "sean", noseasons = TRUE)
#' }
user_watched <- function(user = getOption("trakt_username"),
                         type = c("shows", "movies"),
                         noseasons = TRUE,
                         extended = c("min", "full")) {
  check_username(user)
  type <- match.arg(type)
  extended <- match.arg(extended)

  if (extended == "min") {
    # extended = "min" causes weird output, expected result without param though
    extended <- ""
  }

  if (type == "shows" && noseasons) {
    extended <- paste0(extended, ",noseasons")
  }

  if (length(user) > 1) {
    names(user) <- user
    return(map_df(user, ~ user_watched(user = .x, type, noseasons), .id = "user"))
  }

  # Construct URL, make API call
  url <- build_trakt_url("users", user, "watched", type, extended = extended)
  response <- trakt_get(url = url)

  if (is_empty(response)) {
    return(tibble())
  }

  if (type == "shows") {
    # Unpack the show media object and bind it to the base tbl
    response <- response |>
      select(-"show") |>
      bind_cols(
        pluck(response, "show") |> unpack_show()
      ) |>
      select(
        -matches("^seasons$"),
        everything(),
        matches("^seasons$")
      )
    # This uses contains() because the seasons column might not exist
    # and this way I don't have to use an extra if-statement to check "noseasons == TRUE"
  } else if (type == "movies") {
    response <- unpack_movie(response)
  }

  fix_tibble_response(response)
}
