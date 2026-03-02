# Get the client secret from the environment

Get's the client secrete either from the environment variable
`trakt_client_secret`, or from the environment variable `tRakt_key`,
which holds an encryption key to decrypt the packaged encrypted secret.

## Usage

``` r
get_client_secret()
```

## Note

See
<https://httr2.r-lib.org/articles/wrapping-apis.html#package-keys-and-secrets>
