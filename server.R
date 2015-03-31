
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(boot)

meanboot <- function (x,indices) {
  mean(x[indices])
}

shift <- function (data, n) {
  for (i in 1:length(data)) {
    data[i] = data[i] + n
  }
  return(data)
}

shinyServer(function(input, output) {
  
  xscale <- reactive({ as.numeric(input$xscale) })
  yscale <- reactive({ as.numeric(input$yscale) })
  importantdiff <- reactive({ as.numeric(input$importantdiff )})
  graph1 <- reactive({ 
    file <- input$file
    if (is.null(file))
      return(NULL)
    d <- read.csv(file$datapath)[[1]]
    
    bootres <- boot(data=d, statistic=meanboot, R=input$samples)
    return(bootres$t)
  })
  graph2 <- reactive({ 
    file <- input$file
    if (is.null(file))
      return(NULL)
    d <- read.csv(file$datapath)[[2]]
    
    bootres <- boot(data=d, statistic=meanboot, R=input$samples)
    return(bootres$t)
  })
  
  output$distPlot <- renderPlot({
      plot(density(graph1()), main="", ylim=yscale(), xlim=xscale())
      polygon(density(graph1()), border="blue")
      polygon(density(shift(graph2(), importantdiff())), border="red")
  })
  
})
