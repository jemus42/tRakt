#' Unpack a standard show media object
#'
#' This should work regardless of the value of `extended` to be sufficiently robust
#' @keywords internal
#' @import purrr
#' @import dplyr
unpack_show <- function(show) {
  if (!inherits(show, "data.frame")) {
    stop("show should inherit from data.frame, but is class ", class(show))
  }

  # Convert, just in case
  show <- tibble::as_tibble(show)

  # FLatten IDs
  # Do not prefix IDs with "show" - that is only for finer-grained items like episodes
  show$ids <- purrr::map_df(show$ids, as.character)
  show <- cbind(show %>% dplyr::select(-ids),
                fix_ids(show$ids))
  show <- tibble::as_tibble(show)


  # Flatten "airs" (not present in minimal output)
  if (tibble::has_name(show, "airs")) {
    show      <- purrr::modify_in(show, "airs",
                                  ~purrr::modify_if(.x, is.null, ~return(NA_character_)))
    show$airs <- tibble::as_tibble(show$airs)

    names(show$airs) <- paste0("airs_", names(show$airs))

    show <- cbind(show %>% dplyr::select(-airs),
                  show$airs)
    show <- tibble::as_tibble(show)
  }

  show
}
