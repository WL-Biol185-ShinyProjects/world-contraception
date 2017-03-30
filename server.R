function(input, output) {
  
  output$shinymap <- renderLeaflet({
    
  leaflet(data = geoJSON_map) %>%
    addTiles()        %>%
    addGeoJSON(geoJSON_map) %>%
      
    if (input$variable1 == "Proportion of married women using any method of contraception") {
      bins_all_methods <- seq(0, 1, length = 10)
      pal  <- colorBin("YlOrRd", map@data$all_contraception_methods, bins_all_methods)
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
                  bringToFront = TRUE,
                  label = labels,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "10px",
                    direction = "auto")
                  ))
}
  
  output$shinymap <- renderLeaflet(shinymap)
  }
)
}
