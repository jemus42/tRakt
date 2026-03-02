# Implemented API methods

This is a reference list of [API methods
available](https://trakt.docs.apiary.io/), their endpoint URLs (with
user-specified parameters indiciated by a `:` prefix) and a link to
their respective implementation in this package, if applicable.  
Authenticated methods (there’s only a few) are indicated as such.

Note that not all available methods are listed here, especially those
geared towards interactive apps – I highly doubt that people will want
to post (or update) comments through this package.

## Search

| Method     | Endpoint                                                                                                      | Implementation                                                                | Auth     |
|:-----------|:--------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------|:---------|
| Text Query | [/search/:type?query=](https://trakt.docs.apiary.io/#reference/search/text-query/get-text-query-results)      | [`search_query()`](https://jemus42.github.io/tRakt/reference/search_query.md) | Optional |
| ID Lookup  | [/search/:id_type/:id?type=](https://trakt.docs.apiary.io/#reference/search/id-lookup/get-text-query-results) | [`search_id()`](https://jemus42.github.io/tRakt/reference/search_query.md)    | Optional |

## Movies

| Method       | Endpoint                                                                                                                     | Implementation                                                                             | Auth     |
|:-------------|:-----------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------|:---------|
| Trending     | [/movies/trending](https://trakt.docs.apiary.io/#reference/movies/trending/get-trending-movies)                              | [`movies_trending()`](https://jemus42.github.io/tRakt/reference/trending_media.md)         | Optional |
| Popular      | [/movies/popular](https://trakt.docs.apiary.io/#reference/movies/popular/get-popular-movies)                                 | [`movies_popular()`](https://jemus42.github.io/tRakt/reference/popular_media.md)           | Optional |
| Played       | [/movies/played/:period](https://trakt.docs.apiary.io/#reference/movies/played/get-the-most-played-movies)                   | [`movies_played()`](https://jemus42.github.io/tRakt/reference/played_media.md)             | Optional |
| Watched      | [/movies/watched/:period](https://trakt.docs.apiary.io/#reference/movies/watched/get-the-most-watched-movies)                | [`movies_watched()`](https://jemus42.github.io/tRakt/reference/watched_media.md)           | Optional |
| Collected    | [/movies/collected/:period](https://trakt.docs.apiary.io/#reference/movies/collected/get-the-most-collected-movies)          | [`movies_collected()`](https://jemus42.github.io/tRakt/reference/collected_media.md)       | Optional |
| Anticipated  | [/movies/anticipated](https://trakt.docs.apiary.io/#reference/movies/anticipated/get-the-most-anticipated-movies)            | [`movies_anticipated()`](https://jemus42.github.io/tRakt/reference/anticipated_media.md)   | Optional |
| Box Office   | [/movies/boxoffice](https://trakt.docs.apiary.io/#reference/movies/box-office/get-the-weekend-box-office)                    | [`movies_boxoffice()`](https://jemus42.github.io/tRakt/reference/movies_boxoffice.md)      | Optional |
| Updates      | [/movies/updates/:start_date](https://trakt.docs.apiary.io/#reference/movies/updates/get-recently-updated-movies)            | `movies_updates()`                                                                         | Optional |
| Summary      | [/movies/:id](https://trakt.docs.apiary.io/#reference/movies/summary/get-a-movie)                                            | [`movies_summary()`](https://jemus42.github.io/tRakt/reference/movies_summary.md)          | Optional |
| Aliases      | [/movies/:id/aliases](https://trakt.docs.apiary.io/#reference/movies/aliases/get-all-movie-aliases)                          | [`movies_aliases()`](https://jemus42.github.io/tRakt/reference/media_aliases.md)           | Optional |
| Releases     | [/movies/:id/releases/:country](https://trakt.docs.apiary.io/#reference/movies/releases/get-all-movie-releases)              | [`movies_releases()`](https://jemus42.github.io/tRakt/reference/movies_releases.md)        | Optional |
| Translations | [/movies/:id/translations/:language](https://trakt.docs.apiary.io/#reference/movies/translations/get-all-movie-translations) | [`movies_translations()`](https://jemus42.github.io/tRakt/reference/media_translations.md) | Optional |
| Comments     | [/movies/:id/comments/:sort](https://trakt.docs.apiary.io/#reference/movies/comments/get-all-movie-comments)                 | [`movies_comments()`](https://jemus42.github.io/tRakt/reference/media_comments.md)         | Optional |
| Lists        | [/movies/:id/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/movies/lists/get-lists-containing-this-movie)        | [`movies_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)               | Optional |
| People       | [/movies/:id/people](https://trakt.docs.apiary.io/#reference/movies/people/get-all-people-for-a-movie)                       | [`movies_people()`](https://jemus42.github.io/tRakt/reference/media_people.md)             | Optional |
| Ratings      | [/movies/:id/ratings](https://trakt.docs.apiary.io/#reference/movies/ratings/get-movie-ratings)                              | [`movies_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md)           | Optional |
| Related      | [/movies/:id/related](https://trakt.docs.apiary.io/#reference/movies/related/get-related-movies)                             | [`movies_related()`](https://jemus42.github.io/tRakt/reference/movies_related.md)          | Optional |
| Stats        | [/movies/:id/stats](https://trakt.docs.apiary.io/#reference/movies/stats/get-movie-stats)                                    | [`movies_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md)               | Optional |
| Watching     | [/movies/:id/watching](https://trakt.docs.apiary.io/#reference/movies/watching/get-users-watching-right-now)                 | [`movies_watching()`](https://jemus42.github.io/tRakt/reference/media_watching.md)         | Optional |

## Shows

| Method              | Endpoint                                                                                                                                                                      | Implementation                                                                            | Auth     |
|:--------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------|:---------|
| Trending            | [/shows/trending](https://trakt.docs.apiary.io/#reference/shows/trending/get-trending-shows)                                                                                  | [`shows_trending()`](https://jemus42.github.io/tRakt/reference/trending_media.md)         | Optional |
| Popular             | [/shows/popular](https://trakt.docs.apiary.io/#reference/shows/popular/get-popular-shows)                                                                                     | [`shows_popular()`](https://jemus42.github.io/tRakt/reference/popular_media.md)           | Optional |
| Played              | [/shows/played/:period](https://trakt.docs.apiary.io/#reference/shows/played/get-the-most-played-shows)                                                                       | [`shows_played()`](https://jemus42.github.io/tRakt/reference/played_media.md)             | Optional |
| Watched             | [/shows/watched/:period](https://trakt.docs.apiary.io/#reference/shows/watched/get-the-most-watched-shows)                                                                    | [`shows_watched()`](https://jemus42.github.io/tRakt/reference/watched_media.md)           | Optional |
| Collected           | [/shows/collected/:period](https://trakt.docs.apiary.io/#reference/shows/collected/get-the-most-collected-shows)                                                              | [`shows_collected()`](https://jemus42.github.io/tRakt/reference/collected_media.md)       | Optional |
| Anticipated         | [/shows/anticipated](https://trakt.docs.apiary.io/#reference/shows/anticipated/get-the-most-anticipated-shows)                                                                | [`shows_anticipated()`](https://jemus42.github.io/tRakt/reference/anticipated_media.md)   | Optional |
| Updates             | [/shows/updates/:start_date](https://trakt.docs.apiary.io/#reference/shows/updates/get-recently-updated-shows)                                                                | `shows_updates()`                                                                         | Optional |
| Summary             | [/shows/:id](https://trakt.docs.apiary.io/#reference/shows/summary/get-a-single-show)                                                                                         | [`shows_summary()`](https://jemus42.github.io/tRakt/reference/shows_summary.md)           | Optional |
| Aliases             | [/shows/:id/aliases](https://trakt.docs.apiary.io/#reference/shows/summary/get-all-show-aliases)                                                                              | [`shows_aliases()`](https://jemus42.github.io/tRakt/reference/media_aliases.md)           | Optional |
| Translations        | [/shows/:id/translations/:language](https://trakt.docs.apiary.io/#reference/shows/translations/get-all-show-translations)                                                     | [`shows_translations()`](https://jemus42.github.io/tRakt/reference/media_translations.md) | Optional |
| Comments            | [/shows/:id/comments/:sort](https://trakt.docs.apiary.io/#reference/shows/comments/get-all-show-comments)                                                                     | [`shows_comments()`](https://jemus42.github.io/tRakt/reference/media_comments.md)         | Optional |
| Lists               | [/shows/:id/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/shows/lists/get-lists-containing-this-show)                                                            | [`shows_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)               | Optional |
| Collection Progress | [/shows/:id/progress/collection?hidden,specials,count_specials,last_activity](https://trakt.docs.apiary.io/#reference/shows/collection-progress/get-show-collection-progress) |                                                                                           | Required |
| Watched Progress    | [/shows/:id/progress/watched?hidden,specials,count_specials,last_activity](https://trakt.docs.apiary.io/#reference/shows/watched-progress/get-show-watched-progress)          |                                                                                           | Required |
| People              | [/shows/:id/people](https://trakt.docs.apiary.io/#reference/shows/people/get-all-people-for-a-show)                                                                           | [`shows_people()`](https://jemus42.github.io/tRakt/reference/media_people.md)             | Optional |
| Ratings             | [/shows/:id/ratings](https://trakt.docs.apiary.io/#reference/shows/ratings/get-show-ratings)                                                                                  | [`shows_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md)           | Optional |
| Related             | [/shows/:id/related](https://trakt.docs.apiary.io/#reference/shows/related/get-related-shows)                                                                                 | [`shows_related()`](https://jemus42.github.io/tRakt/reference/shows_related.md)           | Optional |
| Stats               | [/shows/:id/stats](https://trakt.docs.apiary.io/#reference/shows/stats/get-show-stats)                                                                                        | [`shows_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md)               | Optional |
| Watching            | [/shows/:id/watching](https://trakt.docs.apiary.io/#reference/shows/watching/get-users-watching-right-now)                                                                    | [`shows_watching()`](https://jemus42.github.io/tRakt/reference/media_watching.md)         | Optional |
| Next Episode        | [/shows/:id/next_episode](https://trakt.docs.apiary.io/#reference/shows/next-episode/get-next-episode)                                                                        | [`shows_next_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md) | Optional |
| Last Episode        | [/shows/:id/last_episode](https://trakt.docs.apiary.io/#reference/shows/last-episode/get-last-episode)                                                                        | [`shows_last_episode()`](https://jemus42.github.io/tRakt/reference/shows_next_episode.md) | Optional |

### Seasons

| Method   | Endpoint                                                                                                                                  | Implementation                                                                        | Auth     |
|:---------|:------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------|:---------|
| Summary  | [/shows/:id/seasons/:season](https://trakt.docs.apiary.io/#reference/seasons/summary/get-all-seasons-for-a-show)                          | [`seasons_summary()`](https://jemus42.github.io/tRakt/reference/seasons_summary.md)   | Optional |
| Season   | [/shows/:id/seasons/:season/info](https://trakt.docs.apiary.io/#reference/seasons/season/get-single-seasons-for-a-show)                   | [`seasons_season()`](https://jemus42.github.io/tRakt/reference/seasons_season.md)     | Optional |
| Episodes | [/shows/:id/seasons/:season?translations=](https://trakt.docs.apiary.io/#reference/seasons/episodes/get-all-episodes-for-a-single-season) | [`seasons_episodes()`](https://jemus42.github.io/tRakt/reference/seasons_episodes.md) | Optional |
| Comments | [/shows/:id/seasons/:season/comments/:sort](https://trakt.docs.apiary.io/#reference/seasons/comments/get-all-season-comments)             | [`seasons_comments()`](https://jemus42.github.io/tRakt/reference/media_comments.md)   | Optional |
| Lists    | [/shows/:id/seasons/:season/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/seasons/lists/get-lists-containing-this-season)    | [`seasons_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)         | Optional |
| People   | [/shows/:id/seasons/:season/people](https://trakt.docs.apiary.io/#reference/seasons/people/get-all-people-for-a-season)                   | [`seasons_people()`](https://jemus42.github.io/tRakt/reference/media_people.md)       | Optional |
| Ratings  | [/shows/:id/seasons/:season/ratings](https://trakt.docs.apiary.io/#reference/seasons/ratings/get-season-ratings)                          | [`seasons_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md)     | Optional |
| Stats    | [/shows/:id/seasons/:season/stats](https://trakt.docs.apiary.io/#reference/seasons/stats/get-season-stats)                                | [`seasons_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md)         | Optional |
| Watching | [/shows/:id/seasons/:season/watching](https://trakt.docs.apiary.io/#reference/seasons/watching/get-users-watching-right-now)              | [`seasons_watching()`](https://jemus42.github.io/tRakt/reference/media_watching.md)   | Optional |

### Episodes

| Method       | Endpoint                                                                                                                                                          | Implementation                                                                               | Auth     |
|:-------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------|:---------|
| Summary      | [/shows/:id/seasons/:season/episodes/:episode](https://trakt.docs.apiary.io/#reference/episodes/summary/get-a-single-episode-for-a-show)                          | [`episodes_summary()`](https://jemus42.github.io/tRakt/reference/episodes_summary.md)        | Optional |
| Translations | [/shows/:id/seasons/:season/episodes/:episode/translations/:language](https://trakt.docs.apiary.io/#reference/episodes/translations/get-all-episode-translations) | [`episodes_translations()`](https://jemus42.github.io/tRakt/reference/media_translations.md) | Optional |
| Comments     | [/shows/:id/seasons/:season/episodes/:episode/comments/:sort](https://trakt.docs.apiary.io/#reference/episodes/comments/get-all-episode-comments)                 | [`episodes_comments()`](https://jemus42.github.io/tRakt/reference/media_comments.md)         | Optional |
| Lists        | [/shows/:id/seasons/:season/episodes/:episode/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/episodes/lists/get-lists-containing-this-episode)        | [`episodes_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)               | Optional |
| People       | [/shows/:id/seasons/:season/episodes/:episode/people](https://trakt.docs.apiary.io/#reference/episodes/people/get-all-people-for-an-episode)                      | [`episodes_people()`](https://jemus42.github.io/tRakt/reference/media_people.md)             | Optional |
| Ratings      | [/shows/:id/seasons/:season/episodes/:episode/ratings](https://trakt.docs.apiary.io/#reference/episodes/ratings/get-episode-ratings)                              | [`episodes_ratings()`](https://jemus42.github.io/tRakt/reference/media_ratings.md)           | Optional |
| Stats        | [/shows/:id/seasons/:season/episodes/:episode/stats](https://trakt.docs.apiary.io/#reference/episodes/stats/get-episode-stats)                                    | [`episodes_stats()`](https://jemus42.github.io/tRakt/reference/media_stats.md)               | Optional |
| Watching     | [/shows/:id/seasons/:season/episodes/:episode/watching](https://trakt.docs.apiary.io/#reference/episodes/watching/get-users-watching-right-now)                   | [`episodes_watching()`](https://jemus42.github.io/tRakt/reference/media_watching.md)         | Optional |

## People

| Method  | Endpoint                                                                                                               | Implementation                                                                    | Auth     |
|:--------|:-----------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------|:---------|
| Summary | [/people/:id](https://trakt.docs.apiary.io/#reference/people/summary/get-a-single-person)                              | [`people_summary()`](https://jemus42.github.io/tRakt/reference/people_summary.md) | Optional |
| Movies  | [/people/:id/movies](https://trakt.docs.apiary.io/#reference/people/movies/get-movie-credits)                          | [`people_movies()`](https://jemus42.github.io/tRakt/reference/people_media.md)    | Optional |
| Shows   | [/people/:id/shows](https://trakt.docs.apiary.io/#reference/people/shows/get-show-credits)                             | [`people_shows()`](https://jemus42.github.io/tRakt/reference/people_media.md)     | Optional |
| Lists   | [/people/:id/lists/:type/:sort](https://trakt.docs.apiary.io/#reference/people/lists/get-lists-containing-this-person) | [`people_lists()`](https://jemus42.github.io/tRakt/reference/media_lists.md)      | Optional |

## Users

| Method        | Endpoint                                                                                                                         | Implementation                                                                            | Auth     |
|:--------------|:---------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------|:---------|
| Likes         | [/users/:id/likes/:type](https://trakt.docs.apiary.io/#reference/users/likes/get-likes)                                          | [`user_likes()`](https://jemus42.github.io/tRakt/reference/user_likes.md)                 | Required |
| Profile       | [/users/:id](https://trakt.docs.apiary.io/#reference/users/profile/get-user-profile)                                             | [`user_profile()`](https://jemus42.github.io/tRakt/reference/user_profile.md)             | Optional |
| Collection    | [/users/:id/collection/:type](https://trakt.docs.apiary.io/#reference/users/collection/get-collection)                           | [`user_collection()`](https://jemus42.github.io/tRakt/reference/user_collection.md)       | Optional |
| Comments      | [/users/:id/comments/:comment_type/:type?include_replies=](https://trakt.docs.apiary.io/#reference/users/comments/get-comments)  | [`user_comments()`](https://jemus42.github.io/tRakt/reference/user_comments.md)           | Optional |
| Lists         | [/users/:id/lists](https://trakt.docs.apiary.io/#reference/users/lists/get-a-user)                                               | [`user_lists()`](https://jemus42.github.io/tRakt/reference/user_lists.md)                 | Optional |
| List          | [/users/:id/lists/:list_id](https://trakt.docs.apiary.io/#reference/users/list/get-custom-list)                                  | [`user_list()`](https://jemus42.github.io/tRakt/reference/user_list.md)                   | Optional |
| List Items    | [/users/:id/lists/:list_id/items/:type](https://trakt.docs.apiary.io/#reference/users/list-items/get-items-on-a-custom-list)     | [`user_list_items()`](https://jemus42.github.io/tRakt/reference/user_list_items.md)       | Optional |
| List Comments | [/users/:id/lists/:list_id/comments/:sort](https://trakt.docs.apiary.io/#reference/users/list-comments/get-all-list-comments)    | [`user_list_comments()`](https://jemus42.github.io/tRakt/reference/user_list_comments.md) | Optional |
| Followers     | [/users/:id/followers](https://trakt.docs.apiary.io/#reference/users/followers/get-followers)                                    | [`user_followers()`](https://jemus42.github.io/tRakt/reference/user_network.md)           | Optional |
| Following     | [/users/:id/following](https://trakt.docs.apiary.io/#reference/users/following/get-following)                                    | [`user_following()`](https://jemus42.github.io/tRakt/reference/user_network.md)           | Optional |
| Friends       | [/users/:id/friends](https://trakt.docs.apiary.io/#reference/users/friends/get-friends)                                          | [`user_friends()`](https://jemus42.github.io/tRakt/reference/user_network.md)             | Optional |
| History       | [/users/:id/history/:type/:item_id?start_at=,end_at=](https://trakt.docs.apiary.io/#reference/users/history/get-watched-history) | [`user_history()`](https://jemus42.github.io/tRakt/reference/user_history.md)             | Optional |
| Ratings       | [/users/:id/ratings/:type/:rating](https://trakt.docs.apiary.io/#reference/users/ratings/get-ratings)                            | [`user_ratings()`](https://jemus42.github.io/tRakt/reference/user_ratings.md)             | Optional |
| Watchlist     | [/users/:id/watchlist/:type/:sort](https://trakt.docs.apiary.io/#reference/users/watchlist/get-watchlist)                        | [`user_watchlist()`](https://jemus42.github.io/tRakt/reference/user_watchlist.md)         | Optional |
| Watched       | [/users/:id/watched/:type](https://trakt.docs.apiary.io/#reference/users/watched/get-watched)                                    | [`user_watched()`](https://jemus42.github.io/tRakt/reference/user_watched.md)             | Optional |
| Stats         | [/users/:id/stats](https://trakt.docs.apiary.io/#reference/users/stats/get-stats)                                                | [`user_stats()`](https://jemus42.github.io/tRakt/reference/user_stats.md)                 | Optional |

## Comments

| Method   | Endpoint                                                                                                                                         | Implementation                                                                          | Auth     |
|:---------|:-------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------|:---------|
| Comment  | [/comments/:id](https://trakt.docs.apiary.io/#reference/comments/comment/get-a-comment-or-reply)                                                 | [`comments_comment()`](https://jemus42.github.io/tRakt/reference/comments_comment.md)   | Optional |
| Replies  | [/comments/:id/replies](https://trakt.docs.apiary.io/#reference/comments/replies/get-replies-for-a-comment)                                      | [`comments_replies()`](https://jemus42.github.io/tRakt/reference/comments_comment.md)   | Optional |
| Item     | [/comments/:id/item](https://trakt.docs.apiary.io/#reference/comments/item/get-the-attached-media-item)                                          | [`comments_item()`](https://jemus42.github.io/tRakt/reference/comments_comment.md)      | Optional |
| Likes    | [/comments/:id/likes](https://trakt.docs.apiary.io/#reference/comments/likes/get-all-users-who-liked-a-comment)                                  | [`comments_likes()`](https://jemus42.github.io/tRakt/reference/comments_comment.md)     | Optional |
| Trending | [/comments/trending/:comment_type/:type?include_replies=](https://trakt.docs.apiary.io/#reference/comments/trending/get-trending-comments)       | [`comments_trending()`](https://jemus42.github.io/tRakt/reference/comments_trending.md) | Optional |
| Recent   | [/comments/recent/:comment_type/:type?include_replies=](https://trakt.docs.apiary.io/#reference/comments/recent/get-recently-created-comments)   | [`comments_recent()`](https://jemus42.github.io/tRakt/reference/comments_trending.md)   | Optional |
| Updates  | [/comments/updates/:comment_type/:type?include_replies=](https://trakt.docs.apiary.io/#reference/comments/updates/get-recently-updated-comments) | [`comments_updates()`](https://jemus42.github.io/tRakt/reference/comments_updates.md)   | Optional |

## Lists

| Method   | Endpoint                                                                                     | Implementation                                                                   | Auth     |
|:---------|:---------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------|:---------|
| Popular  | [/lists/popular](https://trakt.docs.apiary.io/#reference/lists/popular/get-popular-lists)    | [`lists_popular()`](https://jemus42.github.io/tRakt/reference/lists_popular.md)  | Optional |
| Trending | [/lists/trending](https://trakt.docs.apiary.io/#reference/lists/trending/get-trending-lists) | [`lists_trending()`](https://jemus42.github.io/tRakt/reference/lists_popular.md) | Optional |

## Misc

These endpoints are used to check filter arguments. The output is cached
in tidied up format as package datasets.

| Section        | Method | Endpoint                                                                                                | Implementation                                                                         |
|:---------------|:-------|:--------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------|
| certifications | List   | [/certifications/:type](https://trakt.docs.apiary.io/#reference/certifications/list/get-certifications) | [`?trakt_certifications`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md) |
| countries      | List   | [/countries/:type](https://trakt.docs.apiary.io/#reference/countries/list/get-countries)                | [`?trakt_countries`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)      |
| genres         | List   | [/genres/:type](https://trakt.docs.apiary.io/#reference/genres/list/get-genres)                         | [`?trakt_genres`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)         |
| languages      | List   | [/languages/:type](https://trakt.docs.apiary.io/#reference/languages/list/get-languages)                | [`?trakt_languages`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)      |
| networks       | List   | [/networks](https://trakt.docs.apiary.io/#reference/networks/list/get-networks)                         | [`?trakt_networks`](https://jemus42.github.io/tRakt/reference/trakt_datasets.md)       |
