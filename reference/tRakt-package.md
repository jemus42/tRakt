# tRakt: Get Data from 'trakt.tv'

A wrapper for the <https://trakt.tv> API to retrieve data about shows
and movies, including user ratings, credits and related metadata.
Additional functions retrieve user-specific information including
collections and history of watched items. A full API reference is
available at <https://trakt.docs.apiary.io>.

## Package options

- `tRakt_debug`: `logical(1)`: Should debug output be enabled? Default
  is `FALSE`.

- `tRakt_cache_dir`: `character(1)`: Where should the cache be stored?

- `tRakt_cache_max_age`: `numeric(1)`: How long should the cache be
  kept, in seconds? Default is one week (604800 seconds).

- `tRakt_cache_max_size`: `numeric(1)`: How big should the cache be, in
  bytes? Default is 100MB (100 \* 1000^2 bytes).

All options can be overriden with environment variables of the same
name. See
[`tRakt_sitrep()`](https://jemus42.github.io/tRakt/reference/tRakt_sitrep.md)
to view the current value of all options.

## See also

Useful links:

- <https://jemus42.github.io/tRakt>

- <https://github.com/jemus42/tRakt>

- Report bugs at <http://github.com/jemus42/tRakt/issues>

## Author

**Maintainer**: Lukas Burk <github@quantenbrot.de>
([ORCID](https://orcid.org/0000-0001-7528-3795))
