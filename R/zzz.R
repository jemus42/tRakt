# nocov start
.onLoad <- function(...) {
  trakt_credentials()
}

#' The tRakt client ID for this particular app
#' @keywords internal
#' @noRd
tRakt_client_id <- "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2"

#' Useful global internal variables
#' Used in two functions. In case of changes, I want to only have to change it once.
#' @keywords internal
#' @noRd
trakt_people_crew_sections <- c(
  "production", "art", "crew", "directing", "writing",
  "sound", "camera", "costume & make-up", "visual effects"
)
# nocov end
