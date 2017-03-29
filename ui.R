library(shiny)
library(leaflet)
fluidPage(selectInput(inputId = "contraception_data",
                      label = "Proportion of couples using ____ method(s) of contraception",
                      choices = list("Choice 1" = "Any", "Choice 2" = "Modern"),
                      selected = 1),
          plotOutput(outputId = "Map"))

shinyApp(ui = "ui.R", server = "server.R")

