##############################
#
#
#
#
##############################

source("event_search.R")
source("stubhub_login_request.R")

# For Standalont Developing ====================================================
# api constants ----------------------------------------------------------------

# stubhub login request 
tokens <- request_api_login(consumer_key, consumer_secret)
access_token <- tokens$access_token
refresh_token <- tokens$refresh_token
x_stubhub_user_guid <- tokens$x_stubhub_user_guid
#===============================================================================

search_listing_by_id <- function(id, access_token, limit=25) {
  r <- httr::GET(url = "https://api.stubhub.com/search/inventory/v1", 
                 add_headers(
                   "Authorization" = paste("Bearer", access_token, sep = " ")
                 ), 
                 query =  list(
                   "eventid" = id
                 ))
  return(content(r))
}

request_api_login()
ww <- search_listing_by_id("9607684", access_token)
