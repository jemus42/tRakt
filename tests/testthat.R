library(testthat)
library(purrr)
library(tRakt)

skip_if_no_auth <- function() {
  if (identical(Sys.getenv("trakt_client_secret"), "")) {
    skip("No authentication available")
  }
}

test_check("tRakt")
