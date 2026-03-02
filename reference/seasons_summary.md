# Get a show's seasons

Get details for a show's seasons, e.g. how many seasons there are and
how many epsiodes each season has. With `episodes == TRUE` and
`extended == "full"`, this function is also suitable to retrieve all
episode data for all seasons of a show with just a single API call.

## Usage

``` r
seasons_summary(
  id,
  episodes = FALSE,
  drop_specials = TRUE,
  drop_unaired = TRUE,
  extended = c("min", "full")
)
```

## Source

`seasons_summary()` wraps endpoint
[/shows/:id/seasons/:season](https://trakt.docs.apiary.io/#reference/seasons/summary/get-all-seasons-for-a-show).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- episodes:

  `logical(1) [FALSE]`: If `TRUE`, all episodes for each season are
  appended as a list-column, with the amount of variables depending on
  `extended`.

- drop_specials:

  `logical(1) [TRUE]`: Special episodes (season 0) are dropped

- drop_unaired:

  `logical(1) [TRUE]`: Seasons without aired episodes are dropped. Only
  works if `extended` is `"full"`.

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

Other season data:
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_season()`](https://jemus42.github.io/tRakt/reference/seasons_season.md)

Other episode data:
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md)

Other summary methods:
[`comments_comment()`](https://jemus42.github.io/tRakt/reference/comments_comment.md),
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md),
[`user_profile()`](https://jemus42.github.io/tRakt/reference/user_profile.md)

## Examples

``` r
# Get just the season numbers and their IDs
seasons_summary("breaking-bad", extended = "min")
#> # A tibble: 5 × 15
#>   title    votes season rating network overview              updated_at         
#>   <chr>    <int>  <int>  <dbl> <lgl>   <chr>                 <dttm>             
#> 1 Season 1  4301      1   8.44 NA      "High school chemist… 2026-03-02 07:18:19
#> 2 Season 2  3570      2   8.63 NA      "Walt must deal with… 2026-03-02 09:58:04
#> 3 Season 3  3364      3   8.82 NA      "Walt continues to b… 2026-03-02 11:00:16
#> 4 Season 4  3206      4   9.15 NA      "Walt and Jesse must… 2026-03-02 09:04:56
#> 5 Season 5  2868      5   9.31 NA      "Walt is faced with … 2026-03-02 09:10:13
#> # ℹ 8 more variables: first_aired <dttm>, episode_count <int>,
#> #   aired_episodes <int>, original_title <chr>, tmdb <chr>, tvdb <chr>,
#> #   trakt <chr>, plex_guid <chr>
if (FALSE) { # \dontrun{
# Get season numbers, ratings, votes, titles and other metadata as well as
# a list-column containing all episode data
seasons_summary("utopia", extended = "full", episodes = TRUE)
} # }
```
