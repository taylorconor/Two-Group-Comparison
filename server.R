
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
  
  xmin <- reactive({ as.numeric(input$xmin) })
  xmax <- reactive({ as.numeric(input$xmax) })
  ymin <- reactive({ as.numeric(input$ymin) })
  ymax <- reactive({ as.numeric(input$ymax) })
  importantdiff <- reactive({ as.numeric(input$importantdiff )})
  graph1 <- reactive({ 
    file <- input$file
    if (is.null(file))
      file$datapath <- "rand.csv"
    d <- read.csv(file$datapath)[[1]]
    
    bootres <- boot(data=d, statistic=meanboot, R=input$samples)
    return(bootres$t)
  })
  graph2 <- reactive({ 
    file <- input$file
    if (is.null(file))
      file$datapath <- "rand.csv"
    d <- read.csv(file$datapath)[[2]]
    
    bootres <- boot(data=d, statistic=meanboot, R=input$samples)
    return(bootres$t)
  })
  
  output$distPlot <- renderPlot({
    xpt <- (mean(graph2())-mean(graph1())) + 1.96*(sd(graph1())/sqrt(1000))
    plot(density(graph1()), main="", ylim=c(ymin(),ymax()), xlim=c(xmin(),xmax()))
    polygon(density(shift(graph2(), importantdiff())), col="yellow")
    rect(xmin(),ymin(),xpt,ymax(),col="white",border="white")
    polygon(density(graph1()), border="blue")
    polygon(density(shift(graph2(), importantdiff())), border="red")
  })
  
})
