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
    as_tibble() %>%
    fix_datetime()

  show
}

#' Unpack movie object
#' @keywords internal
#' @noRd
unpack_movie <- function(response) {
  if (!tibble::has_name(response, "movie")) {
    return(response)
  }

  dplyr::bind_cols(
    response %>% select(-movie),
    response$movie %>% select(-ids),
    response$movie$ids %>% fix_ids()
  ) %>%
    fix_datetime()
}


# Fixers ----

#' Set ratings to NA if votes == 0
#' @keywords internal
#' @noRd
fix_ratings <- function(response) {
  if (!(tibble::has_name(response, "rating") & tibble::has_name(response, "votes"))) {
    # Robustness towards usage in extended = "min" context, means less if'ing
    return(response)
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

#' Quick datetime conversion
#'
#' Searches for datetime variables and converts them to `POSIXct` via \pkg{lubridate}.
#' @param response The input object. Must be `data.frame`(ish) or named `list`.
#' @return The same object with converted datetimes
#' @importFrom lubridate ymd_hms
#' @importFrom dplyr mutate_at
#' @importFrom purrr map_at
#' @keywords internal
#' @noRd
fix_datetime <- function(response) {
  if (!inherits(response, c("data.frame", "list"))) {
    stop("Object type not supported, must inherit from data.frame or list")
  }
  datevars <- c(
    "first_aired", "updated_at", "listed_at", "last_watched_at", "last_updated_at",
    "last_collected_at", "rated_at", "friends_at", "followed_at", "collected_at",
    "joined_at", "watched_at"
  )

  datevars <- datevars[datevars %in% names(response)]

  if (tibble::has_name(response, "released")) {
    response$released <- lubridate::as_datetime(response$released)
  }

  if (inherits(response, "data.frame")) {
    response %>%
      dplyr::mutate_at(.vars = dplyr::vars(datevars), lubridate::ymd_hms)
  } else {
    purrr::map_at(response, datevars, lubridate::ymd_hms)
  }
}

# Unpack the ratings distribution my tibblurazing them
#' @keywords internal
fix_ratings_distribution <- function(response) {
  if (!tibble::has_name(response, "distribution")) {
    return(response)
  }

  response$distribution <- tibble::enframe(unlist(response$distribution),
                                           name = "rating", value = "n")
  response$distribution$rating <- as.integer(response$distribution$rating)
  response$distribution <- list(response$distribution)
  response
}
