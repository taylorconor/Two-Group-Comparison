
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

shinyServer(function(input, output) {
  
  xscale <- reactive({ as.numeric(input$xscale) })
  yscale <- reactive({ as.numeric(input$yscale) })
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
      print(mean(graph1()))
      print(mean(graph2()))
      plot(density(graph1()), main="", ylim=yscale(), xlim=xscale())
      polygon(density(graph1()), border="blue")
      polygon(density(graph2()), border="red")
  })
  
})
