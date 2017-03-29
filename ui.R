library(shiny)
library(leaflet)
fluidPage(
  titlePanel("World Contraception Use and Indicators of Development"),
  sidebarLayout(position = "left",
                sidebarPanel(
                  selectInput(inputId = "variable1",
                      label = "Contraception and Development Indicators",
                      choices = c("Proportion of married women using any method of contraception", "Proportion of married women using modern methods of contraception", "Birth rate", "Death rate", "Infant mortality rate", "Maternal deaths", "Adolescent fertility rate", "Fertility rate", "Male life expectancy", "Female life expectancy", "Male literacy rate", "Female literacy rate", "GDP", "Work force ratio, women to men", "Proportion of men in the labor force", "Proportion of women in the labor force", "Proportion of men who participate in the economy", "Proportion of women who participate in the economy"),
                      selected = "Proportion of married women using any method of contraception")
                )
                ),
  mainPanel(leafletOutput('shinymap'),
          plotOutput(outputId = "shinymap")))

