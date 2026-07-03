# Build a filter set for the dynamic-list and search endpoints

The trakt.tv API lets several `movies`, `shows`, and `search` methods
refine their results with *filters*. These builders assemble a validated
set of filters to pass to the `filters` argument of functions like
[`movies_popular()`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`shows_trending()`](https://jemus42.github.io/tRakt/reference/trending_media.md),
or
[`search_query()`](https://jemus42.github.io/tRakt/reference/search_query.md).

## Usage

``` r
filters_movies(
  query = NULL,
  years = NULL,
  genres = NULL,
  subgenres = NULL,
  languages = NULL,
  countries = NULL,
  runtimes = NULL,
  studio_ids = NULL,
  ratings = NULL,
  votes = NULL,
  tmdb_ratings = NULL,
  tmdb_votes = NULL,
  imdb_ratings = NULL,
  imdb_votes = NULL,
  rt_meters = NULL,
  rt_user_meters = NULL,
  metascores = NULL,
  certifications = NULL
)

filters_shows(
  query = NULL,
  years = NULL,
  genres = NULL,
  subgenres = NULL,
  languages = NULL,
  countries = NULL,
  runtimes = NULL,
  studio_ids = NULL,
  ratings = NULL,
  votes = NULL,
  tmdb_ratings = NULL,
  tmdb_votes = NULL,
  imdb_ratings = NULL,
  imdb_votes = NULL,
  certifications = NULL,
  network_ids = NULL,
  networks = NULL,
  status = NULL
)

filters_episodes(
  query = NULL,
  years = NULL,
  genres = NULL,
  subgenres = NULL,
  languages = NULL,
  countries = NULL,
  runtimes = NULL,
  studio_ids = NULL,
  ratings = NULL,
  votes = NULL,
  tmdb_ratings = NULL,
  tmdb_votes = NULL,
  imdb_ratings = NULL,
  imdb_votes = NULL,
  certifications = NULL,
  network_ids = NULL,
  episode_types = NULL
)
```

## Arguments

- query:

  `character(1)`: Match titles and descriptions.

- years:

  `numeric`: A single 4-digit year or a length-2 range, e.g. `2016` or
  `c(2000, 2010)`.

- genres, languages, countries, certifications:

  `character`: One or more [genre
  slugs](https://jemus42.github.io/tRakt/reference/trakt_datasets.md),
  [language
  codes](https://jemus42.github.io/tRakt/reference/trakt_datasets.md),
  [country
  codes](https://jemus42.github.io/tRakt/reference/trakt_datasets.md),
  or [certification
  slugs](https://jemus42.github.io/tRakt/reference/trakt_datasets.md).

- subgenres:

  `character`: One or more subgenre slugs (technical preview).

- runtimes:

  `numeric`: Runtime in minutes; a single value or length-2 range.

- studio_ids, network_ids:

  `integer`: One or more Trakt studio / network IDs.

- ratings, votes:

  `numeric`: Trakt rating (`0`-`100`) / vote-count (`0`-`100000`) range.

- tmdb_ratings, tmdb_votes:

  `numeric`: TMDB rating (`0.0`-`10.0`) / vote-count range.

- imdb_ratings, imdb_votes:

  `numeric`: IMDb rating (`0.0`-`10.0`) / vote-count range.

- rt_meters, rt_user_meters:

  `numeric`: Rotten Tomatoes tomatometer / audience-score range
  (`0`-`100`). Movies only.

- metascores:

  `numeric`: Metacritic score range (`0`-`100`). Movies only.

- networks:

  `character`: One or more network names (e.g. `"Netflix"`), validated
  against
  [trakt_networks](https://jemus42.github.io/tRakt/reference/trakt_datasets.md).
  For precise matching prefer `network_ids`.

- status:

  `character`: One or more show statuses: `"returning series"`,
  `"continuing"`, `"in production"`, `"planned"`, `"upcoming"`,
  `"pilot"`, `"canceled"`, `"ended"`.

- episode_types:

  `character`: One or more episode types: `"standard"`,
  `"series_premiere"`, `"season_premiere"`, `"mid_season_finale"`,
  `"mid_season_premiere"`, `"season_finale"`, `"series_finale"`.

## Value

A `trakt_filters` object: a validated, classed list of query parameters.
Pass it to a function's `filters` argument.

## Details

Each builder exposes exactly the filters the API supports for that media
type. Values are validated and normalized up front (unknown vocabulary
values warn and are dropped; out-of-range numbers warn and are ignored),
so a malformed filter never silently produces a wrong request.

## See also

Other dynamic lists:
[`anticipated_media`](https://jemus42.github.io/tRakt/reference/anticipated_media.md),
[`collected_media`](https://jemus42.github.io/tRakt/reference/collected_media.md),
[`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md),
[`played_media`](https://jemus42.github.io/tRakt/reference/played_media.md),
[`popular_media`](https://jemus42.github.io/tRakt/reference/popular_media.md),
[`trending_media`](https://jemus42.github.io/tRakt/reference/trending_media.md),
[`watched_media`](https://jemus42.github.io/tRakt/reference/watched_media.md)

## Examples

``` r
filters_movies(genres = "action", years = c(2000, 2010), imdb_ratings = c(8, 10))
#> <trakt_filters>
#> • years: "2000-2010"
#> • genres: "action"
#> • imdb_ratings: "8-10"

filters_shows(networks = "Netflix", status = "returning series")
#> <trakt_filters>
#> • networks: "Netflix"
#> • status: "returning series"

filters_episodes(episode_types = "season_finale")
#> <trakt_filters>
#> • episode_types: "season_finale"
```
