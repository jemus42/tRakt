# Get translations for a movie, show or episode

Get translations for a movie, show or episode

## Usage

``` r
movies_translations(id, languages = NULL)

shows_translations(id, languages = NULL)

episodes_translations(id, season = 1L, episode = 1L, languages = NULL)
```

## Source

`movies_translations()` wraps endpoint
[/movies/:id/translations/:language](https://trakt.docs.apiary.io/#reference/movies/translations/get-all-movie-translations).

`shows_translations()` wraps endpoint
[/shows/:id/translations/:language](https://trakt.docs.apiary.io/#reference/shows/translations/get-all-show-translations).

`episodes_translations()` wraps endpoint
[/shows/:id/seasons/:season/episodes/:episode/translations/:language](https://trakt.docs.apiary.io/#reference/episodes/translations/get-all-episode-translations).

## Arguments

- id:

  `character(1)`: The ID of the item requested. Preferably the `trakt`
  ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g.
  `"the-wire"`) or `imdb` ID (e.g. `"tt0306414"`). Can also be of length
  greater than 1, in which case the function is called on all `id`
  values separately and the result is combined. See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- languages:

  `character(n)`: Two-letter language code(s). Also see
  [`trakt_languages`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  for available languages (code and name).

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

## See also

Other movie data:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
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
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`people_media()`](https://jemus42.github.io/tRakt/reference/people_media.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md),
[`shows_related()`](https://jemus42.github.io/tRakt/reference/shows_related.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md),
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md)

Other episode data:
[`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md)

## Examples

``` r
# Get all translations
movies_translations("193972")
#> # A tibble: 55 × 5
#>    title                                     overview   tagline language country
#>    <chr>                                     <chr>      <chr>   <chr>    <chr>  
#>  1 حكاية لعبة 4                              "لطالما ك… مغامرة… ar       sa     
#>  2 حكاية لعبة 4                               NA        NA      ar       ae     
#>  3 Гісторыя цацак 4                           NA        NA      be       by     
#>  4 Играта на играчките: Пътешествието        "Уди вина… Приклю… bg       bg     
#>  5 টয় স্টোরি ৪                                 NA        NA      bn       bd     
#>  6 NA                                        "Compte! … Torna … ca       es     
#>  7 Toy Story 4: Příběh hraček                "Kovboj W… Připra… cs       cz     
#>  8 NA                                        "Siden An… NA      da       dk     
#>  9 A Toy Story: Alles hört auf kein Kommando "Die Cowb… Hier s… de       de     
#> 10 Η Ιστορία των Παιχνιδιών 4                "Στη διάρ… Η περι… el       gr     
#> # ℹ 45 more rows

# Only get a specific language
movies_translations("193972", "de")
#> # A tibble: 1 × 5
#>   title                                     overview    tagline language country
#>   <chr>                                     <chr>       <chr>   <chr>    <chr>  
#> 1 A Toy Story: Alles hört auf kein Kommando Die Cowboy… Hier s… de       de     
```
