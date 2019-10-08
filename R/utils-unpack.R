#' Unpack user objects
#'
#' @param response_user Basically `response$user`
#'
#' @return A `tibble` with tidy user data.
#'   `name` is renamed to `user_name` due to duplication with e.g. list names,
#'   and `slug` is renamed to `user_slug` for the same reason.
#' @keywords internal
#' @noRd
#' @importFrom rlang has_name is_empty
#' @importFrom dplyr rename mutate_if
unpack_user <- function(response_user) {
  if (!inherits(response_user, what = "data.frame")) {
    stop("User object must be data.frame like")
  }

  if (is_empty(response_user)) {
    return(tibble())
  }

  # Flatten the tbl
  response_user <- cbind(response_user[names(response_user) != "ids"], response_user$ids)

  #  Extract avatars
  if (has_name(response_user, "images")) {
    response_user$avatar <- response_user$images$avatar$full
    response_user <- response_user[names(response_user) != "images"]
  }

  response_user %>%
    rename(user_name = "name", user_slug = "slug") %>%
    mutate_if(is.factor, as.character) %>%
    fix_tibble_response()
}

#' Unpack a standard show media object
#' This should work regardless of the value of `extended` to be sufficiently robust
#' @keywords internal
#' @noRd
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
      select(-"airs") %>%
      cbind(show$airs) %>%
      as_tibble()
    # Note: Use cbind() over dplyr::bind_cols(): The latter complains about columns
    # that are data.frames. cbind() might be ever so slightly slower, but less picky.
  }

  show <- show %>%
    select(-"ids") %>%
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
    response %>% select(-"movie"),
    response$movie %>% select(-"ids"),
    response$movie$ids %>% fix_ids()
  ) %>%
    fix_tibble_response()
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
              select(-"show")
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

#' Unpack people in media_people functions
#'
#' @keywords internal
#' @noRd
#' @importFrom purrr map_df
#' @importFrom rlang has_name is_empty
#' @importFrom dplyr bind_cols
#' @importFrom dplyr mutate select
unpack_people <- function(response) {

  if (is_empty(response)) {
    return(tibble())
  }

  # Flatten the data.frame
  if (has_name(response, "cast") & !is_empty(response$cast)) {
    response$cast$person[["images"]] <- NULL

    response$cast$person <- response$cast$person %>%
      select(-"ids") %>%
      cbind(fix_ids(response$cast$person$ids)) %>%
      fix_datetime() %>%
      as_tibble()

    response$cast <- response$cast %>%
      select(-"person") %>%
      cbind(response$cast$person) %>%
      as_tibble()
  }

  if (has_name(response, "crew") & !is_empty(response$crew)) {
    response$crew <- map_df(trakt_people_crew_sections, function(section) {
      response$crew[[section]]$person[["images"]] <- NULL

      if (!has_name(response$crew, section) | is_empty(response$crew[[section]])) {
        return(tibble())
      }

      response$crew[[section]]$person <- response$crew[[section]]$person %>%
        select(-"ids") %>%
        cbind(fix_ids(response$crew[[section]]$person$ids))

      response$crew[[section]] <- response$crew[[section]] %>%
        select(-"person") %>%
        cbind(response$crew[[section]]$person) %>%
        mutate(crew_type = section) %>%
        as_tibble() %>%
        fix_datetime()
    })
  }

  response
}

#' Unpack lists in list methods
#'
#' @param response As returned by [trakt_get].
#'
#' @keywords internal
#' @noRd
#' @return A [tibble()][tibble::tibble-package].
#' @importFrom rlang is_empty
#' @importFrom dplyr bind_cols select
#' @importFrom purrr pluck
unpack_lists <- function(response) {
  if (is_empty(response)) {
    return(tibble())
  }

  response %>%
    select(-"ids", -"user") %>%
    bind_cols(
      pluck(response, "ids") %>% fix_ids(),
      pluck(response, "user") %>% unpack_user()
    ) %>%
    fix_tibble_response()
}

#' Unpack comments in comment methods
#'
#' @param response As returned by [trakt_get].
#'
#' @keywords internal
#' @noRd
#' @return A [tibble()][tibble::tibble-package].
#' @importFrom rlang is_empty
#' @importFrom dplyr bind_cols
#' @importFrom purrr pluck discard
unpack_comments <- function(response) {

  if (is_empty(response)) {
    return(tibble())
  }

  response %>%
    discard(is.list) %>%
    as_tibble() %>%
    bind_cols(
      pluck(response, "user") %>%
        as_tibble() %>%
        unpack_user()
    ) %>%
    fix_tibble_response()
}

