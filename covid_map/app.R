library(shiny)
library(leaflet)
library(googlesheets4)
library(tidyverse)
sheets_deauth()
bfw_link <- a("Wisconsin Bike Fed", href = "http://wisconsinbikefed.org")
mb_link <- a("Madison Bikes.", href = "https://www.madisonbikes.org")
df <- read_sheet("https://docs.google.com/spreadsheets/d/1TaghQIUjMTDf1R33BtGtUAwIYjfeoHTUf7wJjMg0O6M/",
                 col_types = "c-nncci__cccT_")#loading only relevant variables to improve performance
updated <- tagList("Last updated: ",
                  df$error[1],
                  " Idea: Heather Pape. Code: Harald Kliems for ", 
                  mb_link, 
                  " Shop list: ",
                  bfw_link)#get time of last update and add credit

unknown <- makeAwesomeIcon(library = "fa", 
                         icon = "question",
                         markerColor = "lightgray")
known <- makeAwesomeIcon(icon = "bicycle",
                         library = "fa")

shops <- df %>% 
    rename(name = `Shop Name`) %>% 
    mutate(Status = replace_na(Status, "unknown")) %>% 
    mutate(pop = paste0("<b>",name, "</b><br>",
                        "Phone: ", Phone, "<br>",
                        "Website: ", Website, "<br>",
                        "Operating Status: ", Status))

known_shops <- shops %>% 
    filter(Status != "unknown")

unknown_shops <- shops %>% 
    filter(Status == "unknown")

ui <- fluidPage(
    leafletOutput("mymap"),
    p(),
    tagList(updated)
    # actionButton("refresh", "Refresh")
)

server <- function(input, output, session) {

    
    output$mymap <- renderLeaflet({
        leaflet(width = "90%") %>% 
            addProviderTiles(provider = "Stamen.TonerLite") %>%
            addAwesomeMarkers(data = unknown_shops, lng = ~Long, lat = ~Lat, popup = ~pop, icon = unknown) %>% 
            addAwesomeMarkers(data = known_shops, lng = ~Long, lat = ~Lat, popup = ~pop, icon = known)
    })
}

shinyApp(ui, server, options = list(height = 1080))