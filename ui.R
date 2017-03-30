library(shiny)
library(leaflet)
fluidPage(
  titlePanel("World Contraception Use and Indicators of Development"),
  sidebarLayout(mainPanel = leafletOutput("shinymap"),
                position = "left",
                sidebarPanel = sidebarPanel(
                  selectInput(inputId = "variable1",
                              label = "Contraception and Development Indicators",
                              choices = list('Proportion of married women who use any method of contraception' = "all_contraception_methods",
                                             'Proportion of married women using modern methods of contraception' = "modern_contraception_methods",
                                             'Birth rate' = "birth_rate",
                                             'Death rate' = "death_rate",
                                             'Infant mortality rate' = "infant_mortality_rate",
                                             'Maternal deaths' = "maternal_deaths",
                                             'Adolescent fertility rate' = "adolescent_fertility_rate",
                                             'Fertility rate' = "fertility_rate",
                                             'Male life expectancy' = "male_life_expectancy",
                                             'Female life expectancy' = "female_life_expectancy",
                                             'Male literacy rate' = "male_lit_rate",
                                             'Female literacy rate' = "female_lit_rate",
                                             'GDP' = "gdp",
                                             'Work force ratio, women to men' = "work_force_ratio",
                                             'Proportion of men in the labor force' = "male_labor_force_participation",
                                             'Proportion of women in the labor force' = "female_labor_force_participation",
                                             'Proportion of men who participate in the economy' = "male_econ_activity",
                                             'Proportion of women who participate in the economy' = "female_econ_activity"),
                              selected = "Proportion of married women using any method of contraception"))
                )
               
  )
              



