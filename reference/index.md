# Package index

## This package

- [`tRakt`](https://jemus42.github.io/tRakt/reference/tRakt-package.md)
  [`tRakt-package`](https://jemus42.github.io/tRakt/reference/tRakt-package.md)
  : tRakt: Get Data from 'trakt.tv'

## Basic API interaction

These functions are basic building blocks, you don’t have to use them
directly.

- [`trakt_get()`](https://jemus42.github.io/tRakt/reference/trakt_get.md)
  : Make an API call and receive parsed output
- [`trakt_credentials()`](https://jemus42.github.io/tRakt/reference/trakt_credentials.md)
  : trakt.tv credentials
- [`tRakt_sitrep()`](https://jemus42.github.io/tRakt/reference/tRakt_sitrep.md)
  : tRakt sitrep

### Search – Finding media

Searching for items is usually required to retrieve some kind of ID,
like the `slug`, which is required for use of item-specific functions.

- [`search_query()`](https://jemus42.github.io/tRakt/reference/search_query.md)
  [`search_id()`](https://jemus42.github.io/tRakt/reference/search_query.md)
  : Search trakt.tv via text query or ID

## Shows and Movies

### Things that are popular, trending, anticipated, …

- [`movies_anticipated()`](https://jemus42.github.io/tRakt/reference/anticipated_media.md)
  [`shows_anticipated()`](https://jemus42.github.io/tRakt/reference/anticipated_media.md)
  : Anticipated media
- [`movies_collected()`](https://jemus42.github.io/tRakt/reference/collected_media.md)
  [`shows_collected()`](https://jemus42.github.io/tRakt/reference/collected_media.md)
  : Most collected media
- [`comments_trending()`](https://jemus42.github.io/tRakt/reference/comments_trending.md)
  [`comments_recent()`](https://jemus42.github.io/tRakt/reference/comments_trending.md)
  : Get trending or recently made comments
- [`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md)
  [`lists_trending()`](https://jemus42.github.io/tRakt/reference/lists_popular.md)
  : Get popular / trending lists
- [`movies_watching()`](https://jemus42.github.io/tRakt/reference/media_watching.md)
  [`shows_watching()`](https://jemus42.github.io/tRakt/reference/media_watching.md)
  [`seasons_watching()`](https://jemus42.github.io/tRakt/reference/media_watching.md)
  [`episodes_watching()`](https://jemus42.github.io/tRakt/reference/media_watching.md)
  : Get who's watching a thing right now
- [`movies_played()`](https://jemus42.github.io/tRakt/reference/played_media.md)
  [`shows_played()`](https://jemus42.github.io/tRakt/reference/played_media.md)
  : Most played media
- [`movies_popular()`](https://jemus42.github.io/tRakt/reference/popular_media.md)
  [`shows_popular()`](https://jemus42.github.io/tRakt/reference/popular_media.md)
  : Popular media
- [`movies_trending()`](https://jemus42.github.io/tRakt/reference/trending_media.md)
  [`shows_trending()`](https://jemus42.github.io/tRakt/reference/trending_media.md)
  : Trending media
- [`movies_watched()`](https://jemus42.github.io/tRakt/reference/watched_media.md)
  [`shows_watched()`](https://jemus42.github.io/tRakt/reference/watched_media.md)
  : Most watched media

### Single-item summary data

- [`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md)
  : Get a single episode's details
- [`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md)
  : Get a single movie
- [`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md)
  : Get a single person's details
- [`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md)
  : Get a show's seasons
- [`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md)
  : Get a single show

### Seasons and episodes

- [`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md)
  : Get a show's seasons
- [`seasons_season()`](https://jemus42.github.io/tRakt/reference/seasons_season.md)
  : Get a season of a show
- [`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md)
  : Get a season of a show
- [`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md)
  [`shows_last_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md)
  : Get a shows next or latest episode

### Movie-specific data

- [`movies_boxoffice()`](https://jemus42.github.io/tRakt/reference/movies_boxoffice.md)
  : Get the weekend box office
- [`movies_releases()`](https://jemus42.github.io/tRakt/reference/movies_releases.md)
  : Get a movie's release details

### Media ratings

These functions return the full rating distribution for an item, in
contrast to the `_summary`-methods, which return the average rating of
an item.

- [`shows_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md)
  [`movies_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md)
  [`seasons_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md)
  [`episodes_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md)
  : Media user ratings

### Media stats

These functions return the number of watchers, plays, collectors,
comments, lists and votes of an item.

- [`shows_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md)
  [`movies_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md)
  [`seasons_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md)
  [`episodes_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md)
  : Get a show or movie's (or season's or episode's) stats

### Related media

Media related to media.

- [`movies_related()`](https://jemus42.github.io/tRakt/reference/movies_related.md)
  : Get similiar(ish) movies
- [`shows_related()`](https://jemus42.github.io/tRakt/reference/shows_related.md)
  : Get similiar(ish) shows

## People – Cast & Crew

Cast and crew for media items, as well as the reverse; credits for
people.

- [`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md)
  : Get a single person's details
- [`movies_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)
  [`shows_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)
  [`seasons_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)
  [`episodes_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)
  [`people_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)
  : Get lists containing a movie, show, season, episode or person
- [`people_movies()`](https://jemus42.github.io/tRakt/reference/people_media.md)
  [`people_shows()`](https://jemus42.github.io/tRakt/reference/people_media.md)
  : Get a single person's movie or show credits
- [`movies_people()`](https://jemus42.github.io/tRakt/reference/media_people.md)
  [`shows_people()`](https://jemus42.github.io/tRakt/reference/media_people.md)
  [`seasons_people()`](https://jemus42.github.io/tRakt/reference/media_people.md)
  [`episodes_people()`](https://jemus42.github.io/tRakt/reference/media_people.md)
  : Get the cast and crew of a show or movie

## Users

Access user-specific data. This is only possible if the user in question
has a public profile *or* authentication is available and you are
friends.

- [`user_collection()`](https://jemus42.github.io/tRakt/reference/user_collection.md)
  : Get a user's collected shows or movies
- [`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md)
  : Get a user's comments
- [`user_history()`](https://jemus42.github.io/tRakt/reference/user_history.md)
  : Get a user's watch history
- [`user_likes()`](https://jemus42.github.io/tRakt/reference/user_likes.md)
  : Get items (comments, lists) a user likes
- [`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md)
  : Get a single list
- [`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md)
  : Get comments on a user-created list
- [`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md)
  : Get a user's list's items
- [`user_lists()`](https://jemus42.github.io/tRakt/reference/user_lists.md)
  : Get a user's lists
- [`user_followers()`](https://jemus42.github.io/tRakt/reference/user_network.md)
  [`user_following()`](https://jemus42.github.io/tRakt/reference/user_network.md)
  [`user_friends()`](https://jemus42.github.io/tRakt/reference/user_network.md)
  : Get a user's social connections
- [`user_profile()`](https://jemus42.github.io/tRakt/reference/user_profile.md)
  : Get a user's profile
- [`user_ratings()`](https://jemus42.github.io/tRakt/reference/user_ratings.md)
  : Get a user's ratings
- [`user_stats()`](https://jemus42.github.io/tRakt/reference/user_stats.md)
  : Returns stats about the movies, shows, and episodes a user has
  watched, collected, and rated.
- [`user_watched()`](https://jemus42.github.io/tRakt/reference/user_watched.md)
  : Get a user's watched shows or movies
- [`user_watchlist()`](https://jemus42.github.io/tRakt/reference/user_watchlist.md)
  : Get a user's watchlist

## Miscellaneous content

### Lists

Watchlists or topical lists created by trakt.tv users. These can contain
all kinds of media types, from movies to episodes to people.

- [`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md)
  [`lists_trending()`](https://jemus42.github.io/tRakt/reference/lists_popular.md)
  : Get popular / trending lists
- [`movies_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)
  [`shows_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)
  [`seasons_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)
  [`episodes_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)
  [`people_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)
  : Get lists containing a movie, show, season, episode or person
- [`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md)
  : Get a single list
- [`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md)
  : Get comments on a user-created list
- [`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md)
  : Get a user's list's items
- [`user_lists()`](https://jemus42.github.io/tRakt/reference/user_lists.md)
  : Get a user's lists
- [`user_watchlist()`](https://jemus42.github.io/tRakt/reference/user_watchlist.md)
  : Get a user's watchlist

### Comments

- [`comments_comment()`](https://jemus42.github.io/tRakt/reference/comments_comment.md)
  [`comments_replies()`](https://jemus42.github.io/tRakt/reference/comments_comment.md)
  [`comments_likes()`](https://jemus42.github.io/tRakt/reference/comments_comment.md)
  [`comments_item()`](https://jemus42.github.io/tRakt/reference/comments_comment.md)
  : Get a single comment
- [`comments_trending()`](https://jemus42.github.io/tRakt/reference/comments_trending.md)
  [`comments_recent()`](https://jemus42.github.io/tRakt/reference/comments_trending.md)
  : Get trending or recently made comments
- [`comments_updates()`](https://jemus42.github.io/tRakt/reference/comments_updates.md)
  : Get recently updated/edited comments
- [`movies_comments()`](https://jemus42.github.io/tRakt/reference/media_comments.md)
  [`shows_comments()`](https://jemus42.github.io/tRakt/reference/media_comments.md)
  [`seasons_comments()`](https://jemus42.github.io/tRakt/reference/media_comments.md)
  [`episodes_comments()`](https://jemus42.github.io/tRakt/reference/media_comments.md)
  : Get all comments of a thing
- [`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md)
  : Get a user's comments
- [`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md)
  : Get comments on a user-created list

### Localization

- [`movies_aliases()`](https://jemus42.github.io/tRakt/reference/media_aliases.md)
  [`shows_aliases()`](https://jemus42.github.io/tRakt/reference/media_aliases.md)
  : Get all movie / show aliases
- [`movies_translations()`](https://jemus42.github.io/tRakt/reference/media_translations.md)
  [`shows_translations()`](https://jemus42.github.io/tRakt/reference/media_translations.md)
  [`episodes_translations()`](https://jemus42.github.io/tRakt/reference/media_translations.md)
  : Get translations for a movie, show or episode

### Utilities

Included for convenience.

- [`build_trakt_url()`](https://jemus42.github.io/tRakt/reference/build_trakt_url.md)
  : Assemble a trakt.tv API URL
- [`pad_episode()`](https://jemus42.github.io/tRakt/reference/pad_episode.md)
  : Easy episode number padding

## Included Data

### Episode datasets

For demonstration purposes.

- [`futurama`](https://jemus42.github.io/tRakt/reference/futurama.md) :
  Futurama episodes
- [`gameofthrones`](https://jemus42.github.io/tRakt/reference/gameofthrones.md)
  : Game of Thrones episodes

### Internal datasets

These are unlikely to be useful on their own, but they are useful as a
reference for optional filters.

- [`trakt_genres`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  [`trakt_languages`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  [`trakt_networks`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  [`trakt_countries`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  [`trakt_certifications`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)
  : Cached filter datasets
