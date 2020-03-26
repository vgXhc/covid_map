library(shiny)
library(leaflet)
library(googlesheets4)
library(tidyverse)

df <- read_sheet("https://docs.google.com/spreadsheets/d/1TaghQIUjMTDf1R33BtGtUAwIYjfeoHTUf7wJjMg0O6M/")
r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage(
    leafletOutput("mymap"),
    p(),
    # actionButton("refresh", "Refresh")
)

server <- function(input, output, session) {
    
    # sheets_deauth()
    # df <- eventReactive(input$refresh, {
    #     df() <- read_sheet("https://docs.google.com/spreadsheets/d/1TaghQIUjMTDf1R33BtGtUAwIYjfeoHTUf7wJjMg0O6M/edit?ts=5e790c29#gid=1069622854")
    # }, ignoreNULL = FALSE)
    
    # points <- eventReactive(input$recalc, {
    #     cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
    # }, ignoreNULL = FALSE)
    # 
    # 
    
       
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

# ```{r echo=FALSE, results=FALSE, message=FALSE}
# library(leaflet)
# library(googlesheets4)
# library(tidyverse)
# 
# sheets_deauth()
# 
# 
# df <- read_sheet("https://docs.google.com/spreadsheets/d/1TaghQIUjMTDf1R33BtGtUAwIYjfeoHTUf7wJjMg0O6M/edit?ts=5e790c29#gid=1069622854")
# 
# 
# shops <- df %>% 
#     rename(name = `Shop Name`) %>% 
#     mutate(Status = replace_na(Status, "unknown")) %>% 
#     mutate(pop = paste0("<b>",name, "</b><br>",
#                         "Phone: ", Phone, "<br>",
#                         "Website: ", Website, "<br>",
#                         "Operating Status: ", Status))
# ```
# 
# 
# ```{r echo=FALSE, warning=FALSE}
# 
# 
# 
# shops %>% 
#     leaflet(width = "90%") %>% 
#     addProviderTiles(provider = "Stamen.TonerLite") %>%
#     addMarkers(lng = ~Long, lat = ~Lat, popup = ~pop)
# ```
