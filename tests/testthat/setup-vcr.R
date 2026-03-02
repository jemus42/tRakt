# VCR setup for API testing
# This file configures vcr for recording and replaying HTTP interactions

# Only set up vcr if it's installed
if (requireNamespace("vcr", quietly = TRUE)) {
	# Re-record cassettes after 30 days to catch API changes
	re_record_interval <- 30 * 24 * 60 * 60 # 30 days in seconds

	vcr::vcr_configure(
		dir = vcr::vcr_test_path("fixtures"),
		filter_sensitive_data = list(
			"<<<TRAKT_CLIENT_SECRET>>>" = Sys.getenv("trakt_client_secret", "")
		),
		# Filter authorization headers that may contain tokens
		filter_request_headers = list(
			"authorization"
		),
		match_requests_on = c("method", "uri"),
		re_record_interval = re_record_interval
	)
}
