library(dplyr)



function(input, output) {
  output$shinymap <- renderLeaflet({
    pal  <- colorBin("YlOrRd", geoJSON_map@data[[input$variable1]])
    labels <- sprintf(
      "<strong>%s</strong><br/>%g proportion of married women who use any form of contraception",
      geoJSON_map$name, geoJSON_map$all_contraception_methods
    ) %>% lapply(htmltools::HTML)
    country_popup <-  sprintf(
      "<strong>%s</strong><br/>%g proportion of married women who use any form of contraception",
      geoJSON_map$name, geoJSON_map$all_contraception_methods
    ) %>% lapply(htmltools::HTML)
    geoJSON_map@data <-  mutate_(geoJSON_map@data, value = input$variable1)
      leaflet(data = geoJSON_map) %>%
      addTiles()        %>%
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
      addLegend(pal = pal, values = ~density, opacity = 0.7, title = "Proportion of Married Women Using Birth Control" ,
                position = "bottomright")

    
  })
}
