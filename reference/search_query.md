# Search trakt.tv via text query or ID

Search for a show or movie with a keyword (e.g. `"Breaking Bad"`) and
receive basic info of the first search result. It's main use is to
retrieve the IDs or proper show/movie title for further use, as well as
receiving a quick overview of a show/movie.

## Usage

``` r
search_query(
  query,
  type = "show",
  n_results = 1L,
  extended = c("min", "full"),
  years = NULL,
  genres = NULL,
  languages = NULL,
  countries = NULL,
  runtimes = NULL,
  ratings = NULL,
  certifications = NULL,
  networks = NULL,
  status = NULL
)

search_id(
  id,
  id_type = c("trakt", "imdb", "tmdb", "tvdb"),
  type = "show",
  n_results = 1L,
  extended = c("min", "full")
)
```

## Source

`search_query()` wraps endpoint
[/search/:type?query=](https://trakt.docs.apiary.io/#reference/search/text-query/get-text-query-results).

`search_id()` wraps endpoint
[/search/:id_type/:id?type=](https://trakt.docs.apiary.io/#reference/search/id-lookup/get-text-query-results).

## Arguments

- query:

  `character(1)`: Search string for titles and descriptions. For
  `search_query()` other fields are searched depending on the `type` of
  media. See [the API
  docs](https://trakt.docs.apiary.io/#reference/search/text-query) for a
  full reference.

- type:

  `character(1) ["show"]`: The type of data you're looking for. One of
  `show`, `movie`, `episode`, `person` or `list` or a character vector
  with those elements, e.g. `c("show", "movie")`. Note that not every
  combination is reasonably combinable, e.g. `c("movie", "list")`. Use
  separate function calls in that case.

- n_results:

  `integer(1) [1]`: How many results to return.

- extended:

  `character(1)`: Either `"min"` (API default) or `"full"`. The latter
  returns more variables and should generally only be used if required.
  See
  [`vignette("tRakt")`](https://jemus42.github.io/tRakt/articles/tRakt.md)
  for more details.

- years:

  `character | integer`: 4-digit year (`2010`) **or** range, e.g.
  `"2010-2020"`. Can also be an integer vector of length two which will
  be coerced appropriately, e.g. `c(2010, 2020)`.

- genres:

  `character(n)`: Genre slug(s). See
  [`trakt_genres`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  for a table of genres. Multiple values are allowed and will be
  concatenated.

- languages:

  `character(n)`: Two-letter language code(s). Also see
  [`trakt_languages`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  for available languages (code and name).

- countries:

  `character(n)`: Two-letter country code(s). See
  [`trakt_countries`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md).

- runtimes:

  `character | integer`: Integer range in minutes, e.g. `30-90`. Can
  also be an integer vector of length two which will be coerced
  appropriately.

- ratings:

  `character | integer`: Integer range between `0` and `100`. Can also
  be an integer vector of length two which will be coerced
  appropriately. Note that user-supplied ratings are in the range of 1
  to 10, yet the ratings on the site itself are scaled to the range of 1
  to 100.

- certifications:

  `character(n)`: Certification(s) like `pg-13`. Multiple values are
  allowed. Use
  [`trakt_certifications`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  for reference. Note that there are different certifications for shows
  and movies.

- networks:

  `character(n)`: (Shows only) Network name like `HBO`. See
  [`trakt_networks`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  for a list of known networks.

- status:

  `character(n)`: (Shows only) The status of the shows. One of
  `"returning series"`, `"in production"`, `"planned"`, `"canceled"`, or
  `"ended"`.

- id:

  `character(1)`: The id used for the search, e.g. `14701` for a
  `Trakt ID`.

- id_type:

  `character(1) ["trakt"]`: The type of `id`. One of `trakt`, `imdb`,
  `tmdb`, `tvdb`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
containing `n_results` results. Variable `type` is equivalent to the
value of the `type` argument, and variable `score` indicates the search
match, where `1000` is a perfect match. If no results are found, the
`tibble` has 0 rows. If more than one `type` is specified, e.g.
`c("movie", "show")`, there will be `n_results` results *per type*.

## Details

The amount of information returned is equal to `*_summary` API methods
and in turn depends on the value of `extended`. See also the [API
reference here](https://trakt.docs.apiary.io/#reference/search) for
which fields of the item metadata are searched by default.

## Examples

``` r
# A show
search_query("Breaking Bad", type = "show", n_results = 3)
#> # A tibble: 3 × 35
#>     score type  title     year tagline overview runtime country trailer homepage
#>     <dbl> <chr> <chr>    <int> <chr>   <chr>      <int> <chr>   <chr>   <chr>   
#> 1 1.16e18 show  Breakin…  2008 "Chang… "Walter…      50 us      https:… https:/…
#> 2 1.16e18 show  Breakin…  2016 ""      "During…      42 cn      NA      NA      
#> 3 1.16e18 show  Breakin…  2009 ""      "Breaki…      42 us      NA      NA      
#> # ℹ 25 more variables: status <chr>, rating <dbl>, votes <int>,
#> #   comment_count <int>, updated_at <dttm>, language <chr>, languages <list>,
#> #   available_translations <list>, genres <list>, subgenres <list>,
#> #   original_title <chr>, first_aired <dttm>, aired_episodes <int>,
#> #   certification <chr>, network <chr>, airs_day <chr>, airs_time <chr>,
#> #   airs_timezone <chr>, trakt <chr>, slug <chr>, imdb <chr>, tmdb <chr>,
#> #   tvdb <chr>, plex_guid <chr>, plex_slug <chr>
if (FALSE) { # \dontrun{
# A show by its trakt id, and now with more information
search_id(1388, "trakt", type = "show", extended = "full")

# A person
search_query("J. K. Simmons", type = "person", extended = "full")

# A movie or a show, two of each
search_query("Tron", type = c("movie", "show"), n_results = 2)
} # }
```
