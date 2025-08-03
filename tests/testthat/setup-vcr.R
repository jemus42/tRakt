# VCR setup for API testing
# This file configures vcr for recording and replaying HTTP interactions

# Only set up vcr if it's installed
if (requireNamespace("vcr", quietly = TRUE)) {
	library(vcr)
	
	# Configure vcr
	vcr_configure(
		dir = vcr::vcr_test_path("fixtures"),
		write_disk_path = NULL,
		filter_sensitive_data = list(
			# Filter out API keys from various headers
			"<<<TRAKT_API_KEY>>>" = Sys.getenv("TRAKT_CLIENT_ID", ""),
			"<<<BEARER_TOKEN>>>" = function(x) {
				gsub("Bearer [A-Za-z0-9._-]+", "Bearer <<<TOKEN>>>", x)
			}
		),
		# Don't record these headers as they may contain sensitive info
		filter_request_headers = c(
			"Authorization", 
			"X-API-Key", 
			"trakt-api-key",
			"trakt-api-version"
		),
		# Ensure cassettes have unique names
		warn_on_cassette_name_collision = TRUE
	)
	
	# Helper to check if we should use vcr
	use_vcr <- function() {
		# Don't use vcr if explicitly disabled
		if (tolower(Sys.getenv("VCR_TURN_OFF", "false")) == "true") {
			return(FALSE)
		}
		# Don't use vcr on CRAN by default
		if (!interactive() && tolower(Sys.getenv("NOT_CRAN", "true")) == "false") {
			return(FALSE)
		}
		return(TRUE)
	}
	
	# Custom test wrapper that conditionally uses vcr
	test_that_api <- function(desc, code, cassette_name = NULL) {
		if (is.null(cassette_name)) {
			# Generate cassette name from test description
			cassette_name <- gsub("[^a-zA-Z0-9_-]", "_", desc)
		}
		
		test_that(desc, {
			if (use_vcr()) {
				vcr::use_cassette(cassette_name, {
					eval(substitute(code))
				})
			} else {
				eval(substitute(code))
			}
		})
	}
} else {
	# If vcr is not available, create a simple wrapper
	test_that_api <- function(desc, code, cassette_name = NULL) {
		test_that(desc, code)
	}
	
	use_vcr <- function() FALSE
}