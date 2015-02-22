tRakt
=============

This is `tRakt` version `0.8.0`.  
It contains functions to pull data from [trakt.tv](http://trakt.tv/), focusing on tv shows.

It's an [R package](http://r-project.org) primarily used by (i.e. build for) [this webapp](http://trakt.jemu.name), but you can fiddle around with it if you like.  
There might be some interesting things to play around with, and I've tried some of them [here](http://dump.jemu.name/tRakt-Usage.html) (Also included as a package vignette).

## Installation

If the package finally makes it to [CRAN](http://cran.r-project.org), you can install it via

    install.packages("tRakt")

Until then, or just to get the latest dev version from GitHub, run the following:

	if (!require("devtools")) install.packages("devtools")
	devtools::install_github("jemus42/tRakt-package")
	library("tRakt")

## Setting credentials

The APIv2 requires at least a `client id` for the API calls.  
Calling `get_trakt_credentials()` will set everything up for you, but you either have to 
manually plug your values in (see `?get_trakt_credentials()`), or have a `key.json` sitting either in the working directory or in `~/.config/trakt/key.json`.  
It should look like this:

    {
      "username": "yourusername",
      "client.id": "<APIv2 client id>",
      "client.secret": "<APIv2 client secret>"
    }

* `username` Optional. For functions that pull a user's watched shows or stats (`trakt.user.*`)
* `client.id` Required. It's used in the HTTP headers for the API calls, which is kind of a biggie. 
* `client.secret` NYI. Is only required for `OAuth2` methods, and I don't really intend on using those unless I *really really* have to.  

To get your credentials, [you have to have an (approved) app over at trakt.tv](http://trakt.tv/oauth/applications).  
Don't worry, it's really easy to set up. Even I did it.

### Use my apps client.id

If you don't want to create an app, I've been told it's okay to supply my app's client.id, 
so you can run the following:

`get_trakt_credentials(client.id = "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2")`
