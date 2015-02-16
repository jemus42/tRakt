tRakt
=============

This is `tRakt` version `0.7.2`.  
It contains functions to pull data from [trakt.tv](http://trakt.tv/), focusing on tv shows.

It's an [R package](http://r-project.org) primarily used by (i.e. build for) [this webapp](http://trakt.jemu.name), but you can fiddle around with it if you like.

## Installation

	if (!require("devtools")){
	  install.packages("devtools")
	} 
	devtools::install_github("jemus42/tRakt-package")
	library("tRakt")
	

## Status

### 2015-02-11

As of today, all the functions are updated to use the new APIv2, except for `trakt.show.stats`,
which is currently not yet implemented at trakt.tv, see [their docs](http://docs.trakt.apiary.io/reference/shows/stats/get-show-stats)

Now the package is usable again, and I can continue to work on bug fixes and enhancements. Yay.

### 2015-02-10

I am now trying to migrate everything to the [new trakt.tv APIv2](http://docs.trakt.apiary.io/).  
Since I mostly don't know what I'm doing, I have to make this up as I go along, but oh well.
Now the search function `trakt.search` should be working fine, as it is the only function
that is tested/built with the new API in mind. Others to come.

## Setting credentials

The APIv2 requires at least a `client id` for the API calls.  
Calling `get_trakt_credentials()` will set everything up for you, but you either have to 
manually plug your values in (see `?get_trakt_credentials()`), or have a `key.json` sitting either in the working directory or in `~/.config/trakt.key.json`.  
It should look like this:

    {
      "username": "yourusernamelol",
      "client.id": "<APIv2 client id>",
      "client.secret": "<APIv2 client secret>"
    }

* `username` Optional. For functions that pull a user's watched shows or stats.
* `client.id` Required. It's used in the HTTP headers for the API calls, which is kind of a biggie. 
* `client.secret` NYI. Is only required for `OAuth2` methods, and I don't really intend on using those unless I *really really* have to.  

To get your credentials, [you have to have an (approved) app over at trakt.tv](http://trakt.tv/oauth/applications).  
Don't worry, it's really easy to set up. Even I did it.




