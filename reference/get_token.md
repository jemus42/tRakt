# Get a trakt.tv API OAuth token

This is an unfortunately home-brewed version of what *should* be a
simple call to
[`httr2::oauth_flow_device()`](https://httr2.r-lib.org/reference/req_oauth_device.html),
but since the \<trakt.tv\> API plays ever so slightly fast and mildly
loose with RFC 8628, that's not possible.

## Usage

``` r
get_token(cache = TRUE)
```

## Arguments

- cache:

  [`TRUE`](https://rdrr.io/r/base/logical.html): Cache the token to the
  OS-specific cache directory. See
  [`rappdirs::user_cache_dir()`](https://rappdirs.r-lib.org/reference/user_cache_dir.html).

## Note

RFC 8628 expects the device token request to have the field
"device_code", but the trakt.tv API expects a field named "code". That's
it. It's kind of silly.

## Examples

``` r
if (FALSE) {
get_token()
}
```
