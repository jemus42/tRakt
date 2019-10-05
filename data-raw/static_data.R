library(tRakt)
library(tibble)
library(dplyr)
library(usethis)

# These datasets are used to check optional filter parameters.

# Networks ----
trakt_networks <- trakt_get("networks") %>% pull(name)
use_data(trakt_networks, overwrite = TRUE)

# Languages ----
trakt_languages <- full_join(
  trakt_get("languages/movies"),
  trakt_get("languages/shows"),
  by = c("name", "code")
) %>%
  as_tibble()

use_data(trakt_languages, overwrite = TRUE)

# Genres ----
trakt_genres <- full_join(
  trakt_get("genres/movies"),
  trakt_get("genres/shows"),
  by = c("name", "slug")
) %>%
  as_tibble()

use_data(trakt_genres, overwrite = TRUE)

# Countries ----
trakt_countries <- full_join(
  trakt_get("countries/movies"),
  trakt_get("countries/shows"),
  by = c("name", "code")
) %>%
  as_tibble()

use_data(trakt_countries, overwrite = TRUE)

# Certifications ----
trakt_certifications <- map_df(c("movies", "shows"), ~ {
  trakt_get(build_trakt_url("certifications", .x)) %>%
    map_df(as_tibble, .id = "country") %>%
    mutate(type = .x)
})

use_data(trakt_certifications, overwrite = TRUE)
