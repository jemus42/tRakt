library(tibble)
library(dplyr)

# These datasets are used to check optional filter parameters.

# Networks ----
networks <- trakt_get(build_trakt_url("networks"))
networks <- networks$name
use_data(networks, overwrite = TRUE)

# Languages ----
lang_movies <- trakt_get(build_trakt_url("languages", "movies"))
lang_shows <- trakt_get(build_trakt_url("languages", "shows"))
languages <- full_join(lang_movies, lang_shows) %>% as_tibble()
use_data(languages, overwrite = TRUE)

use_data(genres, overwrite = TRUE)
# Genres ----
genres_movies <- trakt_get(build_trakt_url("genres", "movies"))
genres_shows <- trakt_get(build_trakt_url("genres", "shows"))
genres <- full_join(genres_movies, genres_shows) %>% as_tibble()
use_data(genres, overwrite = TRUE)


# Countries ----
countries_movies <- trakt_get(build_trakt_url("countries", "movies"))
countries_shows <- trakt_get(build_trakt_url("countries", "shows"))
countries <- full_join(countries_movies, countries_shows) %>% as_tibble()
use_data(countries, overwrite = TRUE)

# Certifications ----
certifications_movies <- trakt_get(build_trakt_url("certifications", "movies"))
certifications_shows <- trakt_get(build_trakt_url("certifications", "shows"))

certifications_movies <- map_df(names(certifications_movies), function(cc) {
  certifications_movies[[cc]] %>%
    as_tibble() %>%
    mutate(
      type = "movies",
      country = cc
    )
})

certifications_shows <- map_df(names(certifications_shows), function(cc) {
  certifications_shows[[cc]] %>%
    as_tibble() %>%
    mutate(
      type = "shows",
      country = cc
    )
})

certifications <- bind_rows(certifications_movies, certifications_shows)
use_data(certifications, overwrite = TRUE)
