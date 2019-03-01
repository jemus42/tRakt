# nocov start

.onLoad <- function(...) {
  trakt_credentials()
}

# Please R CMD check
globalVariables(c("ids", "airs", "movie", "shows", "show", "episode", "number_abs",
                  "number", "seasons", "episodes", "collected_at", "."))

# The tRakt client id for this particular app
tRakt_client_id <- "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2"

# Useful global internal variables
trakt_people_crew_sections <- c("production", "art", "crew", "directing", "writing",
                   "sound", "camera", "costume & make-up", "visual effects")
# nocov end
