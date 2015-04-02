
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(pracma)

# a function that can move the required data along the x axis, according to n.
# used to move the red curve the important difference along the x axis.
shift <- function (data, n) {
  for (i in 1:length(data)) {
    data[i] = data[i] + n
  }
  return(data)
}

shinyServer(function(input, output) {
  
  # reactive inputs allow us to edit the parameters of the plot without resampling
  xmin <- reactive({ as.numeric(input$xmin) })
  xmax <- reactive({ as.numeric(input$xmax) })
  ymin <- reactive({ as.numeric(input$ymin) })
  ymax <- reactive({ as.numeric(input$ymax) })
  importantdiff <- reactive({ as.numeric(input$importantdiff )})
  
  # functions to read graph1 and graph2 from the input file.
  # if no file has been input, it defaults to our rand.csv sample file
  graph1 <- reactive({ 
    file <- input$file
    if (is.null(file))
      d <- read.csv("rand.csv")[[1]]
    else
      d <- read.csv(file$datapath)[[1]]
    return(replicate(1000, mean(sample(d, input$samples))))
  })
  graph2 <- reactive({ 
    file <- input$file
    if (is.null(file))
      d <- read.csv("rand.csv")[[2]]
    else
      d <- read.csv(file$datapath)[[2]]
    return(replicate(1000, mean(sample(d, input$samples))))
  })
  
  output$distPlot <- renderPlot({
    g1 <- graph1()
    g2 <- graph2()
    
    # the point on the x axis where the 'green area' begins
    xpt <- sd(g1) * 1.96
    #xpt <- (mean(g1)-mean(g2)) + 1.96*(sd(graph1())/sqrt(input$samples))

    # calculate the % of the green area
    lx <- vector()
    ly <- vector()
    g <- density(shift(g2, importantdiff()))
    for (i in 1:length(g$x)) {
      if (g$x[i] >= xpt) {
        lx <- c(lx,g$x[i])
        ly <- c(ly,g$y[i])
      }
    }
    auc <- trapz(density(g2)$x,density(g2)$y)
    green <- trapz(lx,ly)

    output$percentage <- renderText({
        paste("Green area: ", toString(signif(((green/auc)*100),4)), "%", sep="")
    })
    
    # plot all of the polygons needed for output
    plot(density(g1), main="", ylim=c(ymin(),ymax()), xlim=c(xmin(),xmax()))
    polygon(density(shift(g2, importantdiff())), col="green")
    rect(xmin()-abs(xmin()),ymin(),xpt,ymax()+abs(ymax()),col="white",border="white")
    polygon(density(g1), border="blue")
    polygon(density(shift(g2, importantdiff())), border="red")
  })
  
})
