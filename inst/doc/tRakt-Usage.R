## ----Startup-------------------------------------------------------------
suppressPackageStartupMessages(library(tRakt)) 
suppressPackageStartupMessages(library(dplyr)) # For convenience
library(ggplot2) # For plotting (duh)
library(knitr)   # for knitr::kable, used to render simple tables

# If you don't have a client.id defined in a key.json, use mine
if (is.null(getOption("trakt.client.id"))){
  get_trakt_credentials(client.id = "12fc1de7671c7f2fb4a8ac08ba7c9f45b447f4d5bad5e11e3490823d629afdf2")
}

## ----Search--------------------------------------------------------------
# Search via text query
show1  <- trakt.search("Game of Thrones")

# Search via ID (trakt id is used by default)
show2 <- trakt.search.byid(1390) # trakt id of Game of Thrones

# The returned data is identical
identical(show1, show2)

## ----Data_pulls----------------------------------------------------------
# Search a show and receive basic info
show          <- trakt.search("Breaking Bad")
# Save the slug of the show, that's needed for other functions as an ID
slug          <- show$ids$slug
slug

# Get the season & episode data
show.seasons  <- trakt.getSeasons(slug) # How many seasons are there?
show.episodes <- trakt.getEpisodeData(slug, show.seasons$season, extended = "full")

# Glimpse at data (only some columns each)
rownames(show.seasons) <- NULL # This shouldn't be necessary
show.seasons[c(1, 3, 4)] %>% kable

show.episodes[c(1:3, 6, 7, 17)] %>% head(10) %>% kable

## ----Graphing_1, fig.align = 'center', fig.width = 9---------------------
show.episodes$episode_abs <- 1:nrow(show.episodes) # I should probably do that for you.
show.episodes %>%
  ggplot(aes(x = episode_abs, y = rating, colour = season)) +
    geom_point(size = 3.5, colour = "black") +
    geom_point(size = 3) + 
    geom_smooth(method = lm, se = F) +
    labs(title = "Trakt.tv Ratings of Breaking Bad", 
         y = "Rating", x = "Episode (absolute)", colour = "Season")

show.episodes %>%
  ggplot(aes(x = episode_abs, y = votes, colour = season)) +
    geom_point(size = 3.5, colour = "black") +
    geom_point(size = 3) + 
    labs(title = "Trakt.tv User Votes of Breaking Bad Episodes", 
         y = "Votes", x = "Episode (absolute)", colour = "Season")

show.episodes %>%
  ggplot(aes(x = episode_abs, y = scale(rating), fill = season)) +
    geom_bar(stat = "identity", colour = "black", position = "dodge") +
    labs(title = "Trakt.tv User Ratings of Breaking Bad Episodes\n(Scaled using mean and standard deviation)", 
         y = "z-Rating", x = "Episode (absolute)", fill = "Season")

## ----get_user_data-------------------------------------------------------
# Get a detailed list of shows/episodes I watched
myeps    <- trakt.user.watched(user = "jemus42", type = "shows.extended")

# Get a feel for the data
myeps %>% 
  arrange(desc(last_watched_at)) %>% 
  head(5) %>% 
  kable

# …and the movies in my trakt.tv collection
mymovies <- trakt.user.collection(user = "jemus42", type = "movies")

mymovies %>%
  select(title, year, collected_at) %>%
  arrange(collected_at) %>%
  head(5) %>%
  kable

## ------------------------------------------------------------------------
myeps %>% 
  group_by(title) %>% 
  summarize(days = round(max(last_watched_at) - min(last_watched_at))) %>%
  arrange(desc(days)) %>%
  head(10) %>%
  kable

