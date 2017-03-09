# world-contraception
Differences in contraception use around the world

Hello, it's me

#importing dataset

#Woo we did it!

#now need to gather so "year" can be a variable
#fix the code below!!!
library(tidyr)
tidyWorldData <- function(table) {
  # gather
  tidy <- gather(table[5:15], key = "year", value = "index", )
  
  # lower case all variable names
  colnames(tidy) <- tolower(colnames(tidy))
  
}