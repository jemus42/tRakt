library(tRakt)
library(tibble)
library(dplyr)
library(usethis)

# These datasets are used to check optional filter parameters.

# Networks ----
networks <- trakt_get("networks") %>% pull(name)
use_data(networks, overwrite = TRUE)

# Languages ----
languages <- full_join(
  trakt_get("languages/movies"),
  trakt_get("languages/shows"),
  by = c("name", "code")
) %>%
  as_tibble()

use_data(languages, overwrite = TRUE)

# Genres ----
genres <- full_join(
  trakt_get("genres/movies"),
  trakt_get("genres/shows"),
  by = c("name", "slug")
) %>%
  as_tibble()

use_data(genres, overwrite = TRUE)

# Countries ----
countries <- full_join(
  trakt_get("countries/movies"),
  trakt_get("countries/shows"),
  by = c("name", "code")
) %>%
  as_tibble()

use_data(countries, overwrite = TRUE)

# Certifications ----
certifications <- map_df(c("movies", "shows"), ~ {
  trakt_get(build_trakt_url("certifications", .x)) %>%
    map_df(as_tibble, .id = "country") %>%
    mutate(type = .x)
})

use_data(certifications, overwrite = TRUE)
