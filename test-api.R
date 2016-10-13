source("stughub_login_request.R")
# API request ------------------------------------------------------------------

# search inventory 
search_inventory_uri <- paste0(base_stubhub_url, "/search/inventory/")
search_by_id <- function(id) {
  
}

# search events 
search_events_uri <- paste0(base_stubhub_url, "/search/catalog/events/v3")

search_req <- httr::GET(url = search_events_uri,
                        add_headers("Authorization"=paste("Bearer", access_token, sep = " "), 
                                    "Accept" = "application/json", 
                                    "Accept-Encoding" = "application/json"), 
                        query = list("status"="active", 
                                     "q" = "Golden State Warriors", 
                                     "rows" = 100))



search_by_keyword_v1 <- function(keyword, limit=20) {
  httr::GET(url = search_events_uri,
            add_headers("Authorization"=paste("Bearer", access_token, sep = " "), 
                        "Accept" = "application/json", 
                        "Accept-Encoding" = "application/json"), 
            query = list("status"="active", 
                         "q" = keyword, 
                         "rows" = limit)) %>%
    content() %>% `$`(events)
}

search_by_keyword <- function(keyword, limit=20) {
  req <- httr::GET(url = search_events_uri,
                   add_headers("Authorization"=paste("Bearer", access_token, sep = " "), 
                               "Accept" = "application/json", 
                               "Accept-Encoding" = "application/json"), 
                   query = list("status"="active", 
                                "q" = keyword, 
                                "rows" = limit, 
                                "sort" = "eventDateLocal"))
  return (content(req)$events)
}

get_event_id <- function()









