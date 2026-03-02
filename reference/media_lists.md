# Get lists containing a movie, show, season, episode or person

Get lists containing a movie, show, season, episode or person

## Usage

``` r
movies_lists(
  id,
  type = c("all", "personal", "official", "watchlists"),
  sort = c("popular", "likes", "comments", "items", "added", "updated"),
  limit = 10L,
  extended = c("min", "full")
)

shows_lists(
  id,
  type = c("all", "personal", "official", "watchlists"),
  sort = c("popular", "likes", "comments", "items", "added", "updated"),
  limit = 10L,
  extended = c("min", "full")
)

seasons_lists(
  id,
  season,
  type = c("all", "personal", "official", "watchlists"),
  sort = c("popular", "likes", "comments", "items", "added", "updated"),
  limit = 10L,
  extended = c("min", "full")
)

episodes_lists(
  id,
  season,
  episode,
  type = c("all", "personal", "official", "watchlists"),
  sort = c("popular", "likes", "comments", "items", "added", "updated"),
  limit = 10L,
  extended = c("min", "full")
)

people_lists(
  id,
  type = c("all", "personal", "official", "watchlists"),
  sort = c("popular", "likes", "comments", "items", "added", "updated"),
  limit = 10L,
  extended = c("min", "full")
)
```

## Source

`movies_lists()` wraps endpoint
[/movies/:id/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/movies/lists/get-lists-containing-this-movie).

`shows_lists()` wraps endpoint
[/shows/:id/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/shows/lists/get-lists-containing-this-show).

`seasons_lists()` wraps endpoint
[/shows/:id/seasons/:season/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/seasons/lists/get-lists-containing-this-season).

`episodes_lists()` wraps endpoint
[/shows/:id/seasons/:season/episodes/:episode/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/episodes/lists/get-lists-containing-this-episode).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- type:

  `character(1) ["all"]`: The type of list, one of "all", "personal",
  "official" or "watchlists".

- sort:

  `character(1) ["popular"]`: Sort lists by one of "popular", "likes",
  "comments", "items", "added" or "updated".

- limit:

  `integer(1) [10L]`: Number of items to return. Must be greater than
  `0` and will be coerced via
  [`as.integer()`](https://rdrr.io/r/base/integer.html).

- extended:

  `character(1)`: Either `"min"` (API default) or `"full"`. The latter
  returns more variables and should generally only be used if required.
  See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- season, episode:

  `integer(1) [1L]`: The season and episode number. If longer, e.g.
  `1:5`, the function is vectorized and the output will be combined.
  This may result in *a lot* of API calls. Use wisely.

## Value

A
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html).
If the function has a `limit` parameter (defaulting to `10`), this will
be the (maximum) number of rows of the `tibble`. If there are no results
(or the API is unreachable), an empty
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) is
returned.

## Functions

- `movies_lists()`: Lists containing a movie.

- `shows_lists()`: Lists containing a show.

- `seasons_lists()`: Lists containing a season.

- `episodes_lists()`: Lists containing an episode.

- `people_lists()`: Lists containing a person.

## See also

Other list methods:
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md),
[`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md),
[`user_lists()`](https://jemus42.github.io/tRakt/reference/user_lists.md)

Other movie data:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`movies_boxoffice()`](https://jemus42.github.io/tRakt/reference/movies_boxoffice.md),
[`movies_related()`](https://jemus42.github.io/tRakt/reference/movies_related.md),
[`movies_releases()`](https://jemus42.github.io/tRakt/reference/movies_releases.md),
[`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

Other list methods:
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md),
[`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md),
[`user_lists()`](https://jemus42.github.io/tRakt/reference/user_lists.md)

Other show data:
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md),
[`shows_related()`](https://jemus42.github.io/tRakt/reference/shows_related.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md)

Other list methods:
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md),
[`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md),
[`user_lists()`](https://jemus42.github.io/tRakt/reference/user_lists.md)

Other season data:
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_season()`](https://jemus42.github.io/tRakt/reference/seasons_season.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md)

Other list methods:
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md),
[`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md),
[`user_lists()`](https://jemus42.github.io/tRakt/reference/user_lists.md)

Other episode data:
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md)

Other list methods:
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md),
[`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md),
[`user_lists()`](https://jemus42.github.io/tRakt/reference/user_lists.md)

Other people data:
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
movies_lists("190430", type = "personal", limit = 5)
} # }
if (FALSE) { # \dontrun{
shows_lists("46241")
} # }
if (FALSE) { # \dontrun{
seasons_lists("46241", season = 1)
} # }
if (FALSE) { # \dontrun{
episodes_lists("46241", season = 1, episode = 1)
} # }
if (FALSE) { # \dontrun{
people_lists("david-tennant")

people_lists("emilia-clarke", sort = "items")
} # }
```
