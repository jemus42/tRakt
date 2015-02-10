.onAttach <- function(...){
  packageStartupMessage("tRakt is currently under heavy development, so... be careful.")
  tRakt::get_trakt_credentials()
}

.onDetach <- function(...){
  options(trakt.client.secret = NULL)
  options(trakt.client.id     = NULL)
  options(trakt.apikey        = NULL)
  options(trakt.username      = NULL)
}
