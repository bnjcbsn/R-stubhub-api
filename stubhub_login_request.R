#####################################################
# Stubhub Login Request 
# Emanuel Rodriguez 
# Description: Small script to initialize a login 
#             to the Stubhub Api, for personal use
#             create an account and obtain a 
#             consumer key and consumer secret key
#
# Note: As of Sep 29 2016, the sandbox version of the
#       API appears not maintained thus we production
#       version is used here.
#
# Note: The login request needs a file nameed '.config'
#       where application token, consumer key and 
#       consumer secret are located
######################################################

library(httr)
library(base64enc)

# enter login info here
user="*****"
psswd="*****"

# get keys from config ---------------------------------------------------------
get_keys <- function(){
  if (!".config" %in% list.files(all.files = TRUE)) {
    return (cat("Please create a .config file with keys"))
    
  }
  return(readLines(".config"))
}


# login request constants ------------------------------------------------------


# login request ----------------------------------------------------------------
request_api_login <- function() {
  keys <- get_keys() 
  consumer_key <- keys[2]
  consumer_secret <- keys[3]
  accept_type <- "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
  login_url <- "https://api.stubhub.com/login"
  raw_key_and_secret <- charToRaw(paste(consumer_key, consumer_secret, sep = ":"))
  basic_auth_token <- base64encode(raw_key_and_secret)
  req <- httr::POST(url = login_url,
                    add_headers("Content-Type"="application/x-www-form-urlencoded", 
                                "Authorization"=paste("Basic", basic_auth_token, sep = " "), 
                                "Accept-Encoding"="gzip, deflate", 
                                "Accept-Type"=accept_type),
                    body = list(grant_type="password", 
                                username=user, 
                                password=psswd, 
                                scope="PRODUCTION"), encode = "form")
  
  # tokens -----------------------------------------------------------------------
  access_token <- content(req)$access_token
  refresh_token <- content(req)$refresh_token
  x_stubhub_user_guid <- headers(req)$`x-stubhub-user-guid`
  
  return (list("access_token"=access_token, 
               "refresh_token"=refresh_token, 
               "x_stubhub_user_guid"=x_stubhub_user_guid))
}

