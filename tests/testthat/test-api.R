context("test-test-api")

test_that("Client ID is set without .Renviron", {
  expect_message(get_trakt_credentials(silent = FALSE))

  Sys.setenv(trakt_client_id = "")
  expect_message(get_trakt_credentials())
  expect_equal(
    getOption("trakt.client.id"),
    "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2"
  )
  expect_message(get_trakt_credentials(silent = TRUE))
  expect_is(getOption("trakt.headers"), "request")

  expect_message(
    get_trakt_credentials(username = "arbitraryusername", silent = FALSE)
  )
  expect_equal(getOption("trakt.username"), "arbitraryusername")
  expect_message(get_trakt_credentials(client.id = "something", silent = FALSE))

})

test_that("trakt.api.call can make API calls", {
  skip_on_cran()

  url <- "https://api-v2launch.trakt.tv/shows/breaking-bad?extended=min"
  result <- trakt.api.call(url)

  expect_is(result, "list")
  expect_error(trakt.api.call("https://example.com"))

  options("trakt.headers" = NULL)
  expect_error(trakt.api.call(url, headers = NULL))
})
