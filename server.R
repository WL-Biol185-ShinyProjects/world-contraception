library(shiny)
library(tidyverse)
library(dplyr)

saveRDS(map, file = "geoJSON_map.rds")
geoJSON_map <- readRDS("geoJSON_map.rds")
View(geoJSON_map)

# Interactive Map
library(leaflet)

bins_all_methods <- seq(0, 1, length = 10)
pal  <- colorBin("YlOrRd", map@data$all_contraception_methods, bins_all_methods)

leaflet(data = geoJSON_map) %>%
  addTiles()        %>%
  addPolygons(fillColor = ~pal(all_contraception_methods),
              weight = 2,
              opacity = 1,
              color = "white",
              dashArray = "3",
              fillOpacity = 0.7,
              highlight = highlightOptions(
                weight = 5,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE))

# unfinished labels section

labels <- sprintf(
  "<strong>%s</strong><br/>%g proportion of married couples who use any contraception",
  geoJSON_map$name, geoJSON_map$all_contraception_methods
) %>% lapply(htmltools::HTML)

m_labels <- m %>% addPolygons(
  fillColor = ~pal(all_contraception_methods),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7,
  highlight = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "10px",
    direction = "auto"))
m_labels

function(input, output) {
  output$value <- renderPrint(({ input$contraception_data}))
}
  