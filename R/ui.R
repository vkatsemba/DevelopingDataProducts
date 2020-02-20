library(shiny)
library(markdown)
library(dplyr)
shinyUI(navbarPage("Predict the price of a diamond",
    tabPanel("Main",
      sidebarLayout(
        sidebarPanel(
          sliderInput("slidercarat", "What is the weight of the diamond?", 0.2, 5, value = 2.6),
          checkboxInput("showlm1", "Display the first model", value = TRUE),
          checkboxInput("showlm2", "Display the second model", value = TRUE)
        ),  
        mainPanel(
          plotOutput("plot1"),
          h3("Predicted price of the diamond from the first model:"),
          textOutput("pred1"),
          h3("Predicted price of the diamond from the second model:"),
          textOutput("pred2")
        )
      )
    ),
    tabPanel("About",
             mainPanel(
               includeMarkdown("about.rmd")
             )
    )
))    
