# nocov start

.onLoad <- function(...) {
  trakt_credentials()
}

# Please R CMD check
globalVariables(c("ids", "airs", "movie", "shows", "show",
                  "number", "seasons", "episodes", "collected_at"))

# nocov end
