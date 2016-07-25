library(shiny)
nbp <- read.csv("nbp.csv")
shinyUI(
  fluidPage(
    tags$head(
      tags$style(HTML("
                      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                      
                      h1 {
                      font-family: 'Lobster', cursive;
                      font-weight: 500;
                      line-height: 1.1;
                      color: #48ca3b;
                      }
                      
                      "))
      ),
    # Application title
    titlePanel("Predictor App for a Bank",
               windowTitle = "Rating Predictor"),
    h5("Internal ratings-based approach (credit risk)"),
    
    sidebarLayout(
      # sidebarPanel ------------------------------------------------------------
      sidebarPanel(
        #tags$img(src="StackOverflow.jpg"),
        # width = "200px", height = "200px"),
        hr(),
        h5('Enter parameters for prediction:'),
        hr(),
        selectInput("Province", "Province", 
                     choices= unique(as.character(nbp$Province))),
        
        selectInput("Region", "Region", 
                     choices= unique(as.character(nbp$Region))),
        
        selectInput("ClassPercent", "Class Percent", 
                    choices= unique(as.character(nbp$ClassPercent))),
        
        selectInput("Product", "Product", 
                    choices= unique(as.character(nbp$Product))),
        
        selectInput("SubProduct", "Sub Product", 
                    choices= unique(as.character(nbp$SubProduct))),
        
        
        selectInput("Finance", "Finance", 
                    choices= unique(as.character(nbp$Finance))),
        
        
        selectInput("Segment", "Segment", 
                    choices= unique(as.character(nbp$Segment))),
        
        selectInput("Purpose", "Purpose", 
                    choices= unique(as.character(nbp$Purpose))),
        
        selectInput("InstallmentType", "Installment Type", 
                    choices= unique(as.character(nbp$InstallmentType))),
        
        
        selectInput("Performa", "Performa", 
                    choices= unique(as.character(nbp$Performa))),
        
        selectInput("Provision", "Provision", 
                    choices= unique(as.character(nbp$Provision))),
        
        selectInput("TotalAc", "Total Account", 
                    choices= unique(as.character(nbp$TotalAc))),
        h5("NBP Prediction ")
        
        ),
      
      mainPanel(
        tabsetPanel(
          tabPanel("Results", h2("Based on your input, The Bank Alogo predictor predicts the borrower will be categorized as "),
                   h2(verbatimTextOutput("results")),
                   h2(" Based on the Parameters selected"),
                   p(), "Note:" , p(), "This is a trial application developed for 
                   proof of concept by Azam Yahya")
          )
        )
      )
      ))