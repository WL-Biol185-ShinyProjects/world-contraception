library(shiny)

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