#' Generalized unpacker
#'
#' @param x A response object
#' @param type One of "movie", "show", "season", "episode", "person"
#'
#' @return A flat `tibble()`
#' @keywords internal
#' @noRd
#' @importFrom dplyr filter select bind_cols vars rename_at rename_all ends_with
#' @importFrom stringr str_c str_remove str_replace
#' @importFrom purrr pluck
flatten_media_object <- function(x, type) {
  x <- x %>%
    as_tibble() %>%
    filter(type == !!type)

  if (nrow(x) == 0) {
    return(tibble())
  }

  if (type == "show") {
    res <- pluck(x, "show") %>%
      unpack_show()
  } else if (type == "movie") {
    res <- bind_cols(
      pluck(x, "movie") %>% select(-"ids"),
      pluck(x, "movie", "ids") %>% fix_ids()
    )
  } else if (type == "season") {
    res <- bind_cols(
      pluck(x, "show") %>%
        unpack_show(),
      pluck(x, "season") %>%
        select(-"ids"),
      pluck(x, "season", "ids") %>%
        fix_ids() %>%
        rename_all(~ paste0("season_", .x))
    ) %>%
      rename(season = "number") %>%
      rename_at(vars(ends_with("1")), ~ {
        .x %>%
          str_remove("1$") %>%
          str_c("season_", .)
      })
  } else if (type == "episode") {
    res <- bind_cols(
      pluck(x, "show") %>% unpack_show(),
      pluck(x, "episode") %>%
        select(-ids) %>%
        rename(episode_title = "title"),
      pluck(x, "episode", "ids") %>%
        fix_ids() %>%
        rename_all(~ paste0("episode_", .x))
    ) %>%
      rename_at(vars(matches("number")), ~ {
        str_replace(.x, "number", "episode")
      }) %>%
      rename_at(vars(ends_with("1")), ~ {
        .x %>%
          str_remove("1$") %>%
          str_c("episode_", .)
      })
  } else if (type == "person") {
    res <- bind_cols(
      pluck(x, "person") %>% select(-"ids"),
      pluck(x, "person", "ids") %>% fix_ids()
    )
  }

  res %>%
    fix_datetime() %>%
    filter(!is.na(.data[["trakt"]])) %>%
    as_tibble()
}

#' Generalized unpacker for single items in _summary functions
#'
#' @param x A response object
#' @param type One of "movie", "show", "season", "episode", "person"
#'
#' @return A flat `tibble()`
#' @keywords internal
#' @noRd
#' @importFrom dplyr filter select bind_cols vars rename_at rename_all ends_with
#' @importFrom stringr str_c str_remove str_replace
#' @importFrom purrr modify_if discard pluck
flatten_single_media_object <- function(response, type) {

  if (is_empty(response)) {
    return(tibble())
  }

  if (type %in% c("movie", "movies")) {
    if (has_name(response, "movie")) {
      response <- pluck(response, "movie")
    }

    res <- response %>%
      modify_if(is.null, ~NA_character_) %>%
      discard(is.list) %>%
      list_merge(
        !!!(pluck(response, "ids") %>% fix_ids())
      ) %>%
      modify_if(~ length(.x) > 1, list)
  }

  if (type %in% c("show", "shows")) {
    if (has_name(response, "show")) {
      response <- pluck(response, "show")
    }

    res <- response %>%
      modify_if(is.null, ~NA_character_) %>%
      discard(is.list) %>%
      modify_if(~ length(.x) > 1, list)

    if (has_name(response, "airs")) {
      airs <- response %>%
        pluck("airs", .default = NULL) %>%
        set_names(~paste0("airs_", .x))

      res <- list_merge(res, !!!airs)
    }

    res <- res %>% list_merge(
      !!!(pluck(response, "ids") %>% fix_ids())
    )
  }

  if (type %in% c("episode", "episodes")) {
     res <- response %>%
      pluck("episode") %>%
      modify_if(is.null, ~NA_character_) %>%
      discard(is.list) %>%
      modify_if(~ length(.x) > 1, list) %>%
      list_merge(
        !!!(pluck(response, "episode", "ids") %>% fix_ids())
      ) %>%
      as_tibble() %>%
      rename(episode = "number") %>%
      rename_at(vars(-"season", -"episode"), ~paste0("episode_", .x))

     res <- bind_cols(
       flatten_single_media_object(response[["show"]], "show"),
       res
     )
  }

  if (type %in% c("season", "seasons")) {
    res <- response %>%
      pluck("season") %>%
      modify_if(is.null, ~NA_character_) %>%
      discard(is.list) %>%
      modify_if(~ length(.x) > 1, list) %>%
      list_merge(
        !!!(pluck(response, "season", "ids") %>% fix_ids())
      ) %>%
      as_tibble() %>%
      rename(season = "number") %>%
      rename_at(vars(-"season"), ~paste0("season_", .x))

    res <- bind_cols(
      flatten_single_media_object(response[["show"]], "show"),
      res
    )
  }


  res %>%
    fix_tibble_response()

}
