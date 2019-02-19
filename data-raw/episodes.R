library(tRakt)
library(rvest)
library(dplyr)
library(magrittr)
library(stringr)
library(tidyr)

# Futurama ----
futurama <- tRakt::trakt.get_all_episodes("futurama")
usethis::use_data(futurama, overwrite = TRUE)


# Game of Thrones ----
got <- trakt.get_all_episodes("game-of-thrones") %>%
  rename(
    rating_trakt = rating,
    votes_trakt = votes
  )

# Wiki
"https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_episodes" %>%
  read_html() %>%
  html_table(fill = TRUE) %>%
  magrittr::extract(c(2:7)) %>%
  bind_rows() %>%
  set_colnames(c(
    "episode_abs", "episode", "title", "director",
    "writer", "firstaired", "viewers"
  )) %>%
  select(-firstaired) %>%
  mutate(
    viewers = str_replace_all(viewers, "\\[\\d+\\]", ""),
    viewers = as.numeric(viewers)
  ) %>%
  select(-episode, -title) %>%
  full_join(got, by = c("episode_abs" = "episode_abs")) -> got

# Cleanup, reordering
got %<>%
  select(
    episode_abs, episode, season, epid, runtime, title,
    year, overview, starts_with("rating"), starts_with("votes"), viewers,
    director, writer,
    first_aired, first_aired.string,
    trakt, imdb, tvdb, tmdb
  ) %>%
  arrange(episode_abs)

gameofthrones <- as_tibble(got)
rm(got)

usethis::use_data(gameofthrones, overwrite = TRUE)
