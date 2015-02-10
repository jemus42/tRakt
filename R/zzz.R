.onAttach <- function(...) {
  packageStartupMessage("tRakt is currently under heavy development, so... be careful.")
  tRakt::get_trakt_credentials()
}
