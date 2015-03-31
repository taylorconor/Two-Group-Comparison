
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  title = "Two Group Study",
  h1("Two Group Study"),
  
  fluidRow(
    column(4,
      br(),
      fileInput('file', 
                'Choose file to upload', 
                accept = c( 'text/csv', '.csv' )),
      sliderInput("samples",
                  "Number of samples:",
                  min = 2,
                  max = 500,
                  value = 150)
    ),
    column(8,
      plotOutput("distPlot"),
      fluidRow(
        column(6,
          sliderInput("xscale",
                      "X scale",
                      min = 0,
                      max = 10,
                      value = c(6,7))
        ),
        column(6,
          sliderInput("yscale",
                      "Y scale",
                      min = 0,
                      max = 250,
                      value = c(0,25))
        )  
      )
    )
  )
))
