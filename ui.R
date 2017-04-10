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
                h5("Welcome to the World Contraception Use and Indicators of Country Development data app! 
                          This app is designed to allow the exploration of the relationship between contraception 
                          use by women throughout the world and indicators of country development. We utilize population 
                          statistics made available by the Population Reference Bureau (PRB) to create an interactive
                          visualization demonstrating how geographic location and the stage of developent in a country
                          strongly influences women's use of contraception.", 
                          br(),
                          br(),
                          img(src = "world_map.png",
                              width = 600,
                              height = 307.5,
                              align = "center"),
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
                   Women who are able to choose for themselves whether or not to use contraception 
                   and what form of it to use are provided with the opportunity to take control over their 
                   own bodies and pursue goals that fit within their own personal values. The ability of women to
                   make these decisions is often reflected by the circumstances and settings in which they 
                   find themselves. Throughout the world, women experience differing levels of education and 
                   economic participation, and these differential life experiences can influence not only women's 
                   ability to understand the purpose of contraception, but also their ability to access it.
                   Therefore, developing an understanding of the factors that influence and indicate the ability of 
                   women to access and use different forms of contraception may help to identify areas 
                   in which interventions may work to protect the basic social and economic rights and freedoms of women.",
                   br(),
                   br()),
                h4("The geographic location of persons can have significant effects on their ability to access and use contraception.
                   In many developing countries, couples use only traditional methods of contraception, such as rhythm and withdrawal, 
                   and these methods are often found to be less effective than modern methods available in developed countries."),
                   h4(br(),
                   img(src = "traditional_contraception_map.png",
                       width = 600,
                       height = 547.5,
                       align = "center"),
                   br(),
                   br(),
                   "Increasing the availability of and education regarding birth control worldwide can reduce the number of unintended pregnancies and abortions, 
                   improve quality of life for women, and enhance country development.",
                   br(),
                   br(),
                   img(src = "contracep_unmetneed.png"),
                   br(),
                   br(),
                   
                   
                   "Please see the following for more information regarding the relationship between contraception use, 
                   female empowerment, and country development:",
                   br(),
                   br()),
                
                   h5(helpText(a("Women's Empowerment and Contraceptive Use: The Role of Independent versus Couples' Decision-Making, from a Lower Middle Income Country Perspective",
                                href="http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0104633",
                                target="_blank")),
                      helpText(a("Unmet Need for Contraception in Developing Countries: Examining Women’s Reasons for Not Using a Method",
                                 href="https://www.guttmacher.org/report/unmet-need-for-contraception-in-developing-countries",
                                 target="_blank")),
                      helpText(a("In The World’s Poorest Countries, Demand For Birth Control Is Increasing But Access To It Isn’t",
                                 href="https://thinkprogress.org/in-the-worlds-poorest-countries-demand-for-birth-control-is-increasing-but-access-to-it-isn-t-94183b3c3871",
                                 target="_blank")),
                      helpText(a("Women's Empowerment and Family Planning: A Review of the Literature",
                                 href="https://www.cambridge.org/core/journals/journal-of-biosocial-science/article/womens-empowerment-and-family-planning-a-review-of-the-literature/DB0C0FC1BB23407AC9C256556DAE435B",
                                 target="_blank")))
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
                                     fluidRow(
                                       box(width = 12,
                                     sidebarLayout(
                                       sidebarPanel(position = "left",
                                                    width = 8,
                                                    selectizeInput(inputId = "selectize", 
                                                                   label = 'Select countries to plot:',
                                                                   selected = NULL,
                                                                   choices = geoJSON_map@data$name, multiple = TRUE)),
                                     mainPanel(position = "right", plotOutput("barplot", height = 400)))))),
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
                h5(
                br(),
                "Our data was obtained by compiling data sheets from the Population Reference Bureau.",
                br(),
                br(),
                
                downloadButton("downloadData",
                               label = "Download our data set",
                               class = NULL),
                br()),
                h5("Original datasets:",
                helpText(a("http://www.prb.org/DataFinder/Topic.aspx?cat=8",
                           href="http://www.prb.org/DataFinder/Topic.aspx?cat=8",
                           target="_blank")),
                br(),
                br()),
                h5("GeoJSON border data retrieved from:",
                br(),
                helpText(a("Johan Sundström GitHub",
                           href="https://github.com/johan/world.geo.json/blob/master/countries.geo.json",
                           target="_blank"))),
                h5(
                  br(),
                  br(),
                  "Image sources:",
                  br(),
                  helpText(a("https://openclipart.org/detail/7885/blue-world-map",
                             href="https://openclipart.org/detail/7885/blue-world-map")),
                  helpText(a("https://onlinedoctor.superdrug.com/birth-control-around-the-world/",
                             href="https://onlinedoctor.superdrug.com/birth-control-around-the-world/")),
                  helpText(a("http://themindbodyshift.com/index.php/2015/04/23/sustain-condoms-can-help-climate-change-through-curbing-population-growth/",
                             href="http://themindbodyshift.com/index.php/2015/04/23/sustain-condoms-can-help-climate-change-through-curbing-population-growth/")))
                  
                  
                )
                
                )
              ))
    )
  
