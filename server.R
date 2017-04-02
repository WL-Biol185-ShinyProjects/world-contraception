bins_all_methods <- seq(0, 1, length = 10)
pal  <- colorBin("YlOrRd", map@data$all_contraception_methods, bins_all_methods)

#Country highlight labels
labels <- sprintf(
  "<strong>%s</strong><br/> Proportion of married women who use any form of contraception: <strong>%g</strong>",
  geoJSON_map$name, geoJSON_map$all_contraception_methods
) %>% lapply(htmltools::HTML)

#Country popup click labels
country_popup <-  sprintf(
  "<strong>%s</strong><br/> Proportion of married women who use any form of contraception: <strong>%g</strong><br/> Proportion of married women who use modern forms of contraception: <strong>%g</strong>",
  geoJSON_map$name, geoJSON_map$all_contraception_methods, geoJSON_map$modern_contraception_methods
) %>% lapply(htmltools::HTML)

function(input, output) {
  output$shinymap <- renderLeaflet({
      leaflet(data = geoJSON_map) %>%
      addTiles(options = tileOptions(noWrap = TRUE))        %>%
      addPolygons(fillColor = ~pal(all_contraception_methods),
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
}
