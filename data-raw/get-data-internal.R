library(tRakt)
library(tibble)
library(dplyr)
library(usethis)
library(stringr)

# These datasets are used to check optional filter parameters.

# Networks ----
trakt_networks <- trakt_get("networks") %>%
  mutate(
    name_clean = str_to_lower(name) %>%
      str_trim("both")
  ) %>%
  as_tibble()

use_data(trakt_networks, overwrite = TRUE)

# Languages ----
trakt_languages <- bind_rows(
  trakt_get("languages/movies") %>% mutate(type = "movies"),
  trakt_get("languages/shows") %>% mutate(type = "shows")
) %>%
  arrange(code) %>%
  as_tibble()

use_data(trakt_languages, overwrite = TRUE)

# Genres ----
trakt_genres <- bind_rows(
  trakt_get("genres/movies") %>% mutate(type = "movies"),
  trakt_get("genres/shows") %>% mutate(type = "shows")
) %>%
  arrange(slug) %>%
  as_tibble()

use_data(trakt_genres, overwrite = TRUE)

# Countries ----
trakt_countries <- bind_rows(
  trakt_get("countries/movies") %>% mutate(type = "movies"),
  trakt_get("countries/shows") %>% mutate(type = "shows")
) %>%
  arrange(code) %>%
  as_tibble()

use_data(trakt_countries, overwrite = TRUE)

# Certifications ----
trakt_certifications <- purrr::map_df(c("movies", "shows"), ~ {
  trakt_get(build_trakt_url("certifications", .x)) %>%
    purrr::map_df(as_tibble, .id = "country") %>%
    mutate(type = .x)
})

use_data(trakt_certifications, overwrite = TRUE)
