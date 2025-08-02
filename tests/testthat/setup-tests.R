skip_if_no_auth <- function() {
	if (!inherits(get_token(), "trakt_token")) {
		skip("No authentication available")
	}
}
