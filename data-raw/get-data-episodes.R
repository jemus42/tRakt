library(tRakt)
library(rvest)
library(dplyr)
library(magrittr)
library(stringr)
library(tidyr)

# Futurama ----
futurama <- seasons_season("futurama", seasons = 1:7, extended = "full")
usethis::use_data(futurama, overwrite = TRUE)


# Game of Thrones ----
got_trakt <- seasons_season("game-of-thrones", seasons = 1:8, extended = "full")

# Wiki
got_wiki <- read_html("https://en.wikipedia.org/wiki/List_of_Game_of_Thrones_episodes") %>%
  html_table(fill = TRUE) %>%
  magrittr::extract(c(2:9)) %>%
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
  as_tibble()


# Cleanup, reordering
gameofthrones <- left_join(
  got_trakt,
  got_wiki,
  by = "episode_abs"
  ) %>%
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
