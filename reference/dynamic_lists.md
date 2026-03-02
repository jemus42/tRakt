# See which movies / shows are popular across various metrics

According to the API docs, popularity is calculated based both on
ratings and the number of ratings (i.e., votes). Trending items are
those being watched right now, where items with the most users currently
watching are returned first. Anticipation is measured by the number of
user-created lists an items is part of while not being released yet.

## The Dynamic Lists on trakt.tv

These functions access the automatically updated lists provided by
trakt.tv. Each function comes in two flavors: Shows or movies. The
following descriptions are adapted directly from the [API
reference](https://trakt.docs.apiary.io/#reference/movies/popular/get-popular-movies).

- [Popular](https://jemus42.github.io/tRakt/reference/popular_media.md):
  Popularity is calculated using the rating percentage and the number of
  ratings.

- [Trending](https://jemus42.github.io/tRakt/reference/trending_media.md):
  Returns all movies/shows being watched right now. Movies/shows with
  the most users are returned first.

- [Played](https://jemus42.github.io/tRakt/reference/played_media.md):
  Returns the most played (a single user can watch multiple times)
  movies/shows in the specified time `period`.

- [Watched](https://jemus42.github.io/tRakt/reference/watched_media.md):
  Returns the most watched (unique users) movies/shows in the specified
  time `period`.

- [Collected](https://jemus42.github.io/tRakt/reference/collected_media.md):
  Returns the most collected (unique users) movies/shows in the
  specified time `period`.

- [Anticipated](https://jemus42.github.io/tRakt/reference/anticipated_media.md):
  Returns the most anticipated movies/shows based on the number of lists
  a movie/show appears on. The functions for **Played**, **Watched**,
  **Collected** and **Played** each return the same additional variables
  besides the media information: `watcher_count`, `play_count`,
  `collected_count`, `collector_count`.
