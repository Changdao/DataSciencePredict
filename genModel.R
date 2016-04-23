options(java.parameters = "-Xmx3g")

suppressWarnings(library(tm))
suppressWarnings(library(tau))
suppressWarnings(library(stringr))
suppressWarnings(library(R.utils))
suppressWarnings(library(SnowballC))
#suppressWarnings(library(RWeka))
suppressWarnings(library(pryr))
suppressWarnings(library(markdown))
suppressWarnings(library(MASS))
suppressWarnings(library(data.table))

# Create term document matrix
tok1 <- function(x) RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 1, max = 1))
tok2 <- function(x) RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 2, max = 2))
tok3 <- function(x) RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 3, max = 3))
tok4 <- function(x) RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 4, max = 4))

# Define file names with relative folder path
setwd('./')
#Build the DocumentTermMatrix
source <- DirSource("./sample")
YourCorpus <- Corpus(source, readerControl=list(reader=readPlain))
toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, " ", x))})
docs <- tm_map(YourCorpus, toSpace, "-")
docs <- tm_map(docs, toSpace, ":")
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs,stemDocument)
docs <- tm_map(docs, PlainTextDocument)   
dtm1 <- DocumentTermMatrix(docs)
freq1 <- colSums(as.matrix(dtm1))
ord1 <- order(freq1,decreasing=TRUE)
wf1=data.frame(term=names(freq1),occurrences=freq1) 

dtm2 <- DocumentTermMatrix(docs, control = list(tokenize = tok2))
freq2 <- colSums(as.matrix(dtm2))
ord2 <- order(freq2, decreasing = TRUE)
wf2=data.frame(term=names(freq2),occurrences=freq2) 

dtm3 <- DocumentTermMatrix(docs, control = list(tokenize = tok3))
freq3 <- colSums(as.matrix(dtm3))
ord3 <- order(freq3, decreasing = TRUE)
wf3=data.frame(term=names(freq3),occurrences=freq3) 

dtm4 <- DocumentTermMatrix(docs, control = list(tokenize = tok4))
freq4 <- colSums(as.matrix(dtm4))
ord4 <- order(freq4, decreasing = TRUE)
wf4=data.frame(term=names(freq4),occurrences=freq4) 

wf1 <- wf1[wf1$occurrences > 100,]
wf2 <- wf2[wf2$occurrences > 2,]
wf3 <- wf3[wf3$occurrences > 2,]
wf4 <- wf4[wf4$occurrences > 2,]
#I am not sure why order not work .....
wf1<-wf1[with(wf1,order(-occurrences)),]
wf2<-wf2[with(wf2,order(-occurrences)),]
wf3<-wf3[with(wf3,order(-occurrences)),]
wf4<-wf4[with(wf4,order(-occurrences)),]
#convert data frame row name to index
#from stackoverflow http://stackoverflow.com/questions/18375391/changing-row-names-in-to-numerical-index-in-rs-data-frame


setwd('./output')

write.table(wf1,'wf1.tbl',col.names=T)
write.table(wf2,'wf2.tbl',col.names=T)
write.table(wf3,'wf3.tbl',col.names=T)
write.table(wf4,'wf4.tbl',col.names=T)

wf1 <- read.table('wf1.tbl', header = TRUE, stringsAsFactors = FALSE)
wf2 <- read.table('wf2.tbl', header = TRUE, stringsAsFactors = FALSE)
wf3 <- read.table('wf3.tbl', header = TRUE, stringsAsFactors = FALSE)
wf4 <- read.table('wf4.tbl', header = TRUE, stringsAsFactors = FALSE)

rownames(wf1) <- 1:nrow(wf1)
rownames(wf2) <- 1:nrow(wf2)
rownames(wf3) <- 1:nrow(wf3)
rownames(wf4) <- 1:nrow(wf4)

setwd('../')

saveRDS(wf1, file="wf1.rds");
saveRDS(wf2, file="wf2.rds");
saveRDS(wf3, file="wf3.rds");
saveRDS(wf4, file="wf4.rds");
