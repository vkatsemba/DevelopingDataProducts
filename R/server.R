library(shiny)
library(ggplot2)
data("diamonds")

shinyServer(function(input, output) {
  diamonds$caratmean <- ifelse(diamonds$carat - 0.8 > 0, diamonds$carat - 0.8, 0)
  lm1 <- lm(price ~ carat, data = diamonds)
  lm2 <- lm(price ~ caratmean + carat, data = diamonds)
  
  lm1pred <- reactive({
    caratInput <- input$slidercarat
    predict(lm1, newdata = data.frame(carat = caratInput))
  })
  
  lm2pred <- reactive({
    caratInput <- input$slidercarat
    predict(lm2, newdata = 
              data.frame(carat = caratInput,
                         caratmean = ifelse(caratInput - 0.8 > 0,
                                            caratInput - 0.8, 0)))
  })
  output$plot1 <- renderPlot({
    caratInput <- input$slidercarat
    
    plot(diamonds$carat, diamonds$price, xlab = "Weight(Carat)",
         ylab = "Price", bty = "n", pch = 19,
         xlim = c(0.2,5), ylim = c(326,18823))
    if(input$showlm1){
      abline(lm1, col = "green", lwd = 2)
    }
    if(input$showlm2){
      lm2lines <- predict(lm2, newdata = data.frame(
        carat = 0.2:5, caratmean = ifelse(0.2:5 - 0.8 > 0, 0.2:5 - 0.8, 0)
      ))
      lines(0.2:5, lm2lines, col = "orange", lwd = 2)
    }
    legend(25, 250, c("Model 1 Prediction", "Model 2 Prediction"), pch = 19,
           col = c("green","orange"), bty = "n", cex = 1.2)
    points(caratInput, lm1pred(), col = "green", pch = 19, cex = 1.2)
    points(caratInput, lm2pred(), col = "orange", pch = 19, cex = 1.2)
  })
  
  output$pred1 <- renderText({
    lm1pred()
  })
  
  output$pred2 <- renderText({
    lm2pred()
  })
})    
