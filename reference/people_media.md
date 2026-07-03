# Get a single person's movie or show credits

Returns all movies or shows where this person is in the cast or crew.

## Usage

``` r
people_movies(id, extended = "min")

people_shows(id, extended = "min")
```

## Source

`people_movies()` wraps endpoint
[/people/:id/movies](https://trakt.docs.apiary.io/#reference/people/movies/get-movie-credits).

`people_shows()` wraps endpoint
[/people/:id/shows](https://trakt.docs.apiary.io/#reference/people/shows/get-show-credits).

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

## Value

A `list` of one or more
[tibbles](https://tibble.tidyverse.org/reference/tibble-package.html)
for `cast` and `crew`. The latter `tibble` objects are as flat as
possible.

## Details

Note that as of 2019-09-30, there are two representations of
`character[s]` and `job[s]`: One is a regular character variable, and
the other is a list-column. The singular is [deprecated and only
included for compatibility
reasons](https://github.com/trakt/api-help/issues/74).

## See also

[media_people](https://jemus42.github.io/tRakt/reference/media_people.md),
for the other direction: Media that has people.

Other movie data:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
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
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

Other people data:
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md)

Other show data:
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`media_aliases`](https://jemus42.github.io/tRakt/reference/media_aliases.md),
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_people`](https://jemus42.github.io/tRakt/reference/media_people.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`media_translations`](https://jemus42.github.io/tRakt/reference/media_translations.md),
[`media_watching`](https://jemus42.github.io/tRakt/reference/media_watching.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md),
[`shows_related()`](https://jemus42.github.io/tRakt/reference/shows_related.md),
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md),
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md)

## Examples

``` r
people_movies("christopher-nolan")
#> $cast
#> # A tibble: 33 × 10
#>    character  characters  year title imdb  slug  tmdb  trakt plex_guid plex_slug
#>    <chr>      <list>     <int> <chr> <chr> <chr> <chr> <chr> <chr>     <chr>    
#>  1 "Self"     <chr [1]>   2025 Hans… tt35… hans… 1425… 1166… 679c165d… hans-zim…
#>  2 "Self - D… <chr [1]>   2023 Insi… tt28… insi… 1152… 9286… 64cb19e7… inside-c…
#>  3 "Self - W… <chr [1]>   2023 To E… tt28… to-e… 1149… 9263… 64a73d40… to-end-a…
#>  4 "Self - F… <chr [1]>   2023 MCAI… tt27… mcai… 9388… 7538… 641c04c7… mcaine-a…
#>  5 "Self"     <chr [1]>   2022 Hans… tt22… hans… 1031… 8298… 633f0ac3… hans-zim…
#>  6 "Self"     <chr [1]>   2021 Catw… tt16… catw… 8297… 6619… 619e3603… dc-villa…
#>  7 "Self"     <chr [1]>   2020 Look… tt13… look… 1417… 1159… 6013c9bb… looking-…
#>  8 "Self"     <chr [1]>   2020 Joke… tt12… joke… 7345… 5763… 5f3e352b… joker-pu…
#>  9 "Self"     <chr [1]>   2019 Maki… tt38… maki… 5958… 4418… 5d776ead… making-w…
#> 10 "Self"     <chr [1]>   2017 Behi… tt15… behi… 8661… 6925… 61323070… behind-t…
#> # ℹ 23 more rows
#> 
#> $crew
#> # A tibble: 67 × 11
#>    job   jobs   year title imdb  slug  tmdb  trakt plex_guid plex_slug crew_type
#>    <chr> <lis> <int> <chr> <chr> <chr> <chr> <chr> <chr>     <chr>     <chr>    
#>  1 Prod… <chr>  2026 The … tt33… the-… 1368… 1117… 670cb742… the-odys… producti…
#>  2 Exec… <chr>  2025 Sana… tt33… sana… 4238… 2871… 66b3ff7e… sanatori… producti…
#>  3 Prod… <chr>  2023 Oppe… tt15… oppe… 8725… 6982… 613b6946… oppenhei… producti…
#>  4 Exec… <chr>  2021 Zack… tt12… zack… 7913… 6270… 5ea7e109… zack-sny… producti…
#>  5 Prod… <chr>  2020 Tenet tt67… tene… 5779… 4279… 5d7770c2… tenet     producti…
#>  6 Prod… <chr>  2019 The … tt10… the-… 6226… 4649… NA        NA        producti…
#>  7 Exec… <chr>  2017 Just… tt09… just… 1410… 94232 5d7769aa… justice-… producti…
#>  8 Prod… <chr>  2017 Dunk… tt50… dunk… 3747… 2246… 5d776c06… dunkirk   producti…
#>  9 Exec… <chr>  2016 Batm… tt29… batm… 2091… 1295… 5d776a3c… batman-v… producti…
#> 10 Prod… <chr>  2015 Quay  tt49… quay… 3521… 2470… 5d776bc5… quay      producti…
#> # ℹ 57 more rows
#> 

people_shows("kit-harington")
#> $cast
#> # A tibble: 19 × 14
#>     year title  aired_episodes imdb  slug  tmdb  tvdb  trakt plex_guid plex_slug
#>    <int> <chr>           <int> <chr> <chr> <chr> <chr> <chr> <chr>     <chr>    
#>  1  2025 Too M…             10 tt30… too-… 2413… 4432… 2175… 65f99df8… too-much…
#>  2  2023 Extra…              8 tt13… extr… 1381… 3931… 1705… 5fd2a1b4… extrapol…
#>  3  2022 Sunda…            171 tt22… sund… 2094… 4241… 1979… 630ee8f6… sunday-w…
#>  4  2022 Welco…             57 tt14… welc… 1269… 4031… 1917… 60bba784… welcome-…
#>  5  2021 The G…              2 NA    the-… 2065… 4226… 1982… 62dd36c7… game-of-…
#>  6  2020 Indus…             32 tt76… indu… 90812 3717… 1548… 5e161292… industry 
#>  7  2019 My Gr…              8 tt10… my-g… 96682 3728… 1555… 5df5b931… my-grand…
#>  8  2019 Moder…             16 tt85… mode… 91602 3572… 1420… 5d9c0916… modern-l…
#>  9  2019 Crimi…              7 tt93… crim… 92926 3564… 1406… 5d9c0915… criminal…
#> 10  2017 Gunpo…              3 tt61… gunp… 73550 3340… 1232… 5d9c08de… gunpowder
#> 11  2015 The L…           1197 tt42… the-… 62223 2924… 96473 5d9c0852… the-late…
#> 12  2014 Late …           1831 tt35… late… 61818 2702… 75199 5d9c084f… late-nig…
#> 13  2014 The T…           2402 tt34… the-… 59941 2702… 59543 5d9c07f1… the-toni…
#> 14  2011 The J…            252 tt20… the-… 40302 2515… 40117 62aee01b… the-jona…
#> 15  2011 Game …             73 tt09… game… 1399  1213… 1390  5d9c086c… game-of-…
#> 16  2007 The G…            569 tt09… the-… 1220  80660 1214  5d9c086b… the-grah…
#> 17  1975 Satur…           1009 tt00… satu… 1667  76177 1656  5d9c086d… saturday…
#> 18    NA Count…              0 tt36… coun… 2983… 4668… 2949… NA        NA       
#> 19    NA A Tal…              0 tt38… a-ta… 3016… NA    3003… NA        NA       
#> # ℹ 4 more variables: character <chr>, characters <list>, episode_count <int>,
#> #   series_regular <lgl>
#> 
#> $crew
#> # A tibble: 2 × 13
#>    year title   aired_episodes imdb  slug  tmdb  tvdb  trakt plex_guid plex_slug
#>   <int> <chr>            <int> <chr> <chr> <chr> <chr> <chr> <chr>     <chr>    
#> 1  2017 Gunpow…              3 tt61… gunp… 73550 3340… 1232… 5d9c08de… gunpowder
#> 2    NA A Tale…              0 tt38… a-ta… 3016… NA    3003… NA        NA       
#> # ℹ 3 more variables: job <chr>, jobs <list>, crew_type <chr>
#> 
```
