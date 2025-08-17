#' @keywords internal
#'
#' @section Package options:
#'
#' * `tRakt_debug`: `logical(1)`: Should debug output be enabled? Default is `FALSE`.
#' * `tRakt_cache_dir`: `character(1)`: Where should the cache be stored?
#' * `tRakt_cache_max_age`: `numeric(1)`: How long should the cache be kept, in seconds? Default is one week (604800 seconds).
#' * `tRakt_cache_max_size`: `numeric(1)`: How big should the cache be, in bytes? Default is 100MB (100 * 1000^2 bytes).
#'
#' All options can be overriden with environment variables of the same name.
#' See [tRakt_sitrep()] to view the current value of all options.
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom purrr list_rbind
#' @importFrom purrr map
#' @importFrom rlang .data
#' @importFrom tibble as_tibble
#' @importFrom tibble tibble
## usethis namespace: end
NULL


#' tRakt sitrep
#'
#' Get general information about set options and API credentaials.
#' @export
#' @examples
#' tRakt_sitrep()
tRakt_sitrep <- function() {
	debug <- getOption("tRakt_debug")
	cache_dir <- getOption("tRakt_cache_dir")
	cache_max_age <- getOption("tRakt_cache_max_age")
	cache_max_age_days <- cache_max_age / 60^2 / 24
	cache_max_size <- getOption("tRakt_cache_max_size")
	cache_max_size_mb <- cache_max_size / 1000^2

	can_auth <- can_device_auth()
	client_id <- get_client_id() |>
		stringr::str_trunc(width = 20, side = "right")
	has_key <- httr2::secret_has_key("tRakt_key")
	has_secret <- Sys.getenv("trakt_client_secret", unset = "") != ""

	cli::cli_h1("tRakt version {.val {utils::packageVersion('tRakt')}}")
	cli::cli_h2("General settings")
	ul <- cli::cli_ul()
	cli::cli_li("Debug output enabled: {.val {debug}}")
	cli::cli_end(ul)

	cli::cli_h2("Cache settings")
	ul <- cli::cli_ul()
	cli::cli_li("Debug output enabled: {.val {debug}}")
	cli::cli_li("Cache dir: {.val {cache_dir}}")
	cli::cli_li("Cache max age: {.val {cache_max_age}} ({.val {cache_max_age_days} days})")
	cli::cli_li("Cache max size: {.val {cache_max_size}} ({.val {cache_max_size_mb} MB})")
	cli::cli_end(ul)

	cli::cli_h2("API authentication")
	ul <- cli::cli_ul()
	cli::cli_li("Client ID: {.val {client_id}}")
	cli::cli_li("Has package key: {.val {has_key}}")
	cli::cli_li("Has manually set client secret: {.val {has_secret}}")
	cli::cli_li("Can perform device authentication: {.val {can_auth}}")
	cli::cli_end(ul)
}
