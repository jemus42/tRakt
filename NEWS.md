# tRakt 0.15.9000

## New functions

- `episodes_summary()`: What `seasons_season()` and `seasons_sumamry()` do, but for a single episode. Only really implemented for completeness' sake. Wraps [`shows/:id/seasons/:season/episodes/:episode`](https://trakt.docs.apiary.io/#reference/episodes/summary)
- `user_profile`: Wraps [`user/:id`](https://trakt.docs.apiary.io/#reference/users/profile/get-user-profile) to get user profiles

## The Renamingering

Rename _all the things_ to snake_case and drop the `trakt.` prefix.  
This results in (most) functions mapping directly to [API endpoints](https://trakt.docs.apiary.io/) in the form `section_method`,
e.g. the API endpoint `movies/collected` is handled by function `movies_collected()`. 

### Search

- `trakt.search` -> `search_query`
- `trakt.search.byid` -> `search_id`

### Dynamic Lists

- `trakt.popular`
  - -> `movies_popular`
  - -> `shows_popular`
- `trakt.trending`
  - -> `movies_trending`
  - -> `shows_trending`
- `trakt.anticipated`
  - -> `movies_anticipated`
  - -> `shows_anticipated`
- `trakt.played`
  - -> `movies_played`
  - -> `shows_played`
- `trakt.watched`
  - -> `movies_watched`
  - -> `shows_watched`
- `trakt.collected`
  - -> `movies_collected`
  - -> `shows_collected`
- `trakt.updates`
  - -> `movies_updates`
  - -> `shows_updates`
  
### Movies

- `trakt.movies.summary` -> `movies_summary`
- `trakt.movies.boxoffice` -> `movies_boxoffice`
- `trakt.movies.releases` -> `movies_releases`
- `trakt.movies.people` -> `movies_people`
  
### Shows

- `trakt.shows.summary` -> `shows_summary`
- `trakt.shows.people` -> `shows_people`

### Seasons

- `trakt.seasons.summary` -> `seasons_summary`
- `trakt.seasons.season` -> `seasons_season` (It's silly, I know, but oh well)

### Ratings

- `trakt.movies.ratings` -> `movies_ratings`
- `trakt.shows.ratings` -> `shows_ratings`
- `trakt.seasons.ratings` -> `seasons_ratings`
- `trakt.episodes.ratings` -> `episodes_ratings`

### Related

- `trakt.movies.related` -> `movies_related`
- `trakt.shows.related` -> `shows_related`

### Stats

- `trakt.movies.stats` -> `movies_stats`
- `trakt.shows.stats` -> `shows_stats`
- `trakt.seasons.stats` -> `seasons_stats`
- `trakt.episodes.stats` -> `episodes_stats`

### People 

- `trakt.people.summary` -> `people_summary`
- `trakt.people.movies` -> `people_movies`
- `trakt.people.shows` -> `people_shows`


### User functions

- `trakt.user.network`
  - -> `user_followers`
  - -> `user_following`
  - -> `user_friends`
- `trakt.user.collection` -> `user_collection`
- `trakt.user.history` -> `user_history`
- `trakt.user.ratings` -> `user_ratings`
- `trakt.user.stats` -> `user_stats`
- `trakt.user.watched` -> `user_watched`
- `trakt.user.watchlist` -> `user_watchlist`


# tRakt 0.15.0

This is a big one, but not 1.0.0 big one I guess.  
This is a consolidation release with lots of internal improvements, but for the 1.0.0 I decided to overhaul the structure of the package *again*, so before I completely break any kind of backwards compatiblity, I thought I'd get this one out.

## Consolidation for the people

- Major refactor of the docs. Sadly, the user will only notice a little more consistency.
- Consolidate related functions into the same Rd page
- Centrally document common parameters and reuse them where needed
- Also consolidate many similar functions by factoring out the relevant bits into more flexible helper functions. In some cases those are exported as well.
- In the process, some functions where partially renamed (`.show.` -> `.shows.`, `.movie.` -> `.movies.`) for consistency.

- Rename `get_trakt_credentials` -> `trakt_credentials`
- Many functions now return much flatter output, notably `*people*` functions. They return a `list` with `cast` and `crew` objects, which in turn are both flat `tibbles`.

## Features

- Improved search function (`trakt.search`). 
  - If the result has a `year` that is `NA` but a search `score == 1000`, that's probably bad and dropped.
- Added more of the automated list methods, like most anticipated, most played and most watched items.
- Added `trakt.user.history` for user/:id/history methods

# tRakt 0.14.0

Many functions were refactored, which in some cases changes the output.  
Not only do most functions return a `tibble` now, but some additionally computed variables have been removed as well.

## Starting to clean things up with some major housekeeping

- `usethis::use_*` all the things, basically.
- Add a `pkgdown` site and a `README.Rmd`
- Use `codecov`
- Apply `styler::style_pkg()`
- Update documentation to use markdown
- Redo vignette
- Tests. So many tests.

## Less plyr, more purrr

- Completely removed plyr dependency in favor of purrr

# tRakt 0.13.0

- **Rename** `trakt.getEpisodeData` -> `trakt.get_all_episodes`
    * Expand handling of `season_nums` argument to make it easier to get all episodes of a show.
    * Vectorize to enable multiple target input
- **Rename** `trakt.getFullShowData` -> `trakt.get_full_showdata`

# tRakt 0.12.1

- Vectorize `trakt.seasons.summary`
- Fix some bugs
- Improve tests

# tRakt 0.12.0

## API changes, functional fixes

- **Add** `dropunaired` param to `trakt.seasons.summary` (defaults to `TRUE`).
    * Requires `extended` to be more than `min` since the required `aired_episodes` field
    is only present with higher levels of detail.
- **Add** `extended` param to `trakt.user.f*`
- **Fix** `trakt.user.f*` now return `NULL` when the user is private instead of failing.

## Internal changes

- User internal, generalized functions to reduce duplicate code for the following:
    * `trakt.*.popular`
    * `trakt.*.related`
    * `trakt.*.trending`
    * `trakt.*.summary`
    * `trakt.*.ratings`

### Vectorization improvements

- **Add** multiple target input support (vectorization) for:
    * `trakt.user.f*` functions: Results will be `rbind`ed together and a `source_user` column is appended.
    * `trakt.seasons.season`: Soon to make `trakt.getEpisodeData` obsolete.
    * `trakt.*.summary`: Forces `force_data_frame` to `TRUE` to enable `rbind`ing.
    * `trakt.*.related`: Appends `source` column containing respective input `id`.
    * `trakt.*.ratings`: Returns result as a `list` with each entry containing data for each
    show or movie to accommodate the `distribution` variable (`data.frame`)
    * `trakt.people.summary`: Appends `person` column with `target` id.
    * `trakt.*.watching`: Returns `data.frame` with `source` column containing each `target`.

# tRakt 0.11.3

## API changes, functional fixes

- **Add** `build_trakt_url` to ease trakt API URL assembly and reduce duplicate code.
- **Add** `force_data_frame` option to `trakt.*.summary`: Forces unnesting.
- **Rename** `trakt.show.stats` to `trakt.stats`, will work with both movies and shows
as soon as the API endpoint actually works.

## Minor changes

- Expand `@family` tags in docs a little

# tRakt 0.11.2

## API changes, functional fixes

- **Add** `trakt.movie.watching` and `trakt.show.watching`: Get trakt.tv users watching.
- **Add** `trakt.movie.releases`: Gets release dates & certifications per movie.
- **Fix** `trakt.search.byid`: Used to only work on shows, now actually works on movies.
- **Fix** `fix_datetime` (internal): improve reliability.

## Minor changes

- Fix documentation error in `*.movie.*` functions.
- Added tests for new functions

# tRakt 0.11.1

- Internal restructuring (moving functionally similar functions together)
    * **TODO**: Create generic functions for both movie and show functions to reduce duplicate code
- **Add** `extended` param to `trakt.user.watchlist`
- Improve consistency between `trakt.user.watched` and `trakt.user.collection`
    * Rename `slug` to `id.slug`
    * Ensure proper datetime conversion
- **Fix** error in `trakt.user.watchlist` when `type = shows` was ignored by accident


# tRakt 0.11.0

- **Rename** `trakt.getSeasons  -> trakt.seasons.summary` for consistency with the trakt API.
- **Rename** `trakt.show.season -> trakt.seasons.season` for consistency with the trakt API.
- **Rename** `getNameFromUrl    -> parse_trakt_url` to be more descriptive. Also, de-camelCasezation.
- Update vignette to reflect the above changes
- **Add** some `people` functions:
    * `trakt.people.summary`
    * `trakt.people.movies`
    * `trakt.people.shows`
- Unify output of `trakt.show.people` and `trakt.movie.people`
- **Add** `extended` argument to `trakt.movies.related` and `trakt.shows.related` (defaults to `min`)
- **Add** `page` param to [paginated](http://docs.trakt.apiary.io/#introduction/pagination) functions:
    * `trakt.shows.popular`
    * `trakt.shows.trending`
    * `trakt.movies.popular`
    * `trakt.movies.trending`
- The usual bug fixes

# tRakt 0.10.3

- `trakt.user.stats`:  
    * Tidy up rating distribution
    * **Remove** `to.data.frame` option because the output is too messy
- Add another `@family` tag to docs for aggregation functions (`.popular`, `.trending`, `.related`)
- Individual functions don't have to warn about missing headers, that's `trakt.api.call`'s job.
- `trakt.getEpisodeData`:
    * Explicitly drop episodes with `NA` firstaired fields
    * The `episode_abs` field is usually `NA`, so let's dump `epnum` on it
- Use `extended = "min"` as default across functions for consistency with the trakt API

# tRakt 0.10.2

- Add `year` parameter to `trakt.search`
- If `query` in `trakt.search` ends with a 4 digit number, this will be used as `year` parameter and stripped from the original `query`
- Minor internal fixes

# tRakt 0.10.1

- Add `testthat` tests
- Internal changes to how/where datetime variables are converted (user doesn't see any of that)
    * If `lubridate::parse_date_time` fails, `as.POSIXct` is used as a fallback
- Various bug fixes

# tRakt 0.10.0

- **Add** movie functions:
    * `trakt.movies.popular`: Analogous to `trakt.shows.popular`
    * `trakt.movies.trending`: Analogous to `trakt.shows.trending`
    * `trakt.movie.summary`: Get a single movie's details, analogous to `trakt.show.summary`
    * `trakt.movies.related`: Get related movies
    * `trakt.movie.people`: Analogous to `trakt.show.people`
- **Add** both `trakt.show.ratings` and `trakt.movie.ratings` to receive just the ratings and distribution for a single show or movie
- **Rename** `trakt.show.related` -> `trakt.shows.related` for consistency with `.trending` and `.popular`
- Expand allowed `target` params in accordance with changed trakt API docs

# tRakt 0.9.0

- Specified more exclusive package version requirements to avoid unforseen errors
- Add `trakt.user.ratings`: Currently supported types: `shows`, `movies`, `episodes`
- Add `extended` option to `trakt.shows.popular` and `.trending`
- Make code in vignette a little more robust

# tRakt 0.8.1

- Fix a whole bunch of typos I only found *after* the CRAN release, naturally
- Improve consistency across functions
    * The date fields ending in `.posix` have been removed and the existing date fiels are now converted to `POSIXct` to remove cluttering
    * `firstaired.posix` -> `first_aired` etc
- Update vignette for the above change

# tRakt 0.8.0

- Added more user-facing functions (`trakt.user.following` / `.followers` / `.friends`) because maybe I want to throw [networkD3](https://github.com/christophergandrud/networkD3) at my people
- Improve consistency with date variables: The `.posix` variables should be removed and the existing date variables should just be properly converted to `POSIXct`
- Improve documentation: Added `@family` tags to all functions to group them together
- Add a package vignette
- Minor fixes and non-breaking additions
- Trying to keep things organized and all I got was this inconsistently header'd NEWS.md

# tRakt 0.0.1

## 2015-02-16

I've been working on some user-specific methods, so you can now use the `trakt.user.*` family of functions to get a user's…

- Collection: `trakt.user.collection()`
- Watched items: `trakt.user.watched()`
- Stats: `trakt.user.stats()`

All of them default to the username set in `getOption("trakt.username")`, but any publicly viewable user should work. Note that OAuth2 is not implemented, so private users can't be accessed.

## 2015-02-11

As of today, all the functions are updated to use the new APIv2, except for `trakt.show.stats`,
which is currently not yet implemented at trakt.tv, see [their docs](http://docs.trakt.apiary.io/reference/shows/stats/get-show-stats)

Now the package is usable again, and I can continue to work on bug fixes and enhancements. Yay.

## 2015-02-10

I am now trying to migrate everything to the [new trakt.tv APIv2](http://docs.trakt.apiary.io/).
Since I mostly don't know what I'm doing, I have to make this up as I go along, but oh well.
Now the search function `trakt.search` should be working fine, as it is the only function
that is tested/built with the new API in mind. Others to come.
