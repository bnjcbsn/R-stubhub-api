#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(magrittr)
library(purrr)
source("stubhub_login_request.R")
source("event_search.R")

# api constants ----------------------------------------------------------------

# stubhub login request 
tokens <- request_api_login()
access_token <- tokens$access_token
refresh_token <- tokens$refresh_token
x_stubhub_user_guid <- tokens$x_stubhub_user_guid

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
  
  # Application title
  titlePanel("Stubhub API Tester"),
  
  sidebarLayout(
    sidebarPanel(
      titlePanel("API Tester Input Bin"),
      textInput(inputId = "keywordSearch", 
                label = "Search Events by Keyword", 
                placeholder = "Keyword"),
      textInput(inputId = "locationSearch", 
                label = "Location", 
                placeholder = "Location"),
      radioButtons(inputId = "radiusSearch", 
                   label = "Distance From Location",
                   choices = list("Any"=1000, "5"=5, "10"=10, "15"=15, "20"=20)),
      radioButtons(inputId = "sortSearch", 
                   label = "Sort Results By", 
                   choices = list("Popularity"="popularity",
                                  "Date"="eventDateLocal", 
                                  "Distance"="distance")),
      actionButton(inputId = "submitSearch", label = "Search"),
      actionButton(inputId = "clearSearch", label = "Clear")
    ),
    
    mainPanel(
      titlePanel("API Tester Out"),
      verbatimTextOutput(outputId = "totalFound"),
      verbatimTextOutput(outputId = "selectFromResults")
    )
  )
))

# Define server logic 
server <- shinyServer(function(input, output) {
  
  events <- reactiveValues(data = "Use search tools to find tickets!", 
                           numTickets = 0)
  
  observeEvent(input$submitSearch, {
    
    events$data <- search_events_advanced(access_token, 
                                          limit=20, 
                                          q=input$keywordSearch, 
                                          city=input$locationSearch, 
                                          radius=input$radiusSearch, 
                                          sort=input$sortSearch)$events
  })
  
  observeEvent(input$clearSearch, {
    events$numTickets <- 0
    events$data <- "Use search tools to find tickets!"
  })
  
  output$selectFromResults <- renderText({
    h4(paste("We found", events$numTickets, "matching events!"))
    br()
    paste(events$data)
  })
  
})

# Run the application 
shinyApp(ui = ui, server = server)

