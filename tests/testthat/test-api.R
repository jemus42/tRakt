test_that("Client ID is set without .Renviron", {
  # Save current settings for later
  username_pre <- Sys.getenv("trakt_username")
  client_id_pre <- Sys.getenv("trakt_client_id")

  client_id <- "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2"
  expect_message(trakt_credentials(silent = FALSE))

  Sys.setenv("trakt_client_id" = "")
  expect_failure(expect_message(trakt_credentials()))
  expect_equal(Sys.getenv("trakt_client_id"), client_id)

  expect_message(
    trakt_credentials(username = "arbitraryusername", silent = FALSE)
  )
  expect_equal(Sys.getenv("trakt_username"), "arbitraryusername")
  expect_message(trakt_credentials(client_id = client_id, silent = FALSE))

  # Restore previous settings
  Sys.setenv("trakt_username" = username_pre)
  Sys.setenv("trakt_client_id" = client_id_pre)
})

test_that("trakt_get can make API calls", {
  skip_on_cran()

  url <- "https://api.trakt.tv/shows/breaking-bad"
  result <- trakt_get(url)

  expect_is(result, "list")
  expect_message(trakt_get("https://example.com"))
})

test_that("authenticated requests work", {
  skip_if_no_auth()

  # Authenticated method, should return a list
  expect_is(trakt_get("users/settings"), class = "list")
})
