library(shiny)

shinyUI(fluidPage(
 
    titlePanel("Data Science Capstone Project"),
    
    fluidRow(
        HTML("<h3>Creator:Jidong Liu</h3>"),
        p("This project is for Coursera DataScience Project ")
    ),
    
    #input 
    fluidRow(        
            textInput("inputString", "Input words:",value = ""),
            submitButton("Predict")
    ),
        
    fluidRow(
        h4("Predicted Next Word"),
        verbatimTextOutput("prediction")
    )
))
