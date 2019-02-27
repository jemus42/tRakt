#' Fix IDs object
#' Always return characters, replace NULL with explicit NA
#' @keywords internal
#' @noRd
fix_ids <- function(ids) {
  if (!inherits(ids, c("data.frame", "list"))) {
    stop("ids must be list or data.frame")
  }

  # Since tvrage is dead and tvrage IDs tend to be NA/0,
  # I decided to drop them in general as they are basically just junk
  if (tibble::has_name(ids, "tvrage")) {
    ids["tvrage"] <- NULL
  }

  purrr::modify_if(ids, is.null, ~return(NA_character_),
                   .else = as.character)

}

#' Unpack a standard show media object
#' This should work regardless of the value of `extended` to be sufficiently robust
#' @keywords internal
#' @noRd
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
