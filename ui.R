
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Two Group Study"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    sliderInput("samples",
                "Number of samples:",
                min = 2,
                max = 500,
                value = 150)
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
  )
))
