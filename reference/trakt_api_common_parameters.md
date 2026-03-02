# Common API parameters

These parameters are used extensively throughout this package as they
are required for many API methods. Here there are all documented in one
place, which is intended to make the individual function documentation
more consistent.

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

- type:

  `character(1)`: Either `"shows"` or `"movies"`. For
  season/episode-specific functions, values `seasons` or `episodes` are
  also allowed.

- user:

  `character(1)`: Target username (or `slug`). Defaults to `"me"`, the
  OAuth user. Can also be of length greater than 1, in which case the
  function is called on all `user` values separately and the result is
  combined.

- period:

  `character(1) ["weekly"]`: Which period to filter by. Possible values
  are `"weekly"`, `"monthly"`, `"yearly"`, `"all"`.

- limit:

  `integer(1) [10L]`: Number of items to return. Must be greater than
  `0` and will be coerced via
  [`as.integer()`](https://rdrr.io/r/base/integer.html).

- season, episode:

  `integer(1) [1L]`: The season and episode number. If longer, e.g.
  `1:5`, the function is vectorized and the output will be combined.
  This may result in *a lot* of API calls. Use wisely.

- start_date:

  `character(1)`: A date in the past from which on to count updates. If
  no date is supplied, the default is to use yesterday relative to the
  current date. Value must either be standard `YYYY-MM-DD` format or an
  object of class [Date](https://rdrr.io/r/base/Dates.html), which will
  then be coerced via
  [as.character()](https://rdrr.io/r/base/character.html).

- sort:

  `character(1) ["newest"]`: Comment sort order, one of "newest",
  "oldest", "likes" or "replies".

- item_id:

  `character(1)`: The ID of the item you're looking for.

- query:

  `character(1)`: Search string for titles and descriptions. For
  [`search_query()`](https://jemus42.github.io/tRakt/reference/search_query.md)
  other fields are searched depending on the `type` of media. See [the
  API docs](https://trakt.docs.apiary.io/#reference/search/text-query)
  for a full reference.

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

## Value

A
[tibble()](https://tibble.tidyverse.org/reference/tibble-package.html).
If the function has a `limit` parameter (defaulting to `10`), this will
be the (maximum) number of rows of the `tibble`. If there are no results
(or the API is unreachable), an empty
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) is
returned.
