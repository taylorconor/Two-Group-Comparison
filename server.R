
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
      d <- rnorm(1000)
    else
      d <- read.csv(file$datapath)[[1]]
    
    return(d)
  })
  graph2 <- reactive({ 
    file <- input$file
    if (is.null(file))
      d <- rnorm(1000)
    else
      d <- read.csv(file$datapath)[[2]]
    
    return(d)
  })
  
  output$distPlot <- renderPlot({
    g1 <- replicate(1000, mean(sample(graph1(), input$samples)))
    g2 <- replicate(1000, mean(sample(graph2(), input$samples)))
    
    xpt <- sd(g1) * 2
    xpt <- (mean(g1)-mean(g2)) + 1.96*(sd(graph1())/sqrt(input$samples))
    
    #print(xpt)
    #print(sd(g1))
    
    plot(density(g1), main="", ylim=c(ymin(),ymax()), xlim=c(xmin(),xmax()))
    
    polygon(density(shift(g2, importantdiff())), col="yellow")
    rect(xmin()-abs(xmin()),ymin(),xpt,ymax()+abs(ymax()),col="white",border="white")
    polygon(density(g1), border="blue")
    polygon(density(shift(g2, importantdiff())), border="red")
  })
  
})
