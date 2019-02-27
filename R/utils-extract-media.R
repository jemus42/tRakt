# Unpackers ----

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

  # Flatten "airs" (not present in minimal output)
  if (tibble::has_name(show, "airs")) {
    show      <- purrr::modify_in(show, "airs",
                                  ~purrr::modify_if(.x, is.null, ~return(NA_character_)))
    show$airs <- tibble::as_tibble(show$airs)

    names(show$airs) <- paste0("airs_", names(show$airs))

    show <- show %>%
      dplyr::select(-airs) %>%
      cbind(show$airs) %>%
      as_tibble()
    # Note: Use cbind() over dplyr::bind_cols(): The latter complains about columns
    # that are data.frames. cbind() might be ever so slightly slower, but less picky.
  }

  show <- show %>%
    dplyr::select(-ids) %>%
    dplyr::bind_cols(fix_ids(show$ids)) %>%
    as_tibble()

  show
}

# Fixers ----

#' Set ratings to NA if votes == 0
#' @keywords internal
#' @noRd
fix_ratings <- function(response) {
  if (!(tibble::has_name(response, "rating") & tibble::has_name(response, "votes"))) {
    stop("response must include both 'rating' and 'votes' variables")
  }
  response$rating <- dplyr::if_else(response$votes == 0, NA_real_, response$rating)
  response
}

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
