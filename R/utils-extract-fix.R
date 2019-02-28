# Unpackers ----

#' Unpack a standard show media object
#' This should work regardless of the value of `extended` to be sufficiently robust
#' @keywords internal
#' @noRd
#' @importFrom tibble as_tibble
#' @importFrom tibble has_name
#' @importFrom purrr modify_if
#' @importFrom dplyr select
#' @importFrom dplyr bind_cols
unpack_show <- function(show) {
  if (!inherits(show, "data.frame")) {
    stop("show should inherit from data.frame, but is class ", class(show))
  }

  # Convert, just in case
  show <- as_tibble(show)

  # Flatten "airs" (not present in minimal output)
  if (has_name(show, "airs")) {
    show      <- modify_in(show, "airs",
                                  ~modify_if(.x, is.null, ~return(NA_character_)))
    show$airs <- as_tibble(show$airs)

    names(show$airs) <- paste0("airs_", names(show$airs))

    show <- show %>%
      select(-airs) %>%
      cbind(show$airs) %>%
      as_tibble()
    # Note: Use cbind() over dplyr::bind_cols(): The latter complains about columns
    # that are data.frames. cbind() might be ever so slightly slower, but less picky.
  }

  show <- show %>%
    select(-ids) %>%
    bind_cols(fix_ids(show$ids)) %>%
    as_tibble() %>%
    fix_datetime()

  show
}

#' Unpack movie object
#' @keywords internal
#' @importFrom dplyr bind_cols
#' @noRd
unpack_movie <- function(response) {
  if (!tibble::has_name(response, "movie")) {
    return(response)
  }

  bind_cols(
    response %>% select(-movie),
    response$movie %>% select(-ids),
    response$movie$ids %>% fix_ids()
  ) %>%
    fix_datetime()
}


# Fixers ----

#' Set ratings to NA if votes == 0
#' @keywords internal
#' @importFrom dplyr if_else
#' @importFrom tibble has_name
#' @noRd
fix_ratings <- function(response) {
  if (!(has_name(response, "rating") & has_name(response, "votes"))) {
    # Robustness towards usage in extended = "min" context, means less if'ing
    return(response)
  }
  response$rating <- if_else(response$votes == 0, NA_real_, response$rating)
  response
}

#' Fix IDs object
#' Always return characters, replace NULL with explicit NA
#' @keywords internal
#' @importFrom purrr modify_if
#' @importFrom tibble has_name
#' @noRd
fix_ids <- function(ids) {
  if (!inherits(ids, c("data.frame", "list"))) {
    stop("ids must be list or data.frame")
  }

  # Since tvrage is dead and tvrage IDs tend to be NA/0,
  # I decided to drop them in general as they are basically just junk
  if (has_name(ids, "tvrage")) {
    ids["tvrage"] <- NULL
  }

  modify_if(ids, is.null, ~return(NA_character_), .else = as.character)

}

#' Quick datetime conversion
#'
#' Searches for datetime variables and converts them to `POSIXct` via \pkg{lubridate}.
#' @param response The input object. Must be `data.frame`(ish) or named `list`.
#' @return The same object with converted datetimes
#' @importFrom lubridate ymd_hms
#' @importFrom lubridate as_datetime
#' @importFrom dplyr mutate_at
#' @importFrom dplyr vars
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

  if (has_name(response, "released")) {
    response$released <- as_datetime(response$released)
  }

  if (inherits(response, "data.frame")) {
    response %>%
      mutate_at(.vars = vars(datevars), lubridate::ymd_hms)
  } else {
    map_at(response, datevars, lubridate::ymd_hms)
  }
}

# Unpack the ratings distribution my tibblurazing them
#' @keywords internal
#' @importFrom tibble enframe
#' @importFrom tibble has_name
fix_ratings_distribution <- function(response) {
  if (!has_name(response, "distribution")) {
    return(response)
  }

  response$distribution <- enframe(unlist(response$distribution),
                                           name = "rating", value = "n")
  response$distribution$rating <- as.integer(response$distribution$rating)
  response$distribution <- list(response$distribution)
  response
}

# Checkers ----

#' Check username
#'
#' @param user The username input.
#' @param validate `logical(1) [TRUE]`: Retrieve user profile to check if it exists.
#' @return An error if the checks fail or else `TRUE` invisibly. If `validate`, the
#' user profile is returned as a `list`.
#' @keywords internal
#' @importFrom httr stop_for_status
check_username <- function(user, validate = FALSE) {
  fail_option <- is.null(getOption("trakt.username"))
  fail_empty_chr <- user == ""
  fail_null <- is.null(user)
  fail_chr <- !is.character(user)
  fail_na <- is.na(user)

  failed <- any(fail_option, fail_empty_chr, fail_null, fail_chr, fail_na)

  if (failed) {
    stop("Supplied user must be a character string, you provided <",
         user, "> of class ", class(user))
  }

  if (validate) {
    url <- build_trakt_url("users", user)
    response <- trakt.api.call(url, HEAD = TRUE)
    if (!identical(response$status, 200L)) {
      stop_for_status(response$status)
    }
  }
  # Return TRUE if and only if everything else did not fail
  invisible(TRUE)
}

