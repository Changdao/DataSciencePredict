
library(tm)
library(stringr)
library(shiny)

#load saved model data

wf1<-readRDS("wf1.rds");
wf2<-readRDS("wf2.rds");
wf3<-readRDS("wf3.rds");
wf4<-readRDS("wf4.rds");



#predict and return a data frame
predict <- function(rawArgument)
{  
    
    predictTerm <- wf1$term[1];
    

    resultTerm <- word(predictTerm, -1);
       
    if (argumentLen <= 0){
        resultTerm <- "";
    }

    resultTerm
}


shinyServer(function(input, output) {
        output$prediction <- renderPrint({            
            formInput <- formatInput(input$inputString);            
            result <- predict(formInput);            
            cat("", as.character(result));            
        })
    }
)