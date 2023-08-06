#' Set ratings to NA if votes == 0
#' @keywords internal
#' @importFrom dplyr if_else
#' @importFrom rlang has_name
#' @noRd
fix_ratings <- function(response) {
  if (!(has_name(response, "rating") && has_name(response, "votes"))) {
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
#' @importFrom rlang has_name
#' @noRd
fix_ids <- function(ids) {
  if (!inherits(ids, c("data.frame", "list"))) {
    stop("IDs must be list or data.frame")
  }

  # Since tvrage is dead and tvrage IDs tend to be NA/0,
  # I decided to drop them in general as they are basically just junk
  if (has_name(ids, "tvrage")) {
    ids["tvrage"] <- NULL
  }

  modify_if(ids, is.null, ~NA_character_, .else = as.character)
}

#' Quick datetime conversion
#'
#' Searches for datetime variables and converts them to `POSIXct` via \pkg{lubridate}.
#' @param response The input object. Must be `data.frame`(ish) or named `list`.
#' @return The same object with converted datetimes
#' @importFrom lubridate ymd_hms
#' @importFrom lubridate as_date
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom tidyselect any_of
#' @importFrom purrr map_at
#' @importFrom rlang has_name
#' @keywords internal
#' @noRd
fix_datetime <- function(response) {
  if (!inherits(response, c("data.frame", "list"))) {
    stop("Object type not supported, must inherit from data.frame or list")
  }
  datevars <- c(
    "first_aired", "updated_at", "listed_at", "last_watched_at", "last_updated_at",
    "last_collected_at", "rated_at", "friends_at", "followed_at", "collected_at",
    "joined_at", "watched_at",
    "created_at"
  )

  datevars <- datevars[datevars %in% names(response)]

  if (has_name(response, "released")) {
    response$released <- as_date(response$released)
  }
  if (has_name(response, "birthday")) {
    response$birthday <- as_date(response$birthday)
  }

  if (inherits(response, "data.frame")) {
    response |>
      mutate(across(any_of(datevars), ~ {
        # Don't convert already POSIXct vars
        if (!(inherits(.x, "POSIXct"))) {
          ymd_hms(.x)
        } else {
          .x
        }
      }))
  } else {
    map_at(response, datevars, ymd_hms)
  }
}

# Unpack the ratings distribution my tibblurazing them
#' @keywords internal
#' @importFrom tibble enframe
#' @importFrom rlang has_name
fix_ratings_distribution <- function(response) {
  if (!has_name(response, "distribution")) {
    return(response)
  }

  response$distribution <- enframe(unlist(response$distribution),
    name = "rating", value = "n"
  )
  response$distribution$rating <- as.integer(response$distribution$rating)
  response$distribution <- list(response$distribution)
  response
}

#' Fix a tibble for final output
#' @keywords internal
#' @noRd
#' @importFrom tibble as_tibble
#' @importFrom tibble remove_rownames
fix_tibble_response <- function(response) {
  response |>
    as_tibble() |>
    fix_datetime() |>
    fix_ratings() |>
    remove_rownames()
}

#' Replace "" and NULL with explicit NAs
#' @importFrom dplyr if_else
#' @importFrom purrr map_chr
#' @keywords internal
#' @noRd
#' @note Currently only for [character()] variables. Because this might nuke classes.
fix_missing <- function(x) {
  if (inherits(x, "character")) {
    x <- map_chr(x, ~ if_else(identical(.x, ""), NA_character_, .x))
  }
  x
}
