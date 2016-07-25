library(shiny)
library(dplyr)
library(plyr)
library(caret)
library(shinyapps)
library(data.table)
library(caret)

nbp <- read.csv("nbp.csv")


shinyServer(
  function(input, output){
    nnetfit_nnet <- readRDS("model.Rds")
    training <- read.csv("nbp.csv")
    userdf <- training[1,]
    
    values <- reactiveValues()
    values$df <- userdf
    newEntry <- observe({
      values$df$Province <- input$Province
      values$df$Region <- input$Region
      values$df$Product<- input$Product
      values$df$SubProduct <- input$SubProduct
      values$df$Finance <- input$Finance
      values$df$Segment <- input$Segment
      values$df$Purpose <- input$Purpose
      values$df$InstallmentType <- input$InstallmentType
      values$df$Performa <- input$Performa
      values$df$Provision <- input$Provision
      values$df$ClassPercent <- input$ClassPercent
      values$df$TotalAc <- input$TotalAc
          })
    
    output$results <- renderPrint({
      { ds1 <- values$df
      a <- capture.output(predict(nnetfit_nnet, newdata = data.frame(ds1)))
      names(a) <- NULL
      a[1]
      
      }
    })
  })