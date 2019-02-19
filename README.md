
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tRakt

[![Travis build
status](https://travis-ci.org/jemus42/tRakt.svg?branch=master)](https://travis-ci.org/jemus42/tRakt)
[![Coverage
status](https://codecov.io/gh/jemus42/tRakt/branch/master/graph/badge.svg)](https://codecov.io/github/jemus42/tRakt?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/tRakt)](https://cran.r-project.org/package=tRakt)

This is `tRakt` version `0.13.0`.  
It contains functions to pull data from [trakt.tv](http://trakt.tv/).

It’s an [R package](http://r-project.org) primarily used by (i.e. build
for) [this webapp](http://trakt.jemu.name), but you can fiddle around
with it if you like.  
There might be some interesting things to play around with, and I’ve
tried some of them [here](http://dump.jemu.name/tRakt-Usage.html) (Also
included as a package vignette).

## Installation

Get it from GitHub:

    if (!require("remotes")) install.packages("remotes")
    remotes::install_github("jemus42/tRakt")
    library("tRakt")

## Setting credentials

The APIv2 requires at least a `client id` for the API calls.  
Calling `get_trakt_credentials()` will set everything up for you, but
you either have to manually plug your values in (see
`?get_trakt_credentials()`), or have a `key.json` sitting either in the
working directory or in `~/.config/trakt/key.json`.  
It should look like this:

    {
      "username": "yourusername",
      "client.id": "<APIv2 client id>"
    }

  - `username` Optional. For functions that pull a user’s watched shows
    or stats (`trakt.user.*`)
  - `client.id` Required. It’s used in the HTTP headers for the API
    calls, which is kind of a biggie.

To get your credentials, [you have to have an (approved) app over at
trakt.tv](http://trakt.tv/oauth/applications).  
Don’t worry, it’s really easy to set up. Even I did it.

### Use my app’s client.id as a fallback

As a convenience for you, and also to make automated testing a little
easier, `get_trakt_credentials()` automatically sets my `client.id` as a
fallback, so you theoretically never need to supply your own
credentials. However, if you want to actually use this package for some
project, I do not recommend relying on my credentials. That would make
me a sad panda.

# CoC

Please note that the \[34m’tRakt’\[39m project is released with a
[Contributor Code of Conduct](.github/CODE_OF_CONDUCT.md). By
contributing to this project, you agree to abide by its terms.
