# VCR setup for API testing
# This file configures vcr for recording and replaying HTTP interactions

# Only set up vcr if it's installed
if (requireNamespace("vcr", quietly = TRUE)) {
	vcr::vcr_configure(
		dir = "_vcr",
		filter_sensitive_data = list(
			"<<<TRAKT_CLIENT_SECRET>>>" = Sys.getenv("trakt_client_secret", "")
		),
		filter_request_headers = list(
			"authorization"
		),
		match_requests_on = c("method", "uri")
		# NOTE: cassettes are intentionally *replay-only* on CI. We do not set
		# `re_record_interval`, so existing cassettes are never re-recorded
		# automatically (vcr's default "once" mode). Automated re-recording
		# coupled CI health to live API availability: whenever the cassettes
		# aged past the interval, every CI run made live calls and broke on any
		# upstream hiccup or drift. Re-record deliberately, locally, by deleting
		# the relevant cassette(s) under tests/testthat/_vcr/ and re-running the
		# tests with valid credentials.
	)
}
