# nocov start
.onLoad <- function(libname, pkgname) {
  if (getOption("tRakt_cache_dir", default = "") == "") {
    options("tRakt_cache_dir" = rappdirs::user_cache_dir("tRakt"))
  }
  if (getOption("tRakt_debug", default = "") == "") {
    options("tRakt_debug" = FALSE)
  }
}

#' The tRakt client ID for this particular app
#' @keywords internal
#' @noRd
tRakt_client_id <- "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2"

#' The tRakt client secret for this particular app
#'
#' Decrypt with `httr2::secret_decrypt(client_secret_scrambled, "tRakt_key")`
#' Check availability of the key with with `httr2::secret_has_key("tRakt_key")`
#' @keywords internal
#' @noRd
tRakt_client_secret_scrambled <- "3WPkxM7csJKm_a4MP4NdDA1jhzQv6N91bNv4JhUXuDTSjqwXR9kZvg12rKtu6qqIuG2-pHfyYWFUGOTxSjiee08UVfhtswL7EdiFSwUTBI0"


#' Useful global internal variables
#' Used in two functions. In case of changes, I want to only have to change it once.
#' @keywords internal
#' @noRd
trakt_people_crew_sections <- c(
  "production",
  "art",
  "crew",
  "directing",
  "writing",
  "sound",
  "camera",
  "costume & make-up",
  "visual effects"
)

#' Trakt's rating labels
#'
#' These can be useful for labeling the numeric scale.
#' @keywords internal
#' @export
trakt_rating_labels <- c(
  `1` = "Weak Sauce :(",
  `2` = "Terrible",
  `3` = "Bad",
  `4` = "Poor",
  `5` = "Meh",
  `6` = "Fair",
  `7` = "Good",
  `8` = "Great",
  `9` = "Superb",
  `10` = "Totally Ninja!"
)

# nocov end
