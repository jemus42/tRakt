# Get a single episode's details

This retrieves a single episode. See
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md)
for a whole season, and
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md)
for (potentially) all episodes of a show.

## Usage

``` r
episodes_summary(id, season = 1L, episode = 1L, extended = c("min", "full"))
```

## Source

`episodes_summary()` wraps endpoint
[/shows/:id/seasons/:season/episodes/:episode](https://trakt.docs.apiary.io/#reference/episodes/summary/get-a-single-episode-for-a-show).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- season, episode:

  `integer(1) [1L]`: The season and episode number. If longer, e.g.
  `1:5`, the function is vectorized and the output will be combined.
  This may result in *a lot* of API calls. Use wisely.

- extended:

  `character(1)`: Either `"min"` (API default) or `"full"`. The latter
  returns more variables and should generally only be used if required.
  See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

## Value

A
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html).
If the function has a `limit` parameter (defaulting to `10`), this will
be the (maximum) number of rows of the `tibble`. If there are no results
(or the API is unreachable), an empty
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) is
returned.

## See also

Other episode data:
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md)

Other summary methods:
[`comments_comment()`](https://jemus42.github.io/tRakt/reference/comments_comment.md),
[`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md),
[`user_profile()`](https://jemus42.github.io/tRakt/reference/user_profile.md)

## Examples

``` r
# Get just this one episode with its ratings, votes, etc.
episodes_summary("breaking-bad", season = 1, episode = 1, extended = "full")
#> # A tibble: 1 × 21
#>   id         season episode title number_abs overview rating votes comment_count
#>   <chr>       <int>   <int> <chr>      <int> <chr>     <dbl> <int>         <int>
#> 1 breaking-…      1       1 Pilot          1 When an…   8.33  8315            24
#> # ℹ 12 more variables: first_aired <dttm>, updated_at <dttm>,
#> #   available_translations <list>, runtime <int>, episode_type <chr>,
#> #   original_title <chr>, after_credits <lgl>, during_credits <lgl>,
#> #   trakt <chr>, tvdb <chr>, imdb <chr>, tmdb <chr>
```
