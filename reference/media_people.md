# Get the cast and crew of a show or movie

Returns all cast and crew for a show/movie, depending on how much data
is available.

## Usage

``` r
movies_people(id, extended = c("min", "full"))

shows_people(id, guest_stars = FALSE, extended = c("min", "full"))

seasons_people(
  id,
  season = 1L,
  guest_stars = FALSE,
  extended = c("min", "full")
)

episodes_people(
  id,
  season = 1L,
  episode = 1L,
  guest_stars = FALSE,
  extended = c("min", "full")
)
```

## Source

`movies_people()` wraps endpoint
[/movies/:id/people](https://trakt.docs.apiary.io/#reference/movies/people/get-all-people-for-a-movie).

`shows_people()` wraps endpoint
[/shows/:id/people](https://trakt.docs.apiary.io/#reference/shows/people/get-all-people-for-a-show).

`seasons_people()` wraps endpoint
[/shows/:id/seasons/:season/people](https://trakt.docs.apiary.io/#reference/seasons/people/get-all-people-for-a-season).

`episodes_people()` wraps endpoint
[/shows/:id/seasons/:season/episodes/:episode/people](https://trakt.docs.apiary.io/#reference/episodes/people/get-all-people-for-an-episode).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- extended:

  `character(1)`: Either `"min"` (API default) or `"full"`. The latter
  returns more variables and should generally only be used if required.
  See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- guest_stars:

  `logical(1) ["FALSE"]`: Also include guest stars. This returns a lot
  of data, so use with care.

- season, episode:

  `integer(1) [1L]`: The season and episode number. If longer, e.g.
  `1:5`, the function is vectorized and the output will be combined.
  This may result in *a lot* of API calls. Use wisely.

## Value

A `list` of one or more
[tibbles](https://tibble.tidyverse.org/reference/tibble-package.html)
for `cast` and/or `crew`. The latter `tibble` objects are as flat as
possible.

## Note

As of 2019-09-30, there are two representations of `character[s]` and
`job[s]`: One is a regular character variable, and the other is a
list-column. The former is
[deprecated](https://github.com/trakt/api-help/issues/74) and only
included for compatibility reasons.

## See also

[people_media](https://jemus42.github.io/tRakt/reference/people_media.md),
for the other direction: People that have credits in shows/movies.

Other people data:
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md)

Other movie data:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
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

Other people data:
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md)

Other show data:
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md),
[`shows_related()`](https://jemus42.github.io/tRakt/reference/shows_related.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md)

Other people data:
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md)

Other season data:
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_season()`](https://jemus42.github.io/tRakt/reference/seasons_season.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md)

Other people data:
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md)

Other episode data:
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md)

Other people data:
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
movies_people("deadpool-2016")
shows_people("breaking-bad")
seasons_people("breaking-bad", season = 1)
episodes_people("breaking-bad", season = 1, episode = 1)
} # }
```
