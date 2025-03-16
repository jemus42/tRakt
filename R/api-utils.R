#' Get the client secret from the environment
#'
#' Get's the client secrete either from the environment variable
#' `trakt_client_secret`, or from the environment variable `tRakt_key`,
#' which holds an encryption key to decrypt the packaged encrypted secret.
#' @keywords internal
#' @note See <https://httr2.r-lib.org/articles/wrapping-apis.html#package-keys-and-secrets>
get_client_secret <- function() {
  env_var <- Sys.getenv("trakt_client_secret", unset = "")
  key_var <- Sys.getenv("tRakt_key", unset = "")

  if (env_var != "") return(env_var)

  if (!httr2::secret_has_key("tRakt_key")) {
    return(NULL)
  }

  httr2::secret_decrypt(tRakt_client_secret_scrambled, "tRakt_key")
}

#' Get client ID
#'
#' Either get ID from env var `trakt_client_id`
#' or return stored client ID for package.
#' @keywords internal
get_client_id <- function() {
  env_var <- Sys.getenv("trakt_client_id", unset = "")
  if (nchar(env_var) == 64) return(env_var)

  tRakt_client_id
}

token_expired <- function(token) {
  Sys.time() >= as.POSIXct(token$created_at + token$expires_in)
}

cache_token <- function(token) {
  cache_dir <- getOption("tRakt_cache_dir")
  if (!dir.exists(cache_dir)) dir.create(cache_dir)

  class(token) <- "trakt_token"

  saveRDS(token, file = token_cache_loc())
  invisible(token)
}

clear_cached_token <- function() {
  file.remove(token_cache_loc())
}

token_cache_loc <- function() {
  file <- paste0(
    "token",
    get_client_id(),
    ".rds"
  )
  file.path(getOption("tRakt_cache_dir"), file)
}

get_cached_token <- function() {
  cache_loc <- token_cache_loc()
  if (file.exists(cache_loc)) {
    token <- readRDS(cache_loc)

    if (token_expired(token)) {
      token <- refresh_token(token)
      cache_token(token)
    }

    return(token)
  }
}

#' @importFrom cli cli_inform cli_alert_success cli_alert_danger
#' @noRd
#' @export
print.trakt_token <- function(x, ...) {
  created_at <- as.POSIXct(x$created_at)
  expires_in <- as.POSIXct(x$created_at + x$expires_in)

  valid <- expires_in > Sys.time()

  cli::cli_inform("{.url trakt.tv} token created {created_at}")
  if (valid) {
    cli::cli_alert_success("Valid until {expires_in}")
  } else {
    cli::cli_alert_danger("Expired since {expires_in}")
  }
}

can_device_auth <- function() {
  has_key = (httr2::secret_has_key("tRakt_key") ||
    Sys.getenv("trakt_client_secret", unset = "") != "")

  result <- has_key && interactive()
  if (getOption("tRakt_debug", default = FALSE)) {
    cli::cli_inform("Can't perform device authentication.")
    if (!has_key) cli::cli_inform("Missing client secret.")
    if (!interactive()) cli::cli_inform("Not interactive.")
  }
  result
}
