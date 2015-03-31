
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
  graph <- reactive({ 
    d <- read.csv("lab4times.csv")[[1]]
    bootres <- boot(data=d, statistic=meanboot, R=input$samples)
    return(density(bootres$t))
  })
  
  output$distPlot <- renderPlot({
    plot(graph(), main="", ylim=yscale(), xlim=xscale())
    polygon(graph(), border="blue")
  })
  
})
