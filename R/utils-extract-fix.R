# Unpackers ----

#' Unpack a standard show media object
#' This should work regardless of the value of `extended` to be sufficiently robust
#' @keywords internal
#' @noRd
#' @importFrom tibble as_tibble
#' @importFrom tibble has_name
#' @importFrom purrr modify_if
#' @importFrom purrr modify_in
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
    show <- modify_in(
      show, "airs",
      ~ modify_if(.x, is.null, ~ return(NA_character_))
    )
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
#' @importFrom dplyr select
#' @importFrom tibble has_name
#' @noRd
unpack_movie <- function(response) {
  if (!has_name(response, "movie")) {
    return(response)
  }

  bind_cols(
    response %>% select(-movie),
    response$movie %>% select(-ids),
    response$movie$ids %>% fix_ids()
  ) %>%
    fix_datetime()
}

#' Crew subsections
#' Unpacks production, art, crew, costume & make-up, directing,
#' writing, sound, and camera
#' @keywords internal
#' @noRd
#' @importFrom purrr map_df
#' @importFrom tibble has_name
#' @importFrom dplyr bind_cols
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @source <https://trakt.docs.apiary.io/#reference/people/shows> for crew sections
unpack_crew_sections <- function(crew, type) {
  if (type == "shows") {
    map_df(trakt_people_crew_sections, function(section) {
      if (has_name(crew, section)) {
        crew[[section]] <- crew[[section]]$show %>%
          unpack_show() %>%
          bind_cols(
            crew[[section]] %>%
              select(-show)
          ) %>%
          as_tibble() %>%
          mutate(crew_type = section)
      }

      crew[[section]]
    })
  } else if (type == "movies") {
    map_df(trakt_people_crew_sections, function(section) {
      if (has_name(crew, section)) {
        crew[[section]] <- crew[[section]] %>%
          unpack_movie() %>%
          as_tibble() %>%
          mutate(crew_type = section)
      }

      crew[[section]]
    })
  }
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

  modify_if(ids, is.null, ~ return(NA_character_), .else = as.character)
}

#' Quick datetime conversion
#'
#' Searches for datetime variables and converts them to `POSIXct` via \pkg{lubridate}.
#' @param response The input object. Must be `data.frame`(ish) or named `list`.
#' @return The same object with converted datetimes
#' @importFrom lubridate ymd_hms
#' @importFrom lubridate as_date
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
    response$released <- as_date(response$released)
  }
  if (has_name(response, "birthday")) {
    response$birthday <- as_date(response$birthday)
  }

  if (inherits(response, "data.frame")) {
    response %>%
      mutate_at(.vars = vars(datevars), ~{
        # Don't convert already POSIXct vars
        if (!(inherits(.x, "POSIXct"))) {
          ymd_hms(.x)
        } else {
          .x
        }
      })
  } else {
    map_at(response, datevars, ymd_hms)
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
  response %>%
    as_tibble() %>%
    fix_datetime() %>%
    fix_ratings() %>%
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

  fail_empty_chr <- identical(user, "")
  fail_null <- is.null(user)
  fail_chr <- !is.character(user)
  fail_na <- is.na(user)

  failed <- any(fail_empty_chr, fail_null, fail_chr, fail_na)

  if (failed) {
    stop(
      "Supplied user must be a non-empty character string, you provided <",
      user, "> of class '", class(user), "'"
    )
  }

  if (validate) {
    url <- build_trakt_url("users", user)
    response <- trakt_get(url, HEAD = TRUE)
    if (!identical(response$status, 200L)) {
      stop_for_status(response$status)
    }
  }
  # Return TRUE if and only if everything else did not fail
  invisible(TRUE)
}

#' Check filter arguments
#'
#' @param filter The username input.
#' @param filter_type The kind of filter.
#' @noRd
#' @importFrom purrr map_lgl
#' @importFrom purrr is_empty
#' @keywords internal
check_filter_arg <- function(filter,
                             filter_type = c(
                               "query", "years", "genres", "languages", "countries",
                               "runtimes", "ratings", "certifications", "networks", "status"
                             )) {
  filter_type <- match.arg(filter_type)

  # Empty in, empty out. Can't explain that.
  if (is_empty(filter) | identical(filter, "")) return(NULL)

  if (filter_type == "query") {
    filter <- as.character(filter)
  }
  if (filter_type == "years") {
    if (!(length(filter) %in% c(1, 2))) {
      warning("Filter 'years' must be of length 1 or 2, keeping only first two values")
      filter <- sort(filter[1:2])
    }

    filter <- as.integer(filter)

    if (any(map_lgl(filter, ~ {
      !(nchar(.x) == 4)
    }))) {
      warning("Filter 'years' must be 4-digit year, ignoring filter")
      filter <- NULL
    }

    if (length(filter) == 2) {
      filter <- paste0(sort(filter), collapse = "-")
    }
  }
  if (filter_type == "runtimes") {
    if (!(length(filter) %in% c(1, 2))) {
      warning("Filter 'runtimes' must be of length 1 or 2, keeping only first two values")
      filter <- filter[1:2]
    }

    filter <- as.integer(filter)

    if (length(filter) == 2) {
      filter <- paste0(filter, collapse = "-")
    }
  }
  if (filter_type == "ratings") {
    if (!(length(filter) %in% c(1, 2))) {
      warning("Filter 'ratings' must be of length 1 or 2, keeping only first two values")
      filter <- filter[1:2]
    }

    filter <- as.integer(filter)

    if (any(map_lgl(filter, ~ {
      filter >= 0 & filter <= 100
    }))) {
      warning("Filter 'ratings' must be between 0 and 100, ignoring filter")
      filter <- NULL
    }

    if (length(filter) == 2) {
      filter <- paste0(filter, collapse = "-")
    }
  }
  if (filter_type == "genres") {
    filter <- check_filter_arg_fixed(filter, filter_type, genres$slug)

  }
  if (filter_type == "languages") {
    filter <- check_filter_arg_fixed(filter, filter_type, languages$code)

  }
  if (filter_type == "countries") {
    filter <- check_filter_arg_fixed(filter, filter_type, countries$code)

  }
  if (filter_type == "certifications") {
    filter <- check_filter_arg_fixed(filter, filter_type, certifications$slug)

  }
  if (filter_type == "networks") {
    filter <- check_filter_arg_fixed(filter, filter_type, networks)
  }
  if (filter_type == "status") {
    status_ok <- c("returning series", "in production", "planned", "canceled", "ended")

    filter <- check_filter_arg_fixed(filter, filter_type, status_ok)
  }
  filter
}

#' The helper's helper
#' @keywords internal
#' @noRd
check_filter_arg_fixed <- function(filter, filter_type, filter_ok) {
  if (any(!(filter %in% filter_ok))) {
    warning(
      "Filter '", filter_type, "' includes unknown value, ignoring: '",
      paste0(unique(filter[!(filter %in% filter_ok)]), collapse = ", "), "'"
    )

    # Subset to the only elements allowed
    filter <- filter[filter %in% filter_ok]
  }
  paste0(unique(filter), collapse = ",")
}
