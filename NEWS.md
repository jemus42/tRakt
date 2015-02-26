## tRakt News

### v0.10.2

* Add `year` parameter to `trakt.search`
* If `query` in `trakt.search` ends with a 4 digit number, this will be used as `year` parameter and stripped from the original `query`
* Minor internal fixes

### v0.10.1
 
* Add `testthat` tests
* Internal changes to how/where datetime variables are converted (user doesn't see any of that)
    * If `lubridate::parse_date_time` fails, `as.POSIXct` is used as a fallback 
* Various bug fixes

### v0.10.0

* **Add** movie functions:
    * `trakt.movies.popular`: Analogous to `trakt.shows.popular`
    * `trakt.movies.trending`: Analogous to `trakt.shows.trending`
    * `trakt.movie.summary`: Get a single movie's details, analogous to `trakt.show.summary`
    * `trakt.movies.related`: Get related movies
    * `trakt.movie.people`: Analogous to `trakt.show.people`
* **Add** both `trakt.show.ratings` and `trakt.movie.ratings` to receive just the ratings and distribution for a single show or movie
* **Rename** `trakt.show.related` -> `trakt.shows.related` for consistency with `.trending` and `.popular`
* Expand allowed `target` params in accordance with changed trakt API docs

### v0.9.0

* Specified more exclusive package version requirements to avoid unforseen errors
* Add `trakt.user.ratings`: Currently supported types: `shows`, `movies`, `episodes`
* Add `extended` option to `trakt.shows.popular` and `.trending`
* Make code in vignette a little more robust

### v0.8.1

* Fix a whole bunch of typos I only found *after* the CRAN release, naturally
* Improve consistency across functions
    * The date fields ending in `.posix` have been removed and the existing date fiels are now converted to `POSIXct` to remove cluttering
    * `firstaired.posix` -> `first_aired` etc
* Update vignette for the above change

### v0.8.0

* Added more user-facing functions (`trakt.user.following` / `.followers` / `.friends`) because maybe I want to throw [networkD3](https://github.com/christophergandrud/networkD3) at my people
* Improve consistency with date variables: The `.posix` variables should be removed and the existing date variables should just be properly converted to `POSIXct`
* Improve documentation: Added `@family` tags to all functions to group them together
* Add a package vignette
* Minor fixes and non-breaking additions
* Trying to keep things organized and all I got was this inconsistently header'd NEWS.md

### 2015-02-16

I've been working on some user-specific methods, so you can now use the `trakt.user.*` family of functions to get a user's…

* Collection: `trakt.user.collection()`
* Watched items: `trakt.user.watched()`
* Stats: `trakt.user.stats()`

All of them default to the username set in `getOption("trakt.username")`, but any publicly viewable user should work. Note that OAuth2 is not implemented, so private users can't be accessed.

### 2015-02-11

As of today, all the functions are updated to use the new APIv2, except for `trakt.show.stats`,
which is currently not yet implemented at trakt.tv, see [their docs](http://docs.trakt.apiary.io/reference/shows/stats/get-show-stats)

Now the package is usable again, and I can continue to work on bug fixes and enhancements. Yay.

### 2015-02-10

I am now trying to migrate everything to the [new trakt.tv APIv2](http://docs.trakt.apiary.io/).
Since I mostly don't know what I'm doing, I have to make this up as I go along, but oh well.
Now the search function `trakt.search` should be working fine, as it is the only function
that is tested/built with the new API in mind. Others to come.
