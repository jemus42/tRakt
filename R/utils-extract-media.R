#' Unpack a standard show media object
#'
#' This should work regardless of the value of `extended` to be sufficiently robust
#' @keywords internal
unpack_show <- function(show) {
  if (!inherits(show, "data.frame")) {
    stop("show should inherit from data.frame, but is class ", class(show))
  }

  show <- as_tibble(show)

  # FLatten IDs
  # Do not prefix IDs with "show" - that is only for finer-grained items like episodes
  show$ids <- map_df(show$ids, as.character)
  show <- cbind(show %>% select(-ids),
                show %>% dplyr::select(ids) %>% dplyr::pull(ids))
  show <- as_tibble(show)


  # Flatten "airs" (not present in minimal output)
  if (tibble::has_name(show, "airs")) {
    show      <- modify_in(show, "airs", ~modify_if(.x, is.null, ~return(NA_character_)))
    show$airs <- as_tibble(show$airs)

    names(show$airs) <- paste0("airs_", names(show$airs))

    show <- cbind(show %>% select(-airs),
                  show %>% select(airs) %>% pull(airs))
    show <- as_tibbl(show)
  }

  show
}
