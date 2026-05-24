tRakt is an R package wrapping the https://trakt.tv API.

The primary motivation is data retrieval and analysis. Other API functionality is added secondarily where it makes sense.

In scope:
- Retrieve data for movies, shows, seasons, episodes, people, users, lists, comments

Secondary scope (partially implemented):
- Modifying and creating lists

Tertiary scope (not yet implemented):
- Mark media as watched (at a specific date/time)
- Mark media as unwatched / remove a specific watch entry

Out of scope:
- Posting comments
- Scrobbling
- Check-in

## General notes

- Return values are flat `data.frame`-like objects (tibbles) wherever feasible.
- When flattening is impractical, list-columns are preferred. In rare cases, pure lists with nested elements are returned.

## Development guidelines

- A task is considered complete only if the package is in a working state, defined as:
  - documented (`devtools::document()`)
  - passing tests (`devtools::test()`)
  - passing R CMD check (`devtools::check()`), which also runs tests and additionally validates package structure, examples in function docs, etc.
- Errors and warnings from `R CMD check` are not acceptable. Notes are acceptable only in rare cases and should be cleared before releases.
- Every user-facing change gets a bullet in `NEWS.md`.
- Code is formatted with `air format .` (see `air.toml`).
- New exported functions/objects must be added to the pkgdown reference index in `_pkgdown.yml`.
- The `Makefile` has targets for the common workflows (`make doc`, `make test`, `make check`, `make build`, `make site`, `make coverage`, `make format`).

## trakt.tv API

- Official docs: https://trakt.docs.apiary.io/ — a JavaScript SPA, not machine-readable. The plain-text blueprint is mirrored at `./api/trakt.apib` and can be refreshed by downloading https://trakt.docs.apiary.io/api-description-document with `curl`.
- OpenAPI spec: https://api.apis.guru/v2/specs/trakt.tv/1.0.0/openapi.json (possibly outdated — see e.g. https://github.com/trakt/trakt-api/discussions/701).
- GitHub repo: https://github.com/trakt/trakt-api.

Implemented API methods are catalogued in `inst/api-methods.yml`, which feeds the documentation vignette `vignettes/Implemented-API-methods.Rmd`.

The trakt.tv API evolves regularly. Drift detection and rapid adaptation matter — keep documentation, tests, and unpacking helpers in sync with upstream changes.

- `httr2` is the HTTP layer.
  - API credentials are secret and must never appear in git-tracked files, except for the package-bundled scrambled `client_id`/`client_secret` in `R/zzz.R`.
  - Responses can be large; tests should use small subsets, and `httr2`'s on-disk cache (via `req_cache()`) is enabled by default.
- `inst/api-methods.yml` is the source of truth for coverage tracking. Add new endpoints there when implementing them.

### The `extended` parameter

The API defines two valid values for `extended`:
- `full` — "Complete info for an item" (overview, ratings, votes, air dates, etc.)
- `metadata` — "Additional video and audio info" (collection endpoints only)

**`min` is NOT a valid API value.** The default response (no `extended` param) returns minimal info (title, year, ids). The package exposes `extended = c("min", "full")` as a convenience — when `"min"` is selected, the package omits the `extended` query parameter entirely.

Multiple values can be combined comma-separated: `?extended=full,noseasons`.

### OAuth token handling

As of 2025-03-20, OAuth access tokens expire in **24 hours** (previously 3 months). Apps must handle automatic token refresh via `refresh_token`. See: https://github.com/trakt/trakt-api/discussions/495.

### Response structure notes

