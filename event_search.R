#################################################
# Stubhub Event Search 
# Emanuel Rodriguez 
# Decription: Search events on Stubhub by query 
#
#################################################

library(httr)
source("stubhub_login_request.R")
base_stubhub_url <- "https://api.stubhub.com"
search_events_endpoint <- paste0(base_stubhub_url, "/search/catalog/events/v3")
tokens <- request_api_login()
access_token <- tokens$access_token
refresh_token <- tokens$refresh_token
x_stubhub_user_guid <- tokens$x_stubhub_user_guid

#` 
search_events_by_keyword <- function(keyword, access_token, limit=20) {
  r <- httr::GET(url = search_events_endpoint, 
                 add_headers(
                   "Authorization"=paste("Bearer", access_token, sep = " "), 
                   "Accept" = "application/json",
                   "Accept-Encoding" = "application/json"
                 ), 
                 query = list(
                   "status" = "active",
                   "q" = keyword, 
                   "rows" = limit, 
                   "sort" = "eventDateLocal"
                 ))
  return (content(r))
}

#` 
search_events_advanced <- function(access_token, limit = 20, ...) {
  query <- list("limit" = limit, ...)
  r <- httr::GET(url = search_events_endpoint, 
                 add_headers(
                   "Authorization"=paste("Bearer", access_token, sep = " "), 
                   "Accept" = "application/json",
                   "Accept-Encoding" = "application/json"
                 ), 
                 query = list(...))
  return (content(r))
}

extract_from_list <- function(., ...) {
  e <- .
  xtract <- list(...) 
  xtracted <- list()
  for (i in seq_along(e)) {
    xtracted[[e[[i]]$name]] <- (e[[i]]$id)
  }
  
  return (xtracted)
}







