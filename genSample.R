
suppressWarnings(library(tm))
suppressWarnings(library(stringr))
suppressWarnings(library(R.utils))
suppressWarnings(library(SnowballC))
suppressWarnings(library(data.table))

# Define file names with relative folder path
setwd('./')

blogsFileName <- "./final/en_US/en_US.blogs.txt"
twitterFileName <- "./final/en_US/en_US.twitter.txt"
newsFileName <- "./final/en_US/en_US.news.txt"

textSample <- function(data, size)
{
  dataSize<-length(data)
  sampleSize<-as.integer(size*dataSize)/100
  print(sampleSize)
  index <- sample(1:dataSize, size = sampleSize, replace = F)
  data[index]  
}

##Prepare document
defaulSampleSize<-10
#Sample blogs  and write back to sample dir
blogs <- readLines(blogsFileName, n = -1L, ok = TRUE, warn = FALSE, encoding = "UTF-8", skipNul = FALSE)
sampleBlogs <- textSample(blogs, defaulSampleSize)
sampleBlogs <- iconv(sampleBlogs, "latin1", "ASCII", sub=" ");
fileConn<-file("sample/blogs.txt")
writeLines(sampleBlogs, fileConn)
close(fileConn)
blogs <- NULL


#Sample twitter  and write back to sample dir
twitter <- readLines(twitterFileName, n = -1L, ok = TRUE, warn = FALSE, encoding = "unknown", skipNul = FALSE)
sampleTwitter <- textSample(twitter, defaulSampleSize)
sampleTwitter <- iconv(sampleTwitter, "latin1", "ASCII", sub=" ");
fileConn<-file("sample/twitter.txt")
writeLines(sampleTwitter, fileConn)
close(fileConn)
twitter <- NULL

#Sample news and write back to sample dir
news <- readLines(newsFileName, n = -1L, ok = TRUE, warn = FALSE, encoding = "UTF-8", skipNul = FALSE)
sampleNews <- textSample(news, defaulSampleSize)
sampleNews <- iconv(sampleNews, "latin1", "ASCII", sub=" ");
fileConn<-file("sample/news.txt")
writeLines(sampleTwitter, fileConn)
close(fileConn)
news <- NULL
