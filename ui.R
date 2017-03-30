library(shiny)
library(leaflet)
fluidPage(
  titlePanel("World Contraception Use and Indicators of Development"),
  sidebarLayout(position = "left",
                mainPanel = leafletOutput("shinymap"),
                sidebarPanel(
                  selectInput(inputId = "variable1",
                      label = "Contraception and Development Indicators",
                      choices = list(all_contraception_methods = "Proportion of married women using any method of contraception",
                                     modern_contraception_methods = "Proportion of married women using modern methods of contraception",
                                     birth_rate = "Birth rate",
                                     death_rate = "Death rate",
                                     infant_mortality_rate = "Infant mortality rate",
                                     maternal_deaths = "Maternal deaths",
                                     adolescent_fertility_rate = "Adolescent fertility rate",
                                     fertility_rate = "Fertility rate",
                                     male_life_expectancy = "Male life expectancy",
                                     female_life_expectancy = "Female life expectancy",
                                     male_lit_rate = "Male literacy rate",
                                     female_lit_rate = "Female literacy rate",
                                     gdp = "GDP",
                                     work_force_ratio = "Work force ratio, women to men",
                                     male_labor_force_participation = "Proportion of men in the labor force",
                                     female_labor_force_participation = "Proportion of women in the labor force",
                                     male_econ_activity = "Proportion of men who participate in the economy",
                                     female_econ_activity = "Proportion of women who participate in the economy"),
                      selected = "Proportion of married women using any method of contraception"))
  )
              )


