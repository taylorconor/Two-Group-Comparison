
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
   
  output$distPlot <- renderPlot({

    d <- read.csv("~/Downloads/lab4times.csv")[[1]]
    bootres <- boot(data=d, statistic=meanboot, R=input$samples)
    
    d <- density(bootres$t)
    plot(d, main="", ylim=c(0,50), xlim=c(6.6,7))
    polygon(d, border="blue")
  })
  
})
