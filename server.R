bins_all_methods <- seq(0, 1, length = 10)
library(dplyr)
library(ggplot2)
library(shinythemes)

World_Contraception_and_Country_Development <- read.csv("World_Contraception_and_Country_Development.csv")

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
      setView(map, lng = 30, lat = 42, zoom = 1.2)

    
  })
  output$barplot <- renderPlot({
    if(is.null(input$selectize)){
      x <- geoJSON_map@data %>% 
        ggplot(aes(x = reorder(name, -geoJSON_map@data[[input$variable1]]), y = geoJSON_map@data[[input$variable1]], fill = geoJSON_map@data[[input$variable1]])) +
        geom_bar(stat = "identity", alpha = 0.8, width = 0.8) + 
        theme(axis.text.x = element_text(angle = 60, hjust = 1)) + theme(legend.position = "none") + ylab(input$variable1) + xlab("Country")
    } else {
      x <- geoJSON_map@data %>% 
        filter(name %in% input$selectize) %>%
        ggplot(aes_string(x = "name", y = input$variable1, fill = input$variable1)) +
        geom_bar(stat = "identity", alpha = 0.8, width = 0.8) + 
        theme(axis.text.x = element_text(angle = 60, hjust = 1)) + theme(legend.position = "none") + ylab(input$variable1) + xlab("Country")
    }
    x
  })
  
 
  output$correlations <- renderPlot({
    p <- geoJSON_map@data %>%
      filter(name %in% geoJSON_map$name) %>%
      ggplot(aes(geoJSON_map@data[[input$variable1]], geoJSON_map@data[[input$variable2]])) + xlab(input$variable1) + ylab(input$variable2)

    if (input$colorBy==TRUE) {
      p <- p + geom_point(aes(color = geoJSON_map@data$gdp)) + labs(color = 'GDP')
    } else {
      p <- p + geom_point()
    }
    p
  })
  
  output$clickName <- renderText({
    as.character(nearPoints(geoJSON_map@data, input$plot_click, xvar = input$variable1, yvar = input$variable2)$name)
  })
  
  output$downloadData <- downloadHandler( filename = "World_Contraception_and_Country_Development.csv",
                                          content = function(file) {
                                            write.csv(World_Contraception_and_Country_Development, file)
                                          })
}
