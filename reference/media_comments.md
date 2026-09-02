# Get all comments of a thing

Get all comments of a thing

## Usage

``` r
movies_comments(
  id,
  sort = c("newest", "oldest", "likes", "replies"),
  extended = "min",
  limit = 10L
)

shows_comments(
  id,
  sort = c("newest", "oldest", "likes", "replies"),
  extended = "min",
  limit = 10L
)

seasons_comments(
  id,
  season = 1L,
  sort = c("newest", "oldest", "likes", "replies"),
  extended = "min",
  limit = 10L
)

episodes_comments(
  id,
  season = 1L,
  episode = 1L,
  sort = c("newest", "oldest", "likes", "replies"),
  extended = "min",
  limit = 10L
)
```

## Source

`movies_comments()` wraps endpoint
[/movies/:id/comments/:sort](https://trakt.docs.apiary.io/#reference/movies/comments/get-all-movie-comments).

`shows_comments()` wraps endpoint
[/shows/:id/comments/:sort](https://trakt.docs.apiary.io/#reference/shows/comments/get-all-show-comments).

`seasons_comments()` wraps endpoint
[/shows/:id/seasons/:season/comments/:sort](https://trakt.docs.apiary.io/#reference/seasons/comments/get-all-season-comments).

`episodes_comments()` wraps endpoint
[/shows/:id/seasons/:season/episodes/:episode/comments/:sort](https://trakt.docs.apiary.io/#reference/episodes/comments/get-all-episode-comments).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- sort:

  `character(1) ["newest"]`: Comment sort order, one of "newest",
  "oldest", "likes" or "replies".

- extended:

  `character`: Level of detail for the API response.

  - `"min"` (default): Minimal info (title, year, IDs). Omits the
    `extended` query param.

  - `"full"`: Complete info including overview, ratings, runtime, etc.

  - `"images"`: Minimal info plus image URLs (returned as a
    list-column).

  - `"full,images"`: Complete info plus images.

  - `"metadata"`: Collection endpoints only; adds video/audio metadata.

  Multiple values can be combined as a comma-separated string (e.g.
  `"full,images"`) or a character vector (e.g. `c("full", "images")`).

- limit:

  `integer(1) [10L]`: Number of items to return. Must be greater than
  `0` and will be coerced via
  [`as.integer()`](https://rdrr.io/r/base/integer.html).

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

- `movies_comments()`: Get comments for a movie

- `shows_comments()`: Get comments for a movie

- `seasons_comments()`: Get comments for a season

- `episodes_comments()`: Get comments for an episode

## See also

Other comment methods:
[`comments_comment()`](https://jemus42.github.io/tRakt/reference/comments_comment.md),
[`comments_trending()`](https://jemus42.github.io/tRakt/reference/comments_trending.md),
[`comments_updates()`](https://jemus42.github.io/tRakt/reference/comments_updates.md),
[`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md),
[`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md)

Other movie data:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
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
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

Other show data:
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md),
[`shows_related()`](https://jemus42.github.io/tRakt/reference/shows_related.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md),
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md)

Other season data:
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_season()`](https://jemus42.github.io/tRakt/reference/seasons_season.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md)

Other episode data:
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md)

## Examples

``` r
movies_comments(193972)
#> # A tibble: 8 × 19
#>        id comment                   spoiler review parent_id created_at         
#>     <int> <chr>                     <lgl>   <lgl>      <int> <dttm>             
#> 1 1031140 "*Toy Story 4* was clear… FALSE   FALSE          0 2026-08-23 02:46:08
#> 2 1010013 "Sigue ofreciendo un apa… FALSE   FALSE          0 2026-08-01 12:19:40
#> 3  987101 "Ótimo filme, me deixou … FALSE   FALSE          0 2026-07-13 03:08:04
#> 4  985863 "This film is the perfec… FALSE   TRUE           0 2026-07-12 14:21:31
#> 5  982540 "I remember watching thi… FALSE   FALSE          0 2026-07-10 10:14:57
#> 6  982049 "I know Bonnie is very y… FALSE   FALSE          0 2026-07-10 00:01:04
#> 7  979529 "It wasn't like the prev… FALSE   FALSE          0 2026-07-08 03:29:34
#> 8  978257 "Watched Toy Story 4 wit… TRUE    FALSE          0 2026-07-07 05:31:36
#> # ℹ 13 more variables: updated_at <dttm>, replies <int>, likes <int>,
#> #   user_rating <int>, language <chr>, username <chr>, private <lgl>,
#> #   deleted <lgl>, user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>,
#> #   user_slug <chr>
shows_comments(46241, sort = "likes")
#> # A tibble: 10 × 19
#>        id comment                   spoiler review parent_id created_at         
#>     <int> <chr>                     <lgl>   <lgl>      <int> <dttm>             
#>  1   4528 "The bright colours, the… FALSE   FALSE          0 2014-12-27 21:04:43
#>  2  11599 "Television at its very … FALSE   FALSE          0 2013-02-24 18:13:58
#>  3  39755 "Holy hell I can't belie… FALSE   FALSE          0 2015-03-11 07:54:07
#>  4 143277 "After marathoning this … FALSE   FALSE          0 2017-10-01 18:42:14
#>  5 436459 "EIGHT HOUR detailed You… FALSE   FALSE          0 2022-01-15 08:59:48
#>  6 483035 "I've just finished watc… FALSE   FALSE          0 2022-07-04 14:16:16
#>  7 171295 "If you like this style … FALSE   FALSE          0 2018-04-20 01:20:40
#>  8  42940 "Looked interesting but … FALSE   FALSE          0 2015-05-06 17:25:07
#>  9 814556 "FUCKING AMAZING, BEST T… FALSE   FALSE          0 2025-05-20 12:03:34
#> 10 650557 "Spectacular show with s… FALSE   FALSE          0 2024-03-02 04:09:50
#> # ℹ 13 more variables: updated_at <dttm>, replies <int>, likes <int>,
#> #   user_rating <int>, language <chr>, username <chr>, private <lgl>,
#> #   deleted <lgl>, user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>,
#> #   user_slug <chr>
seasons_comments(46241, season = 1, sort = "likes")
#> # A tibble: 3 × 19
#>       id comment                    spoiler review parent_id created_at         
#>    <int> <chr>                      <lgl>   <lgl>      <int> <dttm>             
#> 1 386931 "This is the best season … FALSE   TRUE           0 2021-06-29 04:59:56
#> 2 780275 "This reminds me of Dirk … FALSE   FALSE          0 2025-03-02 21:53:20
#> 3 684618 "This is a hyper-stylized… TRUE    TRUE           0 2024-06-15 23:54:34
#> # ℹ 13 more variables: updated_at <dttm>, replies <int>, likes <int>,
#> #   user_rating <int>, language <chr>, username <chr>, private <lgl>,
#> #   deleted <lgl>, user_name <chr>, vip <lgl>, vip_ep <lgl>, director <lgl>,
#> #   user_slug <chr>
episodes_comments(46241, season = 1, episode = 2, sort = "likes")
#> # A tibble: 0 × 0
```
