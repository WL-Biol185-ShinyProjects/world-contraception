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
                titlePanel("World Contraception Use and Indicators of Country Development"),
                mainPanel("Welcome to the World Contraception Use and Indicators of Country Development data app! 
                          This app is designed to allow the exploration of the relationship between contraception 
                          use by women throughout the world and indicators of country development. We utilize population 
                          statistics made available by the Population Reference Bureau (PRB) to create an interactive
                          visualization demonstrating how geographic location and the stage of developent in a country
                          strongly influences women's use of contraception.", 
                          br(),
                          br(),
                          "Among our data visualizations located in the Data tab of the app, we include a map in which 
                          different inputs can be selected in order to plot an illustration of contraception use and 
                          developmental indicators by country. Next, we include a barplot illustrating the data visualized 
                          in the map in graphical form. In order to determine how contraception use and country development
                          are related to each other, we include a tab in which these variables can be selected on different
                          axes so that correlations can be observed between these indicators."
                          ))),
      tabItem(tabName = "background",
              fluidPage(
                theme = shinytheme("flatly"),
                titlePanel("Background"),
                h4(br(),
                   "Contraception usage serves as an indicator of the economic and social freedom of women.
                   As a result, developing an understanding of the factors influencing the ability of 
                   women to access and use different forms of contraception may help to identify areas 
                   where interventions can increase women's freedom.",
                   br(),
                   br(),
                   "Information about modern contraceptives vs. other forms of contraceptives.",
                   br(),
                   br(),
                   br(),
                   "See the following for more information regarding the relationship between contraception use, 
                   female empowerment, and country development:",
                   br(),
                   br()),
                
                   h5(helpText(a("- Women's Empowerment and Contraceptive Use: The Role of Independent versus Couples' Decision-Making, from a Lower Middle Income Country Perspective")),
                      helpText(a("- Unmet Need for Contraception in Developing Countries: Examining Women’s Reasons for Not Using a Method")),
                      helpText(a("- In The World’s Poorest Countries, Demand For Birth Control Is Increasing But Access To It Isn’t")),
                      helpText(a("- Women's Empowerment and Family Planning: A Review of the Literature")))
                  )),
      tabItem(tabName = "data",
              sidebarLayout( 
                sidebarPanel(position = "above",
                             width = 12,
                             selectInput(inputId = "variable1",
                                         label = "Select contraception use or country development indicators to plot or map:",
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