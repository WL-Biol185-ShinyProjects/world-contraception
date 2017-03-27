library(shiny)
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

#Leaflet Map

library(shiny)
library(leaflet)

#Maptrial

library(ggplot2)
library(rgeos)
library(maptools)
library(fields)
library(rworldmap)
library("mapdata")
install.packages("rworldmap")
library(rworldmap)
data(world_data)
map_data <- joinCountryData2Map(world_data,
                                joinCode = "NAME",
                                nameJoinColumn = "country")
mapCountryData(map_data, nameColumnToPlot = "unmet_need")


#geoJSON functioning example

map <- rgdal::readOGR("countries.geo.json", "OGRGeoJSON")
View(map)
map@data$value <- "test"
map@data$all_contraception_methods <- final_data$all_methods
map@data$value <- runif(180, 0, 100)

View(map)
library(leaflet)

bins <- seq(0, 108, 12)
pal  <- colorBin("YlOrRd", map@data$value, bins)

leaflet(data = map) %>%
  addTiles()        %>%
  addPolygons(fillColor = ~pal(value))

#Fix world_data file to match geoJSON

library(dplyr)
?spread
?dplyr
browseVignettes(package = "dplyr")

#attempt at spreading data
library(tidyr)
sprd_adult_lit <- spread(tidy_Adult_lit_rate, year, Adult_lit_rate_pop_15plusyears_both_sexes_percent)

write.csv(world_data, "world_data.csv")
View("countries.geo.json")

#Data wrangling of economically active persons

library(tidyr)
tidy_econ_active_ppl <- spread(economically_active_persons, Gender, percent_economically_active, fill = NA, convert = FALSE)
tidy_econ_active_ppl$`<NA>` <- NULL
tidy_econ_active_ppl_2 <- tidy_econ_active_ppl[-1,]
tidy_econ_active_ppl_3 <- tidy_econ_active_ppl_2[-57,]
final_econ_activity <- tidy_econ_active_ppl_3
View(map)
colnames(final_econ_activity)[colnames(final_econ_activity)=="Country"] <- "name"
colnames(final_econ_activity)[colnames(final_econ_activity)=="Females"] <- "econ_activity_women"
colnames(final_econ_activity)[colnames(final_econ_activity)=="Males"] <- "econ_activity_men"


#Data wrangling of literacy rates

library(tidyr)
tidy_lit_rates <- spread(literacy_rates, Gender, literacy_rate, fill = NA, convert = FALSE)
tidy_lit_rates$`<NA>` <- NULL
tidy_lit_rates_2 <- tidy_lit_rates[-1,]
tidy_lit_rates_3 <- tidy_lit_rates_2[-57,]
final_lit_rates <- tidy_lit_rates_3
View(map)
colnames(final_lit_rates)[colnames(final_lit_rates)=="Country"] <- "name"
colnames(final_lit_rates)[colnames(final_lit_rates)=="Females"] <- "lit_rate_women"
colnames(final_lit_rates)[colnames(final_lit_rates)=="Males"] <- "lit_rate_men"


#join literacy rates and econ activity

library(dplyr)
lit_rates_econ_activity <- left_join(final_econ_activity, final_lit_rates, by="name")

#join data sets for final table

final_data <- left_join(final_world_contraception, lit_rates_econ_activity, by="name")
write.table(final_data, "final_data.csv")

#add columns to map GEOJSON

View(map)
map$`<value>` <- NULL
map@data$value <- "test"
map@data$all_contraception_methods <- final_data$"all_methods"
final_data_no_Andora <- final_data[-4,]


#attempt to solve the problem with merging maps and our data

maps_ready_data <- left_join(map_names, final_data, by="name")
write.table(maps_ready_data, "maps_ready_data.csv")
map@data$all_contraception_methods <- maps_ready_data$"all_methods"
map@data$modern_contraception_methods <- maps_ready_data$"modern_methods"
map@data$adolescent_fertility_rate <- maps_ready_data$"adolescence_fertility_rate"
map@data$birth_rate <- maps_ready_data$"birth_rate"
map@data$death_rate <- maps_ready_data$"death_rate"
map@data$infant_mortality_rate <- maps_ready_data$"infant_mortality_rate"
map@data$fertility_rate <- maps_ready_data$"fertility_rate"
map@data$work_force_ratio <- maps_ready_data$"workforce_ratio"
map@data$maternal_deaths <- maps_ready_data$"maternal_deaths"
map@data$male_life_expectancy <- maps_ready_data$"male_life_expectancy"
map@data$female_life_expectancy <- maps_ready_data$"female_life_expectancy"
map@data$gdp <- maps_ready_data$"gdp"
map@data$male_labor_force_participation <- maps_ready_data$"male_laborforce_participation"
map@data$female_labor_force_participation <- maps_ready_data$"female_laborforce_participation"
map@data$female_econ_activity <- maps_ready_data$"econ_activity_women"
map@data$male_econ_activity <- maps_ready_data$"econ_activity_men"
map@data$female_lit_rate <- maps_ready_data$"lit_rate_women"
map@data$male_lit_rate <- maps_ready_data$"lit_rate_men"


#Attempt to make a map

View(map)
library(leaflet)

bins <- seq(0, 100, 10)
pal  <- colorBin("YlOrRd", map@data$all_contraception_methods, bins)

leaflet(data = map) %>%
  addPolygons(fillColor = ~pal(all_contraception_methods))

#attempt to remove percents from data

updated_maps_data <- maps_ready_data[,all_contraception_methods] <- as.numeric(sub("%", "", maps_ready_data[,all_contraception_methods]))
#need to convert percentages in maps_ready_data and then add columns back into maps

