# nocov start

.onLoad <- function(...) {
  get_trakt_credentials()
}

.onUnload <- function(...) {
  # CLean up options
  options(trakt.client.id = NULL)
  options(trakt.username = NULL)
}

# nocov end
