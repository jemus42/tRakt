#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
#' @importFrom rlang .data
#' @importFrom tibble as_tibble
#' @importFrom tibble tibble
## usethis namespace: end
NULL


#' tRakt sitrep
#'
#' Get general information about set options and APi credentaials.
#'
#' Supported package-level options are:
#'
#' * `tRakt_debug`: `logical(1)`: Should debug output be enabled? Default is `FALSE`.
#' * `tRakt_cache_dir`: `character(1)`: Where should the cache be stored?
#' * `tRakt_cache_max_age`: `numeric(1)`: How long should the cache be kept, in seconds? Default is one week (604800 seconds).
#' * `tRakt_cache_max_size`: `numeric(1)`: How big should the cache be, in bytes? Default is 100MB (100 * 1000^2 bytes).
#'
#' All options can be overriden with environment variables of the same name.
#'
#' @export
#' @examples
#' tRakt_sitrep()
tRakt_sitrep <- function() {
  debug <- getOption("tRakt_debug")
  cache_dir <- getOption("tRakt_cache_dir")
  cache_max_age <- getOption("tRakt_cache_max_age")
  cache_max_size <- getOption("tRakt_cache_max_size")
  can_auth <- can_device_auth()
  client_id <- get_client_id()

  cli::cli_h2("General settings")
  cli::cli_ul()
  cli::cli_li("Debug output enabled: {.val {debug}}")
  cli::cli_li("Cache dir: {.val {cache_dir}}")
  cli::cli_li("Cache max age: {.val {cache_max_age}}")
  cli::cli_li("Cache max size: {.val {cache_max_size}}")
  cli::cli_end()

  cli::cli_h2("API authentication")
  cli::cli_ul()
  cli::cli_li("Client ID: {.val {client_id}}")
  cli::cli_li("Can perform device authentication: {.val {can_auth}}")
  cli::cli_end()
}
