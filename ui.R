library(shiny)
library(leaflet)
fluidPage(
  titlePanel("World Contraception Use and Indicators of Development"),
  sidebarLayout(mainPanel = leafletOutput("shinymap"),
                position = "left",
                sidebarPanel = ("Variable Selection")
                )
               
  )
              



