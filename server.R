
library(tm)
library(stringr)
library(shiny)

#load saved model data

wf1<-readRDS("wf1.rds");
wf2<-readRDS("wf2.rds");
wf3<-readRDS("wf3.rds");
wf4<-readRDS("wf4.rds");

#make the input formular
formatInput <- function(input)
{
   input <- iconv(input, "latin1", "ASCII", sub=" ");
   input <- gsub("[^[:alpha:][:space:][:punct:]]", "", input);

   inputCorpus <- VCorpus(VectorSource(input))
   inputCorpus <- tm_map(inputCorpus, content_transformer(tolower))
   inputCorpus <- tm_map(inputCorpus, removePunctuation)
   inputCorpus <- tm_map(inputCorpus, removeNumbers)
   inputCorpus <- tm_map(inputCorpus, stripWhitespace)   
   inputCorpus <- tm_map(inputCorpus, PlainTextDocument)
   input <- as.character(inputCorpus[[1]])
   input <- gsub("(^[[:space:]]+|[[:space:]]+$)", "", input)
   result <- ""

   if (nchar(input) > 0) {
       result<-input
   } 
   result;
}

#predict and return a data frame
predict <- function(rawArgument)
{  
    #format input
    argument <- formatInput(rawArgument);
    argument <- unlist(strsplit(argument, split=" "));
    argumentLen <- length(argument);
    
    found <- FALSE;
    predictTerm <- as.character(NULL);
    
    # 4 grams first
    if (argumentLen >= 3 & !found)
    {        
        argument1 <- paste(argument[(argumentLen-2):argumentLen], collapse=" ");
        searchStr <- paste("^",argument1, sep = "");
        wf4SearchDataFrame <- wf4[grep (searchStr, wf4$term), ];        
        found <- length(wf4SearchDataFrame[, 1]) > 1

        if ( found )
        {
            predictTerm <- wf4SearchDataFrame[1,1];                
        }
        wf4SearchDataFrame <- NULL;
    }

    # 3 grams next
    if (argumentLen >= 2 & !found)
    {        
        argument1 <- paste(argument[(argumentLen-1):argumentLen], collapse=" ");
        searchStr <- paste("^",argument1, sep = "");
        wf3SearchDataFrame <- wf3[grep (searchStr, wf3$term), ];      
        found <- length(wf3SearchDataFrame[, 1]) > 1;
        if ( found )
        {
            predictTerm <- wf3SearchDataFrame[1,1];
        }
        wf3SearchDataFrame <- NULL;
    }

    # 2 grams next
    if (argumentLen >= 1 & !found)
    {
        argument1 <- argument[argumentLen];
        searchStr <- paste("^",argument1, sep = "");
        wf2SearchDataFrame <- wf2[grep (searchStr, wf2$term), ];        
        found <- length(wf2SearchDataFrame[, 1]) > 1;
        if ( found )
        {
            predictTerm <- wf2SearchDataFrame[1,1];
        }
        wf2SearchDataFrame <- NULL;
    }

    #:( 1 gram last
    if (!found & argumentLen > 0)
    {
        predictTerm <- wf1$term[1];
    }

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