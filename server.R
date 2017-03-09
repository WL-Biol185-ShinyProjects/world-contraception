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
World_Development_Indicators_3$GDP_in_USd <- 0
tidyWorldDvelopSpreaded <- spread(World_Development_Indicators_3, key = "GDP_in_USd", value = "GDP (current US$)", fill = NA, convert = FALSE, drop = FALSE, sep = NULL)
tidyWorldDevelop <- gather(World_Development_Indicators_3, key = "year", value = "GDP (current US$)", 5:61)


tidyWorldDevelop2 <- gather(tidyWorldDevelop, key = "year", value = "Adult literacy rate, population 15+ years, both sexes (%)", 5:61)
tidyWorldDevelop3 <- gather(tidyWorldDevelop2, key = "year", value = "Lifetime risk of maternal death (%)", 5:61)
tidyWorldDevelop4 <- gather(tidyWorldDevelop3, key = "year", value = "Adult literacy rate, population 15+ years, both sexes (%)", 5:61)
tidyWorldDevelop5 <- gather(tidyWorldDevelop4, key = "year", value = "Birth rate, crude (per 1,000 people)", 5:61)