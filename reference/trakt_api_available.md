# Check whether the trakt.tv API is reachable

A lightweight connectivity check that performs a single, small request
to a stable endpoint with a short timeout. It is primarily used to guard
runnable documentation examples (via roxygen2's `@examplesIf`) so they
are executed when the API is available but quietly skipped when it is
not — avoiding spurious failures from transient API outages or a missing
internet connection.

## Usage

``` r
trakt_api_available()
```

## Value

`logical(1)`: `TRUE` if the API responds successfully, else `FALSE`.

## Details

This function never throws: it returns `FALSE` on any error (offline,
timeout, non-success status, ...) and does not retry.

## See also

Other API-basics:
[`trakt_get()`](https://jemus42.github.io/tRakt/reference/trakt_get.md)

## Examples

``` r
# Returns TRUE or FALSE, never errors:
trakt_api_available()
#> [1] TRUE
```
