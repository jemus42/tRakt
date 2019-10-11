library(tRakt)
library(rvest)
library(dplyr)
library(magrittr)
library(stringr)
library(tidyr)

# Futurama ----
futurama <- trakt.seasons.season("futurama", seasons = 1:7, extended = "full")
usethis::use_data(futurama, overwrite = TRUE)


# Game of Thrones ----
got <- trakt.seasons.season("game-of-thrones", seasons = 1:8, extended = "full")

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
gameofthrones <- got %>%
  select(
    episode_abs, episode, season, runtime, title,
    overview, rating, votes, viewers,
    director, writer,
    first_aired, comment_count,
    trakt, imdb, tvdb, tmdb, updated_at
  ) %>%
  arrange(episode_abs) %>%
  as_tibble()

usethis::use_data(gameofthrones, overwrite = TRUE)
