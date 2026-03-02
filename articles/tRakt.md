# Getting Started

``` r
library(tRakt)
```

That’s all you need to to for basic things. If you’re planning a larger
project with lots and lots of data retrieval, you might want to create
your own API app [on trakt.tv](https://trakt.tv/oauth/applications).

## 1. Find things

Using a text query:

``` r
search_query("Utopia", type = "show")
#> # A tibble: 1 × 35
#>     score type  title   year tagline   overview runtime country trailer homepage
#>     <dbl> <chr> <chr>  <int> <chr>     <chr>      <int> <chr>   <chr>   <chr>   
#> 1 5.79e17 show  Utopia  2013 The Netw… The  Ut…      50 gb      https:… https:/…
#> # ℹ 25 more variables: status <chr>, rating <dbl>, votes <int>,
#> #   comment_count <int>, updated_at <dttm>, language <chr>, languages <list>,
#> #   available_translations <list>, genres <list>, subgenres <list>,
#> #   original_title <chr>, first_aired <dttm>, aired_episodes <int>,
#> #   certification <chr>, network <chr>, airs_day <chr>, airs_time <chr>,
#> #   airs_timezone <chr>, trakt <chr>, slug <chr>, imdb <chr>, tmdb <chr>,
#> #   tvdb <chr>, plex_guid <chr>, plex_slug <chr>
```

Search using an ID:

``` r
search_id("tt2384811", id_type = "imdb", type = "show")
#> # A tibble: 1 × 9
#>   type  score title   year trakt slug   tvdb   imdb      tmdb 
#>   <chr> <dbl> <chr>  <int> <chr> <chr>  <chr>  <chr>     <chr>
#> 1 show    100 Utopia  2013 46241 utopia 264991 tt2384811 46511
```

Or via whatever’s popular(ish):

Another scenario would be that you’re not necessarily interested in some
specific media item, but rather a collection of items that fulfill
certain criteria, like being popular on trakt.tv and maybe being from a
specific period or genre and whatnot. While you can also filter
`search_query` by other criteria, it’s maybe more useful to filter,
let’s say, the most watched movies of the past week by the release year
of the movie.

The 5 most popular shows:

``` r
shows_popular(limit = 5)
#> # A tibble: 5 × 33
#>   title     year tagline overview runtime country trailer homepage status rating
#>   <chr>    <int> <chr>   <chr>      <int> <chr>   <chr>   <chr>    <chr>   <dbl>
#> 1 Adolesc…  2025 "A chi… When a …      58 gb      https:… https:/… ended    7.72
#> 2 Pluribus  2025 "Happi… The mos…      50 us      https:… https:/… retur…   8.04
#> 3 MobLand   2025 ""      Two mob…      60 us      https:… https:/… retur…   8.36
#> 4 Alien: …  2025 "We we… When th…      55 us      https:… https:/… retur…   7.44
#> 5 A Knigh…  2026 "A tal… A centu…      35 us      https:… https:/… retur…   8.23
#> # ℹ 23 more variables: votes <int>, comment_count <int>, updated_at <dttm>,
#> #   language <chr>, languages <list>, available_translations <list>,
#> #   genres <list>, subgenres <list>, original_title <chr>, first_aired <dttm>,
#> #   aired_episodes <int>, certification <chr>, network <chr>, airs_day <chr>,
#> #   airs_time <chr>, airs_timezone <chr>, trakt <chr>, slug <chr>, imdb <chr>,
#> #   tmdb <chr>, tvdb <chr>, plex_guid <chr>, plex_slug <chr>
```

The 10 most watched (during the past year) movies from 1990-2000:

``` r
library(dplyr)

movies_watched(period = "yearly", years = c(1990, 2000)) |>
  select(watcher_count, title, year)
#> # A tibble: 10 × 3
#>    watcher_count title                     year
#>            <int> <chr>                    <int>
#>  1           615 Toy Story                 1995
#>  2           576 Scream                    1996
#>  3           559 The Matrix                1999
#>  4           402 The Shawshank Redemption  1994
#>  5           384 Scream 2                  1997
#>  6           362 The Lion King             1994
#>  7           361 Fight Club                1999
#>  8           359 Toy Story 2               1999
#>  9           346 Pulp Fiction              1994
#> 10           329 Jurassic Park             1993
```

## Finding Things (and the right amount)

### Item identifiers

The `id` parameter is used to identify shows, movies or people. In each
of these cases, the value of the parameter must be a valid ID of one of
the following kinds:

- **Trakt ID** (`trakt`): A numeric ID used by trakt.tv, which is
  included as a variable named `trakt` by every function for an output
  item. These IDs are unique for their respective category (or `type`,
  e.g. shows, movies, people, …) and can be expected to have full
  coverage, meaning that every item will have a category-specific Trakt
  ID.
- **Slug** (`slug`): A human-readable identifier used on the trakt.tv
  site, e.g. `the-wire`. While these are easy to remember, they have the
  risk of clashing with numeric IDs. One example is the show “24”, which
  has the slug `24`. However, the show “Presidio Med” has the **Trakt
  ID** `24`, so if you supply `id = 24` the API assumes you meant the
  Trakt ID instead of the slug. This is… suboptimal. Use `trakt` ID’s
  whenever possible in any sort of user-facing application or
  batch-processing.
- **IMDb ID** (`imdb`): Relatively self-explanatory. You can retrieve
  them easily via most functions or by searching on
  [IMDb.com](https://www.imdb.com/). Since IMDb is an external service,
  these IDs should be used for linking with other data sources rather
  than as search parameters for the trakt API, as it can not be
  guaranteed that every item on trakt.tv does have an IMDb ID.

The API also returns additional IDs for
[TMDB](https://www.themoviedb.org/) and
[TheTVDB](https://www.thetvdb.com). These are useful for linking with
other data sources like [fanart.tv](https://fanart.tv/), but can’t be
used for search with the trakt API as they are not guaranteed full
coverage. The API also includes a TVRage ID, but since this site seems
to not exist anymore (and therefore newer items don’t have this ID) this
ID is removed from all output whether it is missing or not.

### Extended Information:

The `extended` parameter controls the amount of information (i.e. the
number of variables) included in the output.

- `"min"`: The default option returns minimal information. For shows,
  movies, episodes and people, the result will only include a title or
  name, possibly a year, and the standard set of IDs (`trakt`, `imdb`,
  …). This is the fastest option as it requires less data to be sent
  from the API and less post-processing work to produce tabular output.

- `"full"`: The maximum amount of information. This option is required
  if you are interested in the `votes` and `rating` variables, as well
  as additional metadata like air dates, plot summaries, and a plethora
  of other variables depending on the `type`. If you intend on
  retrieving data for a large number of items, e.g. via
  [`shows_popular()`](https://jemus42.github.io/tRakt/reference/popular_media.md)
  and other list functions, it is highly recommend to cache the output
  locally when using `extended = "full"` and subsequently only use
  `extended = "min"`, so you can merge/join the minimal data with your
  cached data. [httr2](https://httr2.r-lib.org) automatically caches
  requests under the hood, so you don’t need to do anything special
  there for regular usage.

- `images`: Images such as posters *used to* be available via the trakt
  API some years ago but where discontinued due to the associated
  bandwidth and storage costs. As of early 2025, images are once again
  [available with the
  API](https://trakt.docs.apiary.io/#introduction/images) but requesting
  them is not implemented here (yet?). If you need posters, I recommend
  taking a detour over to [fanart.tv](https://fanart.tv/)
