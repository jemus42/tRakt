library(tibble)
library(dplyr)

# These datasets are used to check optional filter parameters.

# Networks ----
networks <- trakt.api.call(build_trakt_url("networks"))
networks <- as_tibble(networks)
use_data(networks, overwrite = TRUE)

# Languages ----
lang_movies <- trakt.api.call(build_trakt_url("languages", "movies"))
lang_shows <- trakt.api.call(build_trakt_url("languages", "shows"))
languages <- full_join(lang_movies, lang_shows) %>% as_tibble()
use_data(languages, overwrite = TRUE)

use_data(genres, overwrite = TRUE)
# Genres ----
genres_movies <- trakt.api.call(build_trakt_url("genres", "movies"))
genres_shows <- trakt.api.call(build_trakt_url("genres", "shows"))
genres <- full_join(genres_movies, genres_shows) %>% as_tibble()
use_data(genres, overwrite = TRUE)


# Countries ----
countries_movies <- trakt.api.call(build_trakt_url("countries", "movies"))
countries_shows <- trakt.api.call(build_trakt_url("countries", "shows"))
countries <- full_join(countries_movies, countries_shows) %>% as_tibble()
use_data(countries, overwrite = TRUE)
