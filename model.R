
#install.packages("tm")
#install.packages("topicmodels") #load topic models library
library(tm)
library(topicmodels) #load topic models library

#create a corpus from the vector
docs <- Corpus(VectorSource(as.character(metadata$Description)))

#inspect a particular document in the corpus               
#writeLines(as.character(docs[[30]]))

#PRE-PROCESSING

#Transform to lower case
docs <-tm_map(docs,content_transformer(tolower))

#remove potentially problematic symbols
toSpace <- content_transformer(function(x, pattern){ 
  return (gsub(pattern, " ", x))
  })
docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, toSpace, "'")
docs <- tm_map(docs, toSpace, "`")
docs <- tm_map(docs, toSpace, "”")
docs <- tm_map(docs, toSpace, "“")

#remove punctuation
docs <- tm_map(docs, removePunctuation)

#remove stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, c("right", "left"))

#remove whitespace
docs <- tm_map(docs, stripWhitespace)

#Good practice to check every now and then
writeLines(as.character(docs[[30]]))

#Stem document
docs <- tm_map(docs,stemDocument)

#Create document-term matrix
dtm <- DocumentTermMatrix(docs)

#convert rownames to filenames
rownames(dtm) <- filenames

#collapse matrix by summing over columns
freq <- colSums(as.matrix(dtm))

#length should be total number of terms
length(freq)

#create sort order (descending)
ord <- order(freq,decreasing=TRUE)

#List all terms in decreasing order of freq and write to disk
freq[ord]
write.csv(freq[ord],"word_freq.csv")

#Set parameters for Gibbs sampling (performs a random walk) 
burnin <- 4000 #"burn-in period": discard the first few steps of the walk
iter <- 2000   #perform 2000 iterations
thin <- 500    #take each 500th iteration for further use
seed <-list(2003,5,63,100001,765) 
nstart <- 5    #5 different starting pts (5 independent runs)
best <- TRUE   #instructs the algorithm to return results of the run
               #with the highest posterior probability

#Number of topics: best option from trials using 2 to 10
k <- 3 #decision based on the output probabilities

#dtm has rows with all zeroes because some documents did not contain certain words 
# (i.e. their frequency was zero) but that causes an error in LDA()
raw.sum=apply(dtm,1,FUN=sum) #sum by raw each raw of the table
dtm=dtm[raw.sum!=0,]#remove those rows

#Run LDA using Gibbs sampling
ldaOut <-LDA(dtm,k, method="Gibbs", control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))

#top 20 terms in each topic
ldaOut.terms <- as.matrix(terms(ldaOut,30))
write.csv(ldaOut.terms,file=paste("LDAGibbs",k,"TopicsToTerms.csv"))

#probabilities associated with each topic assignment
topicProbabilities <- as.data.frame(ldaOut@gamma)
write.csv(topicProbabilities,file=paste("LDAGibbs",k,"TopicProbabilities.csv"))

#Find relative importance of top 2 topics
topic1ToTopic2 <- lapply(1:nrow(dtm),function(x)
  sort(topicProbabilities[x,])[k]/sort(topicProbabilities[x,])[k-1])

#Find relative importance of second and third most important topics
topic2ToTopic3 <- lapply(1:nrow(dtm),function(x)
  sort(topicProbabilities[x,])[k-1]/sort(topicProbabilities[x,])[k-2])

#write to file
write.csv(topic1ToTopic2,file=paste("LDAGibbs",k,"Topic1ToTopic2.csv"))
write.csv(topic2ToTopic3,file=paste("LDAGibbs",k,"Topic2ToTopic3.csv"))
