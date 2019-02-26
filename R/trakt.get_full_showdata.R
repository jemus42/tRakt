#' Get all the show data
#'
#' `trakt.get_full_showdata` is a combination function of multiple
#' functions in this package. The idea is to easily execute all major functions
#' required to get a full show dataset. This also uses `extended = "full"`, so
#' beware that this is going to retrieve *a lot* of data. Please be nice to the API.
#'
#' @param query Keyword used for \link{trakt.search}. Optional.
#' @param slug Used if `query` is not specified. Optional, but gives exact results.
#' @param drop.unaired If `TRUE`, episodes which have not aired yet are dropped.
#' @return A `list` containing multiple `lists` and `tibble`s with show info.
#' @export
#' @note This is primarily intended to be a convenience function for the
#' case where you really want all that data. Usually it is advisable to only
#' call the specific functions for the data you really need.
#' @family show data
#' @examples
#' \dontrun{
#' # Use the search within the function
#' breakingbad <- trakt.get_full_showdata("Breaking Bad")
#'
#' # Alternatively, us a slug for explicit results
#' breakingbad <- trakt.get_full_showdata(slug = "breaking-bad")
#' }
trakt.get_full_showdata <- function(query = NULL, slug = NULL, drop.unaired = TRUE) {

  # Construct show object
  show <- list()
  if (!is.null(query)) {
    info <- trakt.search(query, type = "show", n_results = 1, extended = "min")
    slug <- info$slug
  } else if (is.null(query) & is.null(slug)) {
    stop("You must provide either a search query or a trakt.tv slug")
  }
  show$summary <- trakt.shows.summary(slug, extended = "full")
  show$seasons <- trakt.seasons.summary(slug, extended = "full", drop.specials = TRUE)
  show$episodes <- trakt.get_all_episodes(slug, show$seasons$season,
    drop.unaired = drop.unaired, extended = "full"
  )

  show$episodes$show <- show$summary$title
  show$summary$retrieved_at <- lubridate::now(tzone = "UTC")

  show
}
