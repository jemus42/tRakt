#' Easy episode id padding
#'
#' Simple function to ease the creation of \code{sXXeYY} episode ids.
#' @param s Input season number, coerced to \code{character}.
#' @param e Input episode number, coerced to \code{character}.
#' @param width The length of the padding. Defaults to 2.
#' @return A \code{character} in standard \code{sXXeYY} format
#' @export
#' @note I like my sXXeYY format, okay?
#' @examples
#' pad(2, 4) # Returns "s02e04"
pad <- function(s = "0", e = "0", width = 2){
  s <- as.character(s)
  e <- as.character(e)
  season <- sapply(s, function(x){
              if (nchar(x, "width") < width){
                missing <- width - nchar(x, "width")
                x.pad   <- paste0(rep("0", missing), x)
                return(x.pad)
              } else {
                return(x)
              }
            })
  episode <- sapply(e, function(x){
                if (nchar(x, "width") < width){
                  missing <- width - nchar(x, "width")
                  x.pad   <- paste0(rep("0", missing), x)
                  return(x.pad)
                } else {
                  return(x)
                }
              })
  epstring <- paste0("s", season, "e", episode)
  return(epstring)
}

#' Get info from a show URL
#'
#' \code{parse_trakt_url} extracts some info from a show URL
#' @param url Input URL. must be a \code{character}, but not a valid URL.
#' @param epid Whether the episode ID (\code{sXXeYY} format) should be extracted.
#' Defaults to \code{FALSE}.
#' @param getslug Whether the \code{slug} should be extracted. Defaults to \code{FALSE}.
#' @return A \code{list} containing at least the show name.
#' @export
#' @importFrom stringr str_split
#' @note This is pointless.
#' @examples
#' parse_trakt_url("http://trakt.tv/show/fargo/season/1/episode/2", TRUE, TRUE)
#' parse_trakt_url("http://trakt.tv/show/breaking-bad", TRUE, FALSE)
parse_trakt_url <- function(url, epid = FALSE, getslug = FALSE){
  showname <- stringr::str_split(url, "/")[[1]][5]
  ret <- list("show" = showname)
  if (epid){
    season   <- stringr::str_split(url, "/")[[1]][7]
    episode  <- stringr::str_split(url, "/")[[1]][9]
    if(is.na(season) | is.na(episode)){
      ret$epid <- NA
    } else{
      epid     <- pad(season, episode)
      ret$epid <- epid
    }
  }
  if (getslug){
    slug <- stringr::str_split(url, "/", 5)
    ret$slug <- slug[[1]][5]
  }
  return(ret)
  # Most of this is pointless.
}

#' Quick datetime conversion
#'
#' Searches for datetime variables and converts them to \code{POSIXct} via \pkg{lubridate}.
#' @param object The input object. Must be \code{data.frame} or \code{list}
#' @return The same object with converted datetimes
#' @importFrom lubridate parse_date_time
#' @keywords internal
convert_datetime <- function(object){
  if (!(class(object) %in% c("data.frame", "list"))){
    stop("Object type not supported")
  }
  datevars <- c("first_aired", "updated_at", "listed_at", "last_watched_at",
                "rated_at", "friends_at", "followed_at", "collected_at")

  for (i in names(object)){
    if (i %in% datevars & !("POSIXct" %in% class(object[[i]]))){
      newdates <- lubridate::parse_date_time(object[[i]], "%y-%m-%d %H-%M-%S%z*!",
                                                truncated = 3, tz = "UTC")
      if (any(is.na(newdates))){
        newdates <- as.POSIXct(object[[i]], tz = "UTC")
      }
      object[[i]] <- newdates
    } else if (i %in% c("released", "release_date")){
      object[[i]] <- as.POSIXct(object[[i]], tz = "UTC")
    }
  }
  return(object)
}
