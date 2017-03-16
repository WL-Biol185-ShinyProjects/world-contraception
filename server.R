library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})

library(tidyverse)
library(dplyr)

Adult_lit_rate <- filter(World_Development_Indicators_4, Series_Name == "Adult_lit_rate_pop_15plusyears_both_sexes_percent")
tidy_Adult_lit_rate <- gather(Adult_lit_rate, key = "year", value = "Adult_lit_rate_pop_15plusyears_both_sexes_percent", `1960`:`2016`)

Birth_rate <- filter(World_Development_Indicators_4, Series_Name == "Birth_rate_crude_per_1000_ppl")
tidy_Birth_rate <- gather(Birth_rate, key = "year", value = "Birth_rate_crude_per_1000_ppl", `1960`:`2016`)

GDP <- filter(World_Development_Indicators_4, Series_Name == "GDP_currentUsd")
tidy_GDP<- gather(GDP, key = "year", value = "GDP_currentUsd", `1960`:`2016`)

Life_expect <- filter(World_Development_Indicators_4, Series_Name == "Life_expectancy_at_birth_total_years")
tidy_Life_expect <- gather(Life_expect, key = "year", value = "Life_expectancy_at_birth_total_years", `1960`:`2016`)

Maternal_death_risk <- filter(World_Development_Indicators_4, Series_Name == "Lifetime_risk_of_mat_death_percent")
tidy_mat_death_risk <- gather(Maternal_death_risk, key = "year", value = "Lifetime_risk_of_mat_death_percent", `1960`:`2016`)

Pop_growth <- filter(World_Development_Indicators_4, Series_Name == "Population_growth_annualpercent")
tidy_pop_growth <- gather(Pop_growth, key = "year", value = "Population_growth_annualpercent", `1960`:`2016`)

Adult_Birth <- full_join(tidy_Adult_lit_rate, tidy_Birth_rate, by = c("Country_Name", "Country_Code", "year"))

tidy_Adult_lit_rate$Series_Name <- NULL
tidy_Birth_rate$Series_Name <- NULL
tidy_GDP$Series_Name <- NULL
tidy_Life_expect$Series_Name <- NULL
tidy_mat_death_risk$Series_Name <- NULL
tidy_pop_growth$Series_Name <- NULL

Adult_Birth <- full_join(tidy_Adult_lit_rate, tidy_Birth_rate, by = c("Country_Name", "Country_Code", "year"))
Adult_Birth_GDP <- full_join(Adult_Birth, tidy_GDP, by = c("Country_Name", "Country_Code", "year"))
Adult_Birth_GDP_LifeExp <- full_join(Adult_Birth_GDP, tidy_Life_expect, by = c("Country_Name", "Country_Code", "year"))
Adult_Birth_GDP_LifeExp_MatDeath <- full_join(Adult_Birth_GDP_LifeExp, tidy_mat_death_risk, by = c("Country_Name", "Country_Code", "year"))
Final_World_Develp_Indicators <- full_join(Adult_Birth_GDP_LifeExp_MatDeath, tidy_pop_growth, by = c("Country_Name", "Country_Code", "year"))

read.table("Final_World_Develop_Indicators.txt")

colnames(Contraceptive) <- tolower(colnames(Contraceptive))
colnames(Final_World_Develp_Indicators) <- tolower(colnames(Final_World_Develp_Indicators))
setNames(Final_World_Develp_Indicators, "country_name", "country")
?setNames
colnames(Final_World_Develp_Indicators)[colnames(Final_World_Develp_Indicators)=="country_name"] <- "country"
as.character(Contraceptive, "year")
as.character(Final_World_Develp_Indicators, "year")

Contraceptive$yearcharacter <- as.character(Contraceptive$year)
Final_World_Develp_Indicators$yearcharacter <- as.character(Final_World_Develp_Indicators$year)
world_data <- inner_join(Final_World_Develp_Indicators, Contraceptive, by = c("yearcharacter", "country"))

write.table(world_data, file = "world_data.txt")
read.table("world_data.txt")

#Map

library(shiny)
library(leaflet)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage(
  leafletOutput("mymap"),
  p(),
  actionButton("recalc", "New points")
)

server <- function(input, output, session) {
  
  points <- eventReactive(input$recalc, {
    cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(data = points())
  })
}

shinyApp(ui, server)