A November 2025 API infrastructure change affected caching behavior and added/altered several response fields (see https://github.com/trakt/trakt-api/issues/665). An early-2026 change reworked `seasons/:id/ratings` into a multi-source object. Key structural points:

- **IDs**: The `ids` object may contain a nested `plex` sub-object with `guid` and optionally `slug`. Shows/movies have both `plex.guid` and `plex.slug`; seasons/episodes only have `plex.guid`. `fix_ids()` flattens these to `plex_guid` / `plex_slug` columns, only creating columns for fields that exist.
- **Nested fields dropped globally**: `images` and `colors` (on shows, movies, people) are nested objects not suitable for tabular output. `fix_tibble_response()` drops them unless `extended = "images"` is requested explicitly.
- **People**: `social_ids` (twitter, facebook, instagram, wikipedia) is flattened to `social_*` columns in `people_summary()`.
- **Shows/movies**: `subgenres` (array), `tagline`, `original_title` may appear. `subgenres` is handled as a list column like `genres`.
- **Empty responses**: Some endpoints return HTTP 204 / empty body (e.g. next episode for ended shows). `trakt_get()` handles this by returning an empty `tibble()`.
- **Multi-source ratings**: `seasons/:id/ratings` returns one sub-object per source (`trakt`, `tmdb`, `imdb`, `metascore`, `rotten_tomatoes`). `unpack_ratings_sources()` promotes the `trakt` sub-object's fields to the top level and surfaces external scores as `<source>_<field>` columns. `shows/:id/ratings`, `movies/:id/ratings`, and `episodes/:id/ratings` are still flat as of this writing.
- **User embedding**: When user data is embedded alongside media or list data (`*_lists()`, `user_lists()`, comments, etc.), `unpack_user()` renames the user's own `trakt` id to `user_trakt` and `slug` to `user_slug` to avoid colliding with media/list ids.

### Key internal functions

- `trakt_get()` (`R/api-requests.R`): core API request function — auth, caching, retries, empty-response handling.
- `fix_ids()` (`R/utils-fix.R`): flattens nested ID objects including `plex`. Drops `tvrage`. Converts all IDs to character.
- `fix_tibble_response()` (`R/utils-fix.R`): global cleanup pipeline — drops `images`/`colors`, fixes datetimes, fixes ratings, removes rownames.
- `unpack_show()` / `unpack_movie()` (`R/utils-unpack.R`): flatten nested media objects into tibble-friendly format.
- `flatten_single_media_object()` (`R/utils-unpack.R`): single-item responses (summaries). Handles list columns, discards nested objects.
- `unpack_user()` (`R/utils-unpack.R`): flattens embedded user objects, renaming `trakt`/`slug` to `user_trakt`/`user_slug`.
- `unpack_ratings_sources()` (`R/utils-fix.R`): handles the multi-source ratings shape for seasons.
- `build_trakt_url()` (`R/utils-misc.R`): constructs API URLs. Named args become query params; unnamed args are joined as path segments.
- `map_rbind()` (`R/utils-misc.R`): maps over vector inputs and row-binds results. Used for multi-ID/multi-user vectorisation. **When using it for recursive vectorisation, always pass forwarded arguments by name** — positional arg-order bugs in inner calls have been a recurring source of silent failures.

## Testing

- `testthat` 3e is used throughout — relies on its self-sufficient-tests model.
- The `vcr` package records and replays HTTP interactions:
  - Cassettes live under `tests/testthat/_vcr/` (the `vcr` v2 default).
  - `re_record_interval` is set to 30 days in `setup-vcr.R` so the suite catches API drift automatically.
  - When cassettes are re-recorded, assertions may need updating — prefer `expect_tibble(min_cols = ...)` over exact column counts to stay resilient to new API fields.
  - When debugging a vcr-related failure, check the cassette's URI list (`grep "uri:" <cassette>`) — accumulated bogus URIs from past code states are a common smell.
- Unit tests for internal utilities (`fix_ids`, `unpack_show`, etc.) use synthetic data and do not depend on vcr — they act as a safety net when cassettes are stale.
- `expect_tibble()` is defined in `tests/testthat/helper-api-tests.R`. Use it with `min_cols` to assert presence of expected columns, and `exact_rows` when the row count is predictable.

## General development tasks

Development workflows go through the `devtools` package. See the `Makefile` for the common one-liners.
