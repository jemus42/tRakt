# Unpackers ----
#' Unpack user objects
#'
#' @param response_user Basically `response$user`
#'
#' @return A `tibble` with tidy user data.
#'   `name` is renamed to `user_name` due to duplication with e.g. list names,
#'   and `slug` is renamed to `user_slug` for the same reason.
#' @keywords internal
#' @noRd
#' @importFrom rlang has_name
#' @importFrom dplyr rename
unpack_user <- function(response_user) {

  if (!inherits(response_user, what = "data.frame")) {
    stop("User object must be data.frame like")
  }

  # Flatten the tbl
  response_user <- cbind(response_user[names(response_user) != "ids"], response_user$ids)

  #  Extract avatars
  if (has_name(response_user, "images")) {
    response_user$avatar <- response_user$images$avatar$full
    response_user <- response_user[names(response_user) != "images"]
  }

  response_user %>%
    rename(user_name = name, user_slug = slug) %>%
    fix_tibble_response()
}

#' Unpack a standard show media object
#' This should work regardless of the value of `extended` to be sufficiently robust
#' @keywords internal
#' @noRd
#' @importFrom tibble as_tibble
#' @importFrom rlang has_name
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
#' @importFrom rlang has_name
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
#' @importFrom rlang has_name
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

#' Generalized unpacker
#'
#' @param x A response object
#' @param type One of "movie", "show", "season", "episode", "person"
#'
#' @return A flat `tibble()`
#' @keywords internal
#' @noRd
#' @importFrom dplyr pull filter select bind_cols
flatten_media_object <- function(x, type) {

  x <- x %>%
    as_tibble() %>%
    filter(type == !!type)

  if (nrow(x) == 0) {
    return(tibble)
  }

  if (type == "show") {
    res <- x %>%
      pull(show) %>%
      unpack_show()
  } else if (type == "movie") {
    res <- bind_cols(
      x$movie %>% select(-ids),
      x$movie$ids %>% fix_ids()
    )
  } else if (type == "season") {
    res <- bind_cols(
      x$season %>% select(-ids),
      x$season$ids %>% fix_ids()
    ) %>%
      rename(season = number)
  } else if (type == "episode") {
    res <- bind_cols(
      x$episode %>% select(-ids),
      x$episode$ids %>% fix_ids()
    ) %>%
      rename(episode = number)
  } else if (type == "person") {
    res <- bind_cols(
      x$person %>% select(-ids),
      x$person$ids %>% fix_ids()
    )

  }

  res %>%
    fix_datetime() %>%
    filter(!is.na(trakt)) %>%
    as_tibble()
}

# Fixers ----

#' Set ratings to NA if votes == 0
#' @keywords internal
#' @importFrom dplyr if_else
#' @importFrom rlang has_name
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
    response %>%
      mutate_at(.vars = vars(datevars), ~ {
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

#' Check types
#'
#' Allowed types vary, and both "movie" and "movies" etc. should be allowed.
#' This function normalizes plural forms to singulars and concatenates multiple
#' results if allowed
#' @param type `character(n)`: One or more types, e.g. `"movies"`.
#' @param several.ok `logical(1) [TRUE]`: Passed to [match.arg][base::match.arg].
#'
#' @return A `character` of length 1.
#' @keywords internal
#' @noRd
#' @importFrom dplyr case_when
check_types <- function(type, several.ok = TRUE) {

  if (is.null(type)) {
    return(NULL)
  }

  type <- case_when(
    type %in% c("movie", "movies") ~ "movie",
    type %in% c("show", "shows") ~ "show",
    type %in% c("episode", "episodes") ~ "episode",
    type %in% c("season", "seasons") ~ "season",
    type %in% c("person", "persons", "people") ~ "person",
    TRUE ~ ""
  )

  possible_types <- c("movie" , "show" , "season" , "episode" , "person")
  type <- match.arg(type, choices = possible_types, several.ok = several.ok)

  if (length(type) > 1) {
    type <- paste0(type, collapse = ",")
  }

  type
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
  if (is_empty(filter) | identical(filter, "")) {
    return(NULL)
  }

  if (filter_type == "query") {
    filter <- as.character(filter)
  }
  if (filter_type == "years") {
    if (!(length(filter) %in% c(1, 2))) {
      warning("'years' must be of length 1 or 2, keeping only first two values")
      filter <- sort(filter[1:2])
    }

    if (length(filter) == 2) {
      filter <- paste0(sort(filter), collapse = "-")
    }

    # Check if the filter is okay now
    if (grepl(x = filter, pattern = "(^\\d{4}-\\d{4}$)|(^\\d{4}$)")) {
      filter
    } else {
      warning("'years' must be interpretable as 4 digit year or range of 4-digit years")
    }
  }
  if (filter_type == "runtimes") {
    if (!(length(filter) %in% c(1, 2))) {
      warning("'runtimes' must be of length 1 or 2, keeping only first two values")
      filter <- filter[1:2]
    }

    if (length(filter) == 2) {
      filter <- paste0(sort(filter), collapse = "-")
    }

    # Check if the filter is okay now
    if (grepl(x = filter, pattern = "(^\\d+-\\d+$)|(^\\d+$)")) {
      filter
    } else {
      warning("'runtimes' must be interpretable as duration in minutes or range.")
    }
  }
  if (filter_type == "ratings") {
    if (!(length(filter) %in% c(1, 2))) {
      warning("'ratings' must be of length 1 or 2, keeping only first two values")
      filter <- filter[1:2]
    }

    filter <- as.integer(filter)

    if (any(map_lgl(filter, ~ {
      filter >= 0 & filter <= 100
    }))) {
      warning("'ratings' must be between 0 and 100, ignoring filter")
      filter <- NULL
    }

    if (length(filter) == 2) {
      filter <- paste0(filter, collapse = "-")
    }
  }
  if (filter_type == "genres") {
    filter <- check_filter_arg_fixed(
      filter, filter_type, tRakt::trakt_genres$slug
    )
  }
  if (filter_type == "languages") {
    filter <- check_filter_arg_fixed(
      filter, filter_type, tRakt::trakt_languages$code
    )
  }
  if (filter_type == "countries") {
    filter <- check_filter_arg_fixed(
      filter, filter_type, tRakt::trakt_countries$code
    )
  }
  if (filter_type == "certifications") {
    filter <- check_filter_arg_fixed(
      filter, filter_type, tRakt::trakt_certifications$slug
    )
  }
  if (filter_type == "networks") {
    filter <- check_filter_arg_fixed(
      filter, filter_type, tRakt::trakt_networks
    )
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
    warning(call. = FALSE,
      "'", filter_type, "' includes unknown value, ignoring: '",
      paste0(unique(filter[!(filter %in% filter_ok)]), collapse = ", "), "'"
    )

    # Subset to the only elements allowed
    filter <- filter[filter %in% filter_ok]
  }
  paste0(unique(filter), collapse = ",")
}
