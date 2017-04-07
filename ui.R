library(shiny)
library(leaflet)
library(shinythemes)
library(shinydashboard)
geoJSON_map <- readRDS(file = "geoJSON_map.rds")
map <- readRDS(file = "map.rds")

dashboardPage(
  dashboardHeader(title = "World Contraception Use and Indicators of Development"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home"),
      menuItem("Background", tabName = "background"),
      menuItem("Data", tabName = "data"),
      menuItem("Sources", tabName = "sources"))),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              fluidPage(
                theme = shinytheme("flatly"),
                titlePanel("World Contraception Use and Indicators of Development"),
                mainPanel("Here is where we state our project"))),
      tabItem(tabName = "background",
              fluidPage(
                theme = shinytheme("flatly"),
                titlePanel("Background"),
                h4("This is where we explain what we are doing, why, and how it will help society"))),
      tabItem(tabName = "data",
              sidebarLayout( 
                sidebarPanel(position = "above",
                             width = 12,
                             selectInput(inputId = "variable1",
                                         label = "Select contraception use or country development indicators to map:",
                                         choices = list('Proportion of married women who use any method of contraception' = "all_contraception_methods",
                                                        'Proportion of married women who use modern methods of contraception' = "modern_contraception_methods",
                                                        'Birth rate (annual number of births per 1,000 total population)' = "birth_rate",
                                                        'Death rate (annual number of deaths per 1,000 total population)' = "death_rate",
                                                        'Infant mortality rate (infant deaths per 1,000 live births)' = "infant_mortality_rate",
                                                        'Maternal deaths (deaths per 100,000 births)' = "maternal_deaths",
                                                        'Adolescent fertility rate' = "adolescent_fertility_rate",
                                                        'Fertility rate (number of children born per woman)' = "fertility_rate",
                                                        'Male life expectancy (years)' = "male_life_expectancy",
                                                        'Female life expectancy (years)' = "female_life_expectancy",
                                                        'Male literacy rate (proportion of literate males)' = "male_lit_rate",
                                                        'Female literacy rate (proportion of literate females)' = "female_lit_rate",
                                                        'GDP ($)' = "gdp",
                                                        'Work force ratio, women to men' = "work_force_ratio",
                                                        'Proportion of men in the labor force' = "male_labor_force_participation",
                                                        'Proportion of women in the labor force' = "female_labor_force_participation",
                                                        'Proportion of men who participate in the economy' = "male_econ_activity",
                                                        'Proportion of women who participate in the economy' = "female_econ_activity"),
                                         selected = "Proportion of married women using any method of contraception")),
                mainPanel(position = "below",
                          tabsetPanel(
                            tabPanel("Map", leafletOutput("shinymap", height = 500, width = 950), position = "below"),
                            tabPanel("Bar Plots", 
                                     sidebarLayout(
                                       sidebarPanel(position = "left",
                                                    width = 8,
                                                    selectizeInput(inputId = "selectize", 
                                                                   label = 'Select countries to plot:',
                                                                   selected = NULL,
                                                                   choices = geoJSON_map@data$name, multiple = TRUE)),
                                     mainPanel(position = "right", plotOutput("barplot", height = 400, width = 2500)))),
                            tabPanel("Correlations", 
                                     sidebarLayout( 
                                       sidebarPanel(position = "left",
                                                    width = 8,
                                                    selectInput(inputId = "variable2",
                                                                label = "Select a second contraception use or country development variable:",
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
                                                                selected = "Proportion of married women using any method of contraception"),
                                                   checkboxInput(inputId = "colorBy",
                                                                 label = "Color by GDP",
                                                                 value = FALSE)),
                                       mainPanel(position = "right", plotOutput("correlations", height = 400, width = 950), position ="below"))))))),
      tabItem(tabName = "sources",
              fluidPage(
                theme = shinytheme("flatly"),
                titlePanel("Data Sources"),
                
                br(),
                fluidRow(("Our data was obtained by compiling data sheets from the Population Reference Bureau."),
                align = "left"),
                
                br(),
                
                helpText(a("Click here to download our data set", align = "center") 
                
                )))
    )
  )
)