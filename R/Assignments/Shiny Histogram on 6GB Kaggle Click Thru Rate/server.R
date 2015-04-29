library(shiny)
source("C:/Users/AliDesktop/Desktop/Magic Briefcase/School/1/2- Stat Programming/lecture/Temp.R")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$distPlot <- renderPlot({
    x    <- CTRRAW$banner_pos
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
})

#banner position 0 or 1 indicating bottom or top respectively, the results suprised me
# that in the entire sample set there were none of the other 3, of total 5 banner
# positions present. It was not suprising to see however, given most of the users were
# either mobile or PC. It was not also suprising that top or bottom banner ads,
# given my own anecdotal expectations, were clearly outnumbering side and pop up
# banner ads