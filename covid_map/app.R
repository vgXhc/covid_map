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

ui <- fluidPage(
    leafletOutput("mymap"),
    p(),
    tagList(updated)
    # actionButton("refresh", "Refresh")
)

server <- function(input, output, session) {
    shops <- df %>% 
        rename(name = `Shop Name`) %>% 
        mutate(Status = replace_na(Status, "unknown")) %>% 
        mutate(pop = paste0("<b>",name, "</b><br>",
                            "Phone: ", Phone, "<br>",
                            "Website: ", Website, "<br>",
                            "Operating Status: ", Status))
    
    output$mymap <- renderLeaflet({
        shops %>% 
            leaflet(width = "90%") %>% 
            addProviderTiles(provider = "Stamen.TonerLite") %>%
            addMarkers(lng = ~Long, lat = ~Lat, popup = ~pop)
    })
}

shinyApp(ui, server, options = list(height = 1080))