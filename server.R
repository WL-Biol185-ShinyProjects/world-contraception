bins_all_methods <- seq(0, 1, length = 10)
library(dplyr)
library(ggplot2)
library(shinythemes)

#Country highlight labels


#Country popup clickable labels


function(input, output) {
  geoJSON_map <- readRDS(file = "geoJSON_map.rds")
  map <- readRDS(file = "map.rds")
  output$shinymap <- renderLeaflet({
    
    pal  <- colorBin("YlOrRd", geoJSON_map@data[[input$variable1]])
    
    labels <- sprintf(
      "<strong>%s</strong><br/> Value: <strong>%g</strong>",
      geoJSON_map$name, geoJSON_map@data[[input$variable1]]
    ) %>% lapply(htmltools::HTML)
    
    country_popup <-  sprintf(
      "<strong>%s</strong><br/> Proportion of married women who use any form of contraception: <strong>%g</strong><br/> Proportion of married women who use modern forms of contraception: <strong>%g</strong>",
      geoJSON_map$name, geoJSON_map$all_contraception_methods, geoJSON_map$modern_contraception_methods
    ) %>% lapply(htmltools::HTML)
    
    geoJSON_map@data <- mutate_(geoJSON_map@data, value = input$variable1)
    
      leaflet(data = geoJSON_map) %>%
      addTiles(options = tileOptions(noWrap = TRUE))        %>%
      addPolygons(fillColor = ~pal(value),
                  weight = 2,
                  opacity = 1,
                  color = "white",
                  popup = country_popup,
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
                    direction = "auto")) %>%
      addLegend(pal = pal, values = ~density, opacity = 0.7, title = input$variable1,
                position = "bottomright") %>%
      setView(map, lng = 65, lat = 40, zoom = 1.2)

    
  })
  output$barplot <- renderPlot({
    geoJSON_map@data %>% 
      filter(name %in% geoJSON_map$name) %>%
    ggplot(aes(name, geoJSON_map@data[[input$variable1]])) + 
      geom_bar(stat = "identity", alpha = 0.8) + 
      theme(axis.text.x = element_text(angle = 60, hjust = 1)) + theme(legend.position = "none")
  })
  
  output$correlations <- renderPlot({
    geoJSON_map@data[[input$variable1]] 
    ggplot(aes(value, selectInput(variable2)))
  })
}
