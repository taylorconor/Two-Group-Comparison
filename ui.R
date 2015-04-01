
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  title = "Two Group Comparison",
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
                  value = 150),
      numericInput("importantdiff",
                  "Important difference:",
                  value = 0.1)
    ),
    column(8,
      plotOutput("distPlot"),
      h3(textOutput("percentage"), align="center"),
      br(),
      fluidRow(
        column(3,
          numericInput("xmin",
                      "X min",
                      value = -0.2)
        ),
        column(3,
          numericInput("xmax",
                       "X max",
                       value = 0.4)
        ),
        column(3,
          numericInput("ymin",
                      "Y min",
                      value = 0)
        ),
        column(3,
          numericInput("ymax",
                      "Y max",
                      value = 8)
        )
      )
    )
  )
))
