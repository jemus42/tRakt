# Get the cast and crew of a show or movie

Returns all cast and crew for a show/movie, depending on how much data
is available.

## Usage

``` r
movies_people(id, extended = "min")

shows_people(id, guest_stars = FALSE, extended = "min")

seasons_people(id, season = 1L, guest_stars = FALSE, extended = "min")

episodes_people(
  id,
  season = 1L,
  episode = 1L,
  guest_stars = FALSE,
  extended = "min"
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

- guest_stars:

  **\[deprecated\]** `logical(1) ["FALSE"]`: Previously requested a
  separate `guest_stars` table. The trakt.tv API no longer returns that
  array — guest cast is now included in `cast`. This argument is
  currently a no-op and will be removed in a future release.

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
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

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
[`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md),
[`updated_media`](https://jemus42.github.io/tRakt/reference/updated_media.md)

Other season data:
[`media_comments`](https://jemus42.github.io/tRakt/reference/media_comments.md),
[`media_lists`](https://jemus42.github.io/tRakt/reference/media_lists.md),
[`media_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md),
[`media_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md),
[`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md),
[`seasons_season()`](https://jemus42.github.io/tRakt/reference/seasons_season.md),
[`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md)

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

## Examples

``` r
movies_people("deadpool-2016")
#> $cast
#> # A tibble: 50 × 18
#>    character     characters images$headshot name  death gender height birthday  
#>    <chr>         <list>     <list>          <chr> <chr> <chr>   <dbl> <date>    
#>  1 Wade Wilson … <chr [2]>  <chr [1]>       Ryan… NA    male     188. 1976-10-23
#>  2 Vanessa       <chr [1]>  <chr [1]>       More… NA    female   171. 1979-06-02
#>  3 Ajax          <chr [1]>  <chr [1]>       Ed S… NA    male     185  1983-03-29
#>  4 Weasel        <chr [1]>  <chr [1]>       T.J.… NA    male     188  1981-06-04
#>  5 Angel Dust    <chr [1]>  <chr [1]>       Gina… NA    female   173  1982-04-16
#>  6 Blind Al      <chr [1]>  <chr [1]>       Lesl… NA    female   168. 1943-05-25
#>  7 Negasonic Te… <chr [1]>  <chr [1]>       Bria… NA    female   160  1996-08-14
#>  8 Colossus (vo… <chr [1]>  <chr [1]>       Stef… NA    male     193. 1978-12-01
#>  9 Dopinder      <chr [1]>  <chr [1]>       Kara… NA    male     174  1989-01-08
#> 10 Buck          <chr [1]>  <chr [1]>       Rand… NA    male     193. 1971-11-27
#> # ℹ 40 more rows
#> # ℹ 10 more variables: homepage <chr>, biography <chr>, birthplace <chr>,
#> #   social_ids <df[,4]>, updated_at <dttm>, known_for_department <chr>,
#> #   imdb <chr>, slug <chr>, tmdb <chr>, trakt <chr>
#> 
#> $crew
#> # A tibble: 186 × 19
#>    job       jobs  images$headshot name  death gender height birthday   homepage
#>    <chr>     <lis> <list>          <chr> <chr> <chr>   <dbl> <date>     <chr>   
#>  1 Casting   <chr> <chr [1]>       Ronn… NA    female    NA  1959-12-29 NA      
#>  2 Producer  <chr> <chr [1]>       Laur… NA    female   168. 1949-06-23 NA      
#>  3 Executiv… <chr> <chr [1]>       Stan… 2018… male     185. 1922-12-28 https:/…
#>  4 Executiv… <chr> <chr [0]>       John… NA    male      NA  1967-06-10 NA      
#>  5 Executiv… <chr> <chr [1]>       Rhet… NA    male      NA  1975-01-01 NA      
#>  6 Executiv… <chr> <chr [1]>       Jona… NA    male      NA  NA         NA      
#>  7 Executiv… <chr> <chr [1]>       Paul… NA    male      NA  1972-08-02 NA      
#>  8 Casting   <chr> <chr [1]>       Cori… NA    female    NA  1970-09-25 NA      
#>  9 Casting   <chr> <chr [0]>       Jenn… NA    female    NA  1972-04-07 NA      
#> 10 Producti… <chr> <chr [1]>       Juli… NA    female    NA  NA         NA      
#> # ℹ 176 more rows
#> # ℹ 10 more variables: biography <chr>, birthplace <chr>, social_ids <df[,4]>,
#> #   updated_at <dttm>, known_for_department <chr>, imdb <chr>, slug <chr>,
#> #   tmdb <chr>, trakt <chr>, crew_type <chr>
#> 
shows_people("breaking-bad")
#> $cast
#> # A tibble: 229 × 20
#>    character   characters images$headshot episode_count order name  death gender
#>    <chr>       <list>     <list>                  <int> <int> <chr> <chr> <chr> 
#>  1 Walter Whi… <chr [1]>  <chr [1]>                  62     0 Brya… NA    male  
#>  2 Jesse Pink… <chr [1]>  <chr [1]>                  62     1 Aaro… NA    male  
#>  3 Skyler Whi… <chr [1]>  <chr [1]>                  62     2 Anna… NA    female
#>  4 Walter Whi… <chr [1]>  <chr [1]>                  62     3 RJ M… NA    male  
#>  5 Hank Schra… <chr [1]>  <chr [1]>                  62     4 Dean… NA    male  
#>  6 Marie Schr… <chr [1]>  <chr [1]>                  62     5 Bets… NA    female
#>  7 Gus Fring   <chr [1]>  <chr [1]>                  28     6 Gian… NA    male  
#>  8 Saul Goodm… <chr [1]>  <chr [1]>                  43     7 Bob … NA    male  
#>  9 Steven Gom… <chr [1]>  <chr [1]>                  33     8 Stev… NA    male  
#> 10 Mike Ehrma… <chr [1]>  <chr [1]>                  36     9 Jona… NA    male  
#> # ℹ 219 more rows
#> # ℹ 12 more variables: height <dbl>, birthday <date>, homepage <chr>,
#> #   biography <chr>, birthplace <chr>, social_ids <df[,4]>, updated_at <dttm>,
#> #   known_for_department <chr>, imdb <chr>, slug <chr>, tmdb <chr>, trakt <chr>
#> 
#> $crew
#> # A tibble: 27 × 20
#>    job             jobs  images$headshot episode_count name  death gender height
#>    <chr>           <lis> <list>                  <int> <chr> <chr> <chr>   <dbl>
#>  1 Casting         <chr> <chr [1]>                  62 Shar… NA    female    NA 
#>  2 Executive Prod… <chr> <chr [1]>                  62 Mich… NA    female    NA 
#>  3 Co-Executive P… <chr> <chr [1]>                  62 Pete… NA    male     180 
#>  4 Co-Executive P… <chr> <chr [1]>                  62 Thom… NA    male      NA 
#>  5 Casting         <chr> <chr [1]>                  62 Sher… NA    female    NA 
#>  6 Producer        <chr> <chr [1]>                  62 Brya… NA    male     179.
#>  7 Producer        <chr> <chr [1]>                  62 Stew… NA    male      NA 
#>  8 Co-Executive P… <chr> <chr [1]>                  62 Meli… NA    female    NA 
#>  9 Co-Executive P… <chr> <chr [1]>                  62 Geor… NA    male      NA 
#> 10 Producer        <chr> <chr [1]>                  62 Dian… NA    female    NA 
#> # ℹ 17 more rows
#> # ℹ 12 more variables: birthday <date>, homepage <chr>, biography <chr>,
#> #   birthplace <chr>, social_ids <df[,4]>, updated_at <dttm>,
#> #   known_for_department <chr>, imdb <chr>, slug <chr>, tmdb <chr>,
#> #   trakt <chr>, crew_type <chr>
#> 
seasons_people("breaking-bad", season = 1)
#> $cast
#> # A tibble: 47 × 20
#>    character   characters images$headshot episode_count order name  death gender
#>    <chr>       <list>     <list>                  <int> <int> <chr> <chr> <chr> 
#>  1 Walter Whi… <chr [1]>  <chr [1]>                   7     0 Brya… NA    male  
#>  2 Jesse Pink… <chr [1]>  <chr [1]>                   7     1 Aaro… NA    male  
#>  3 Skyler Whi… <chr [1]>  <chr [1]>                   7     2 Anna… NA    female
#>  4 Walter Whi… <chr [1]>  <chr [1]>                   7     3 RJ M… NA    male  
#>  5 Hank Schra… <chr [1]>  <chr [1]>                   7     4 Dean… NA    male  
#>  6 Marie Schr… <chr [1]>  <chr [1]>                   7     5 Bets… NA    female
#>  7 Steven Gom… <chr [1]>  <chr [1]>                   4     8 Stev… NA    male  
#>  8 Carmen Mol… <chr [1]>  <chr [1]>                   4   643 Carm… NA    female
#>  9 Krazy-8     <chr [1]>  <chr [1]>                   3   504 Max … NA    male  
#> 10 No-Doze     <chr [1]>  <chr [1]>                   2   515 Cesa… NA    male  
#> # ℹ 37 more rows
#> # ℹ 12 more variables: height <dbl>, birthday <date>, homepage <chr>,
#> #   biography <chr>, birthplace <chr>, social_ids <df[,4]>, updated_at <dttm>,
#> #   known_for_department <chr>, imdb <chr>, slug <chr>, tmdb <chr>, trakt <chr>
#> 
#> $crew
#> # A tibble: 49 × 20
#>    job             jobs  images$headshot episode_count name  death gender height
#>    <chr>           <lis> <list>                  <int> <chr> <chr> <chr>   <dbl>
#>  1 Associate Prod… <chr> <chr [0]>                   2 Gina… NA    female     NA
#>  2 Co-Producer     <chr> <chr [1]>                  68 Stew… NA    male       NA
#>  3 Producer        <chr> <chr [0]>                   6 Patt… NA    female     NA
#>  4 Casting         <chr> <chr [1]>                  69 Shar… NA    female     NA
#>  5 Casting         <chr> <chr [1]>                  69 Sher… NA    female     NA
#>  6 Producer        <chr> <chr [0]>                   7 Kare… NA    female     NA
#>  7 Co-Producer     <chr> <chr [1]>                  69 Meli… NA    female     NA
#>  8 Executive Prod… <chr> <chr [1]>                  69 Mark… NA    male       NA
#>  9 Executive Prod… <chr> <chr [1]>                  69 Vinc… NA    male      183
#> 10 Executive Prod… <chr> <chr [1]>                  62 Mich… NA    female     NA
#> # ℹ 39 more rows
#> # ℹ 12 more variables: birthday <date>, homepage <chr>, biography <chr>,
#> #   birthplace <chr>, social_ids <df[,4]>, updated_at <dttm>,
#> #   known_for_department <chr>, imdb <chr>, slug <chr>, tmdb <chr>,
#> #   trakt <chr>, crew_type <chr>
#> 
episodes_people("breaking-bad", season = 1, episode = 1)
#> $cast
#> # A tibble: 15 × 20
#>    character   characters images$headshot episode_count order name  death gender
#>    <chr>       <list>     <list>                  <int> <int> <chr> <lgl> <chr> 
#>  1 Walter Whi… <chr [1]>  <chr [1]>                   7     0 Brya… NA    male  
#>  2 Jesse Pink… <chr [1]>  <chr [1]>                   7     1 Aaro… NA    male  
#>  3 Skyler Whi… <chr [1]>  <chr [1]>                   7     2 Anna… NA    female
#>  4 Walter Whi… <chr [1]>  <chr [1]>                   7     3 RJ M… NA    male  
#>  5 Hank Schra… <chr [1]>  <chr [1]>                   7     4 Dean… NA    male  
#>  6 Marie Schr… <chr [1]>  <chr [1]>                   7     5 Bets… NA    female
#>  7 Steven Gom… <chr [1]>  <chr [1]>                   1     8 Stev… NA    male  
#>  8 Jock        <chr [1]>  <chr [1]>                   1   500 Aaro… NA    male  
#>  9 Dr. Belknap <chr [1]>  <chr [1]>                   1   502 Greg… NA    male  
#> 10 Krazy-8     <chr [1]>  <chr [1]>                   1   504 Max … NA    male  
#> 11 Bogdan Wol… <chr [1]>  <chr [1]>                   1   575 Mari… NA    male  
#> 12 Carmen Mol… <chr [1]>  <chr [1]>                   1   643 Carm… NA    female
#> 13 E.M.T       <chr [1]>  <chr [1]>                   1   676 Chri… NA    male  
#> 14 Emilio Koy… <chr [1]>  <chr [1]>                   1   703 John… NA    male  
#> 15 DEA Agent … <chr [1]>  <chr [1]>                   1   848 Ed D… NA    male  
#> # ℹ 12 more variables: height <dbl>, birthday <date>, homepage <lgl>,
#> #   biography <chr>, birthplace <chr>, social_ids <df[,4]>, updated_at <dttm>,
#> #   known_for_department <chr>, imdb <chr>, slug <chr>, tmdb <chr>, trakt <chr>
#> 
#> $crew
#> # A tibble: 39 × 20
#>    job             jobs  images$headshot episode_count name  death gender height
#>    <chr>           <lis> <list>                  <int> <chr> <chr> <chr>   <dbl>
#>  1 Associate Prod… <chr> <chr [0]>                   1 Gina… NA    female     NA
#>  2 Casting         <chr> <chr [1]>                  69 Shar… NA    female     NA
#>  3 Casting         <chr> <chr [1]>                  69 Sher… NA    female     NA
#>  4 Producer        <chr> <chr [0]>                   7 Kare… NA    female     NA
#>  5 Co-Producer     <chr> <chr [1]>                  69 Meli… NA    female     NA
#>  6 Executive Prod… <chr> <chr [1]>                  69 Mark… NA    male       NA
#>  7 Executive Prod… <chr> <chr [1]>                  69 Vinc… NA    male      183
#>  8 Executive Prod… <chr> <chr [1]>                  62 Mich… NA    female     NA
#>  9 Co-Executive P… <chr> <chr [1]>                  62 Pete… NA    male      180
#> 10 Co-Executive P… <chr> <chr [1]>                  62 Thom… NA    male       NA
#> # ℹ 29 more rows
#> # ℹ 12 more variables: birthday <date>, homepage <chr>, biography <chr>,
#> #   birthplace <chr>, social_ids <df[,4]>, updated_at <dttm>,
#> #   known_for_department <chr>, imdb <chr>, slug <chr>, tmdb <chr>,
#> #   trakt <chr>, crew_type <chr>
#> 
```
