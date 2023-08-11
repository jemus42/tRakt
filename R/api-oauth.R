#' Get a trakt.tv API OAuth token
#'
#' This is an unfortunately home-brewed version of what _should_ be a simple call to [`httr2::oauth_flow_device()`],
#' but since the <trakt.tv> API plays ever so slightly fast and mildly loose with RFC 8628, that's not possible.
#'
#' @note RFC 8628 expects the device token request to have the field "device_code",
#' but the trakt.tv API expects a field named "code". That's it. It's kind of silly.
#'
#' @param cache [`TRUE`]: Cache the token to the OS-specific cache directory. See [rappdirs::user_cache_dir()].
#'
#' @export
#' @importFrom rappdirs user_cache_dir
#' @importFrom cli cli_alert_info
#' @importFrom utils browseURL
#' @examples
#' if (FALSE) {
#'
#' get_token(cache = TRUE)
#'
#' }
#'
get_token <- function(cache = TRUE) {

  # Checking cache for a token first
  cache_loc <- file.path(rappdirs::user_cache_dir("tRakt"), "token.rds")
  if (file.exists(cache_loc)) {
    token <- readRDS(cache_loc)

    if (token_expired(token)) {
      token <- refresh_token(token)
      cache_token(token)
    }

    return(token)
  }

  # Getting a new token
  device_response <- httr2::request("https://api.trakt.tv/oauth/device/code") |>
    httr2::req_headers("Content-Type" = "application/json") |>
    httr2::req_body_json(data = list(client_id = get_client_id())) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  cli::cli_alert_info("Navigate to {.url {device_response$verification_url}} and enter {.strong {device_response$user_code}}")

  if (interactive()) {
    utils::browseURL(device_response$verification_url)
  }

  token <- oauth_device_token_poll(device_response)
  if (cache) cache_token(token)
  token
}

#' @keywords internal
#' @noRd
oauth_device_token_poll <- function(request) {
  cli::cli_progress_step("Waiting for response from server", spinner = TRUE)

  delay <- request$interval %||% 5
  deadline <- Sys.time() + request$expires_in

  token <- NULL
  while (Sys.time() < deadline) {
    for (i in 1:20) {
      cli::cli_progress_update()
      Sys.sleep(delay / 20)
    }

    token <- httr2::request("https://api.trakt.tv/oauth/device/token") |>
      httr2::req_headers("Content-Type" = "application/json") |>
      httr2::req_body_json(data = list(
        code = request$device_code,
        client_id = get_client_id(),
        client_secret = get_client_secret(),
        grant_type = "urn:ietf:params:oauth:grant-type:device_code"
      )) |>
      httr2::req_error(is_error = \(x) FALSE) |>
      httr2::req_perform()

    # 200: All good, got a token, can move on
    if (httr2::resp_status(token) == 200) break
    # 400: Pending, waiting for user to authorize, keep going
    # 429: Slow Down -- increase delay I guess
    if (httr2::resp_status(token) == 429) {
      delay <- delay + 5
    }

    # Everything else: Various failure modes
    # This feels inelegant but I think it gets the job down alright so meh
    reason <- switch(as.character(httr2::resp_status(token)),
      "404" = "Invalid device code, please check your credentials and try again",
      "409" = "Code was already used for authentication",
      "410" = "Token has expired, please try again (and maybe hurry up a little)",
      "418" = "Denied - user explicitly denied this code",
      NULL # fall through explicitly so we can conditionally abort
    )

    if (!is.null(reason)) rlang::abort(reason)

  }
  cli::cli_progress_done()

  if (is.null(token)) {
    cli::cli_alert_warning("Failed to get token, please retry.")
    return(NULL)
  }
  if (httr2::resp_status(token) != 200) {
    cli::cli_alert_warning("Failed to get token, please retry.")
    return(NULL)
  }

  token <- httr2::resp_body_json(token)
  class(token) <- "trakt_token"
  token
}


get_client_secret <- function() {

  env_var <- Sys.getenv("trakt_client_secret", unset = "")
  key_var <- Sys.getenv("tRakt_key", unset = "")

  if (env_var != "") return(env_var)

  if (key_var == "") {
    return(NULL)
  }

  httr2::secret_decrypt(tRakt_client_secret_scrambled, "tRakt_key")

}

get_client_id <- function() {
  env_var <- Sys.getenv("trakt_client_id", unset = "")
  if (nchar(env_var) == 64) return(env_var)

  tRakt_client_id
}

token_expired <- function(token) {
  Sys.time() >= as.POSIXct(token$created_at + token$expires_in)
}

cache_token <- function(token) {
  cache_loc <- file.path(getOption("tRakt_cache_dir"), "token.rds")

  if (!dir.exists(cache_dir)) dir.create(cache_dir)

  class(token) <- "trakt_token"

  saveRDS(token, file = cache_loc)
  invisible(token)
}

clear_cached_token <- function() {
  cache_loc <- file.path(getOption("tRakt_cache_dir"), "token.rds")
  file.remove(cache_loc)
}

#' @keywords internal
refresh_token <- function(token, cache = TRUE) {
  token <- httr2::request("https://api.trakt.tv/oauth/token") |>
    httr2::req_headers("Content-Type" = "application/json") |>
    httr2::req_body_json(data = list(
      refresh_token = token$refresh_token,
      client_id = get_client_id(),
      client_secret = get_client_secret(),
      grant_type = "refresh_token",
      redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
    )) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  if (cache) cache_token(token)
  token
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
