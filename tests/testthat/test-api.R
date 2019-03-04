context("API interaction")

test_that("Client ID is set without .Renviron", {
  client.id <- "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2"
  expect_message(trakt_credentials(silent = FALSE))

  Sys.setenv(trakt_client_id = "")
  expect_failure(expect_message(trakt_credentials()))
  expect_equal(getOption("trakt.client.id"), client.id)

  expect_message(
    trakt_credentials(username = "arbitraryusername", silent = FALSE)
  )
  expect_equal(getOption("trakt.username"), "arbitraryusername")
  expect_message(trakt_credentials(client.id = client.id, silent = FALSE))
})

test_that("trakt.api.call can make API calls", {
  skip_on_cran()

  url <- "https://api.trakt.tv/shows/breaking-bad"
  result <- trakt.api.call(url)

  expect_is(result, "list")
  expect_error(trakt.api.call("https://example.com"))
})
