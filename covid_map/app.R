library(shiny)
library(leaflet)
library(googlesheets4)
library(tidyverse)
sheets_deauth()
df <- read_sheet("https://docs.google.com/spreadsheets/d/1TaghQIUjMTDf1R33BtGtUAwIYjfeoHTUf7wJjMg0O6M/")

ui <- fluidPage(
    leafletOutput("mymap"),
    p(),
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

shinyApp(ui, server)